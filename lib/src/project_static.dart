part of static;

/**
 * Some Dart projects are organized with a "web/" directory and a "packages/"
 * directory. This [Static] subclass serves packages from a "packages/" 
 * directory while also serving files from a "web/" directory.
 */
class ProjectStatic extends Static {
  /**
   * The project root directory. This directory contains the "packages/"
   * directory. This path should not end with a "/".
   */
  final String projectRoot;
  
  /**
   * The web root. This path should not end with a "/".
   */
  final String webRoot;
  
  /**
   * Create a [ProjectStatic] server with a [projectRoot] and a [webRoot].
   */
  ProjectStatic(this.projectRoot, this.webRoot, 
      {PathAliasTable aliases: null}) : super(aliases: aliases);
  
  /**
   * Returns the local path for a requested path. If the requested path begins
   * with "/packages", the return value is equivalent to `projectRoot + path`.
   * Otherwise, it is `webRoot + path`.
   */
  String localPath(String path) {
    if ('/packages'.matchAsPrefix(path) != null) {
      return projectRoot + path;
    } else {
      return webRoot + path;
    }
  }
}