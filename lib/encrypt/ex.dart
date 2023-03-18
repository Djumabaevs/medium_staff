import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart' as dio;
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileModel {
  final SendPort sendPort;
  final dio.Response<dynamic> response;
  final String savePath;

  DownloadVideoModel({
    required this.response,
    required this.sendPort,
    required this.savePath,
  });
}

class DownloadFile {
  dio.Dio request = dio.Dio();
  void downloadNewFile(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    String appDocPath = dir.path;
    var resp = await request.get(
      url,
      options: dio.Options(
        responseType: dio.ResponseType.bytes,
        followRedirects: false,
      ),
      onReceiveProgress: (receivedBytes, totalBytes) {
        print(receivedBytes / totalBytes);
      },
    );
    ReceivePort port = ReceivePort();
    Isolate.spawn(
      whenDownloadCompleted,
      DownloadFileModel(
          response: resp, sendPort: port.sendPort, savePath: appDocPath),
    );
    port.listen((encryptedFilePath) {
      print(encryptedFilePath);
      port.close();
    });
  }
}

class MyEncrypt {
  static final myKey = Key.fromUtf8('TechWithVPTechWithVPTechWithVP12');
  static final myIv = IV.fromUtf8('VivekPanacha1122');
  static final myEncrypt = Encrypter(AES(myKey));
}

void whenDownloadCompleted(DownloadVideoModel model) async {
  SendPort sendPort = model.sendPort;
  var encryptResult =
      MyEncrypt.myEncrypt.encryptBytes(iv: MyEncrypt.myIv, model.response.data);
  File encryptedFile = File("${model.savePath}/myFile.aes");
  encryptedFile.writeAsBytes(encryptResult.bytes);
  sendPort.send(encryptedFile.absolute.path);
}
