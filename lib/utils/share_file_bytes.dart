import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareFileBytes(Uint8List bytes) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/comprovante.png';

  await File(filePath).writeAsBytes(bytes);
  await Share.shareXFiles([XFile(filePath)]);
}

Future<void> shareUri(String uri) async {
  await Share.shareUri(Uri.parse(uri));
}
