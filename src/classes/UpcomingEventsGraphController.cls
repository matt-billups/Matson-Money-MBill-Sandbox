public class UpcomingEventsGraphController {
    @AuraEnabled 
    public static chartData getChartData() {
        List<Event_Registration__c> eventRegs = matsonEventRegistrationsSelector().selectFutureRegistrationsWithEventFields();
        chartData data = new chartData();
        
        List<String> statusesToGraph = new List<String> { 'Invited', 'Registered', 'Cancelled' };
        for (Event_Registration__c reg : eventRegs) {
            String regStatus = reg.Status__c;
            String eventName = reg.Event__r.Internal_Event_Name__c;
            String eventStatus = reg.Event__r.Event_Status__c;
            
            if (statusesToGraph.contains(regStatus) && eventName != null && eventStatus != 'Cancelled') {
                
                if (!data.statuses.contains(regStatus)) {
                    data.statuses.add(regStatus);
                    data.counts.add(new List<Integer>());
                    
                    Integer index = data.statuses.indexOf(regStatus);
                    for (String n : data.eventNames) {
                        data.counts[index].add(0);
                    }
                }
                
                if (!data.eventNames.contains(eventName)) {
                    data.eventNames.add(eventName);
                    
                    for (String s : data.statuses) {
                        Integer index = data.statuses.indexOf(s);
                        data.counts[index].add(0);
                    }
                }
                
                Integer statusIndex = data.statuses.indexOf(regStatus);
                Integer eventIndex = data.eventNames.indexOf(eventName);
                data.counts[statusIndex][eventIndex] += 1;
            }
        }
        
        return data;
    }
    
    private static IMatsonEventRegistrationsSelector matsonEventRegistrationsSelector() {
        return (IMatsonEventRegistrationsSelector)Application.Selector.newInstance(Event_Registration__c.SObjectType);
    }
    
    public class chartData {
        @AuraEnabled  public List<String> statuses;
        @AuraEnabled  public List<String> eventNames;
        @AuraEnabled  public List<List<Integer>> counts;
        
        public chartData() {
            statuses = new List<String>();
            eventNames = new List<String>();
            counts = new List<List<Integer>>();
        }
    }
}