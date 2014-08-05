import '../src/static.dart';
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
            print('got handled $err');
            request.response.statusCode = err.code;
            request.response.writeln(err.toString());
            request.response.close();
          } else {
            print('got unhandled $err');
          }
        }
      });
    });
  });
}
