public class FolderSelector extends fflib_SObjectSelector implements IFolderSelector {

    public static IFolderSelector newInstance()
    {
        return (IFolderSelector) Application.Selector.newInstance(Folder.SObjectType);
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Folder.Id,
                Folder.Name,
                Folder.Type
                };
                    }

    public Schema.SObjectType getSObjectType()
    {
        return Folder.sObjectType;
    }

    public List<Folder> selectById(Set<ID> idSet)
    {
        return (List<Folder>) selectSObjectsById(idSet);
    }
    public List<Folder> selectByType(string folderType) {

        fflib_QueryFactory folderQueryFactory = newQueryFactory();
        folderQueryFactory.setCondition('Type = :folderType');
        return Database.query(folderQueryFactory.toSOQL());

    }
}