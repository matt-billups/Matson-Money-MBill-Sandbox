global with sharing class CleanseDataWorker implements IDataCleansingService, Database.Batchable<sObject> {

    private String Query;
    private String DependentCleanQuery;
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(Query);
    }

    global void execute(Database.BatchableContext context, List<sObject> scope) {
        if (scope.size() < 1) {
            return;
        }

        fflib_ISObjectDomain domain = Application.Domain.newInstance(scope);

        if (domain instanceof ICleansable) {
            ICleansable cleansableDomain = (ICleansable)domain;
            cleansableDomain.cleanseData();
        }
    }
    
    global void finish(Database.BatchableContext context) {
        if (!String.isBlank(DependentCleanQuery)) {
            Query = DependentCleanQuery;
            DependentCleanQuery = '';
            Database.executeBatch(this, 200);
        }
    }

    public void cleanse(String q, String q2) {
        Query = q;
        DependentCleanQuery = q2;
        Database.executeBatch(this, 200);
    }
}