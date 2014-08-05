/**
 * A simple utility for serving static files over an [HttpServer].
 * 
 * You can serve up files from a certain directory as follows:
 * 
 *     HttpServer.bind('127.0.0.1', 1337).then((HttpServer server) {
 *       var static = new FolderStatic('/my/static/path');
 *       server.listen((HttpRequest request) {
 *         static.serveFile(request);
 *       });
 *     });
 * 
 * Note that this is a very simplistic example which does not handle any errors.
 */
library static;

import 'dart:io';
import 'dart:async';
import 'package:mime/mime.dart';

part 'src/static.dart';
part 'src/static_error.dart';
part 'src/alias_table.dart';
part 'src/project_static.dart';
part 'src/folder_static.dart';
