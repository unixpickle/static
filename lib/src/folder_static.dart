part of static;

/**
 * This very basic [Static] subclass serves up files from a certain directory.
 */
class FolderStatic extends Static {
  final String root;
  
  /**
   * Create a [FolderStatic] object with a [root] directory and an optional
   * [aliases] list.
   */
  FolderStatic(this.root, {PathAliasTable aliases: null}) :
    super(aliases: aliases);
  
  /**
   * Concatenates [root] with [path].
   */
  String localPath(String path) {
    return root + path;
  }
}