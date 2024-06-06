import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioClient;
import 'package:oauth2/oauth2.dart' as oauth2;


class ProxiedClient extends http.BaseClient {
  final HttpClient _httpClient = HttpClient()
    ..findProxy = (uri) {
      return 'PROXY 192.168.2.14:8000';
    }
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates

  final ioClient.IOClient _client;

  ProxiedClient() : _client = ioClient.IOClient(HttpClient());

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }
}