public interface IFolderSelector extends fflib_ISObjectSelector  {
    List<Folder> selectById(Set<ID> idSet);
    List<Folder> selectByType(string folderType) ;
}