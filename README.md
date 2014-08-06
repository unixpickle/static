# static

**static** is a simple library for serving static files over HTTP. It supports directory-based file serving, and it uses a `Future`-based mechanism to report errors. What more could you want?

# Example

Examples can be found in the [test/](test) folder.

The following example shows how to serve files from the current directory. This particular example uses a `PathAliasTable` to allow case insensitive versions of "/sample" and "/sample.jpg" to serve the file named "sample.jpg":

    import 'package:static/static.dart';
    import 'dart:io';
    
    void main() {
      HttpServer.bind('127.0.0.1', 1337).then((HttpServer server) {
        var aliases = new PathAliasTable();
        aliases.add('/sample', '/sample.jpg', caseSensitive: false);
        aliases.add('/sample.jpg', '/sample.jpg', caseSensitive: false);
        var static = new FolderStatic('.', aliases: aliases);
        print('attempt to navigate to http://localhost:1337/Sample.jpg');
        server.listen((HttpRequest request) {
          static.serveFile(request).catchError((e) {
            if (e is StaticError) {
              StaticError err = e as StaticError;
              if (!err.beganSending) {
                print('got error processing request: $err');
                request.response.statusCode = err.code;
                request.response.writeln(err.toString());
                request.response.close();
              } else {
                print('got error mid-transfer: $err');
              }
            }
          });
        });
      });
    }

In this example, if the user attempts to load a path that does not exist, "got error processing request: **...**" will print to the console and the server will respond with an appropriate error message and a 404 status code.
