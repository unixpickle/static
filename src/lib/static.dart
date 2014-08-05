part of static;

/**
 * An abstract class which serves up static files. Subclass this class to
 * translate web URI paths to local filesystem paths. Subclasses may optionally
 * provide their own path validation mechanism as well.
 */
abstract class Static {
  final PathAliasTable aliases;
  
  Static({this.aliases: null});
  
  /**
   * Serve the file requested by an HTTP remote end. This returns a [Future]
   * which completes when the file has been transferred.
   * 
   * If an error occurs before or during the transfer, the returned [Future]
   * will fail with an appropriate error. Normally, this error will be a
   * [StaticError] object which will indicate whether the request stream is
   * still usable or not.
   */ 
  Future serveFile(HttpRequest request) {
    String path = request.uri.path;
    
    // forward the path
    if (aliases != null) {
      path = aliases.forwardPath(path);
    }
    
    // validate the path
    if (!validatePath(path)) {
      StaticError err = new StaticError(404, 'invalid path: $path', false);
      return new Future.error(err);
    }
    
    String relPath = localPath(path);
    Completer c = new Completer();
    File f = new File(relPath);
    bool beganWriting = false;
    
    // attempt to get the file's information
    f.stat().then((FileStat info) {
      if (info.type == FileSystemEntityType.NOT_FOUND) {
        throw new StaticError(404, 'not found: $path', false);
      } else if (info.type != FileSystemEntityType.FILE) {
        throw new StaticError(404, 'not a file: $path', false);
      }
    }).then((_) {
      // attempt to open the file
      return f.openRead();
    }).then((Stream<List<int>> stream) {
      beganWriting = true;
      
      // compute the MIME type
      String typeName = lookupMimeType(path);
      if (typeName == null) typeName = 'text/plain';
      ContentType type = ContentType.parse(typeName);
      request.response.headers.contentType = type;
      
      // attempt to pipe the file
      return new File(relPath).openRead().pipe(request.response);
    }).then((_) {
      c.complete(); // success!
    }).catchError((e) {
      // handle any errors
      if (e is StaticError) {
        c.completeError(e);
        return;
      }
      c.completeError(new StaticError(500, 'unable to read file', beganWriting,
          error: e));
    });
    return c.future;
  }
  
  /**
   * Validate a requested path. Returns `true` if the path is valid. By default,
   * this prevents ".." path elements and only allows letters, numbers, dots,
   * slashes, underscores, and @ signs.
   */
  bool validatePath(String path) {
    if (path.contains('..')) return false;
    if (!(new RegExp(r'^\/?[\/a-z\.A-Z0-9_@]*$')).hasMatch(path)) {
      return false;
    }
    return true;
  }
  
  /**
   * A subclass must override this method to return a local file path for a
   * requested path.
   */
  String localPath(String remotePath);
}
