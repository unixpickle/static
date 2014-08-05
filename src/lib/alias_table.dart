part of static;

/**
 * A representation of a path which acts as an alias for another path.
 */
class PathAlias {
  final String sourcePath;
  final String destPath;
  final bool caseSensitive;
  
  PathAlias(this.sourcePath, this.destPath, this.caseSensitive);
  
  bool matches(String path) {
    if (caseSensitive) {
      return sourcePath == path;
    } else {
      return sourcePath.toLowerCase() == path.toLowerCase();
    }
  }
}

/**
 * A list of path aliases. This is useful for linking URLs without extensions
 * to files with extensions. For example, you might want to have "/home" serve
 * the file that would normally be served by the URL "/home.html".
 */
class PathAliasTable {
  /**
   * The list of aliases.
   */
  final List<PathAlias> aliases;
  
  /**
   * Create an empty path alias table.
   */
  PathAliasTable() : aliases = <PathAlias>[];
  
  /**
   * Add an alias from [source] to [dest]. Optionally, you may specify
   * [caseSensitive] to determine whether [source] should be checked in a
   * case-insensitive way.
   * 
   * For example, to forward "/home" to the file "/home.html" in a
   * case-insensitive way, you could do:
   * 
   *     table.add('/home', '/home.html', caseSensitive: false);
   * 
   */ 
  void add(String source, String dest, {bool caseSensitive: true}) {
    aliases.add(new PathAlias(source, dest, caseSensitive));
  }
  
  /**
   * Check if [path] corresponds to any aliases and return the destination path.
   * If no alias matches [path], it will be returned unmodified.
   */
  String forwardPath(String path) {
    for (PathAlias rule in aliases) {
      if (rule.matches(path)) {
        return rule.destPath;
      }
    }
    return path;
  }
}
