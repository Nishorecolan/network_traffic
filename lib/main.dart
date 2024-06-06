import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/io_client.dart';
import 'package:http/io_client.dart';
import 'package:http/io_client.dart';
import 'package:http/io_client.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'ProxiedClient.dart';
import 'package:http/io_client.dart' as httpIOClient;






void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  // HttpOverrides.global=httpProxy;
  // print('httpProxy :==>$httpProxy');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaseLine 1',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Baseline - 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late TextEditingController textEditingController;
  String _strGetAPICall = 'Call GET API';
  String _strDummyGetAPICall = 'Call Dummy GET API';
  String _strPostAPICall = 'Call POST API';
  String _strOAuthGetAPICall = 'Call OAuth GET API';
  Dio objDio = Dio();

  static Map<String, dynamic> harTemplate2 =  Map<String, dynamic>();

  @override
  void initState() {
    super.initState();
   SchedulerBinding.instance.addPostFrameCallback((_) => callInitialData());




  }

  callInitialData() async{
    await showAlertDialog();

    // objDio.httpClientAdapter = IOHttpClientAdapter(createHttpClient:() {
    //   final client = HttpClient();
    //   //client.findProxy = (uri) { return 'PROXY 192.168.2.14:8000'; };
    //   client.findProxy = (uri) { return 'PROXY 192.168.20.92:8000'; }; //Mob
    //   client.badCertificateCallback =
    //   ((X509Certificate cert, String host, int port) => true);
    //   return client;
    // },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed:() async {
              print('share clicked');
              showAlertDialog();
              //shareHARFile();
            },
            icon:const Icon(Icons.share,
            size: 25),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test - Network Traffic',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
            ),

            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    changeButtonStatus(true,'Loading...');
                    callGetAPI();
                  },
                  child: Text(_strGetAPICall),
                ),
                SizedBox(width: 5,),
                ElevatedButton(onPressed: (){
                  changeButtonStatus(false,'Loading...');
                  callPostAPI();
                },
                  child: Text(_strPostAPICall),
                )
              ],
            ),
            ElevatedButton(

              onPressed: (){
                changeButtonStatus(false,'Loading...', isDummyGetCall: true);
                callDummyGetAPI();
              },
              child: Text( _strDummyGetAPICall),
            ),
            SizedBox(height: 50,),

            ElevatedButton(

              onPressed: (){
                changeButtonStatus(false,'Loading...', isOAuthGETCall: true);
                callOAuthGetAPI();
              },
              child: Text( _strOAuthGetAPICall),
            ),
            SizedBox(height: 50,),


          ],
        ),
      ),
    );
  }

  shareHARFile() async {
    if(harTemplate2.isNotEmpty) {
      String harJson = jsonEncode(harTemplate2);
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/network_log15.har';
      File file = File(filePath);
      if (!await file.exists()) {
        await file.create(recursive: true);
        file.writeAsStringSync(harJson);
      }
      ShareExtend.share(file.path, "Shared HAR file");
    }
  }

  void callGetAPI() async{

    try{
      var response = await objDio.get('https://mdl.beta1mynyl.newyorklife.com/VSCRegWebApp/mobile/config');
      print('Get API response :==>$response');
      showToastMessage('Get API - Status code :==> ${response.statusCode}\n response :==>$response');
      changeButtonStatus(true,'Call GET API');
    }catch(ex){
      print('Exception :==> $ex');
      showToastMessage('Get API - exception :==> ${ex}');
      changeButtonStatus(true,'Call GET API');
    }

  }
  void callDummyGetAPI() async{
    try{
      var response = await objDio.get('https://reqres.in/api/users?page=2');
      print('Get API response :==>$response');
      showToastMessage('Get API - Status code :==> ${response.statusCode}\n response :==>$response');
      changeButtonStatus(false,'Call Dummy GET API', isDummyGetCall: true);
    }catch(ex){
      print('Exception :==> $ex');
      showToastMessage('GET Dummy API - exception :==> ${ex}');
      changeButtonStatus(false,'Call Dummy GET API', isDummyGetCall: true);
    }

  }

  void callOAuthGetAPI() async{
    try{
      var response = await objDio.get('https://mdl.beta1mynyl.newyorklife.com/ss/dashboard-1/api/v1/portfolio');
      print('Get OAuth API response :==>$response');
      showToastMessage('OAuth Get API - Status code :==> ${response.statusCode}\n response :==>$response');
      changeButtonStatus(false,'Call OAuth GET API', isOAuthGETCall: true);
    }catch(ex){
      print('Exception :==> $ex');
      showToastMessage('Get OAuth  API - exception :==> ${ex}');
      changeButtonStatus(false,'Call OAuth GET API', isOAuthGETCall: true);
    }

  }

   showAlertDialog(){
    textEditingController = TextEditingController();
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your IP address'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(hintText: "XXX.XX.XX.XXX",

            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {

                ///Working code P1////
                // objDio.httpClientAdapter = IOHttpClientAdapter(createHttpClient:() {
                //   final client = HttpClient();
                //   //client.findProxy = (uri) { return 'PROXY 192.168.2.14:8000'; };
                //   // client.findProxy = (uri) { return 'PROXY 192.168.20.92:8000'; }; //Mob
                //   client.findProxy = (uri) { return 'PROXY ${textEditingController.text.trim().toString()}:8000'; }; //Mob
                //   if(Platform.isAndroid)
                //    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
                //   return client;
                // },);
                ///Working code P1////

                ///Working code P2////
                // Configure the proxy
                // (objDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
                //   client.findProxy = (uri) { return 'PROXY ${textEditingController.text.trim().toString()}:8000'; };
                //   if(Platform.isAndroid) {
                //     client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
                //   }
                //   return client;
                // };
                ///Working code P2////


                ///Working code for DIO////
                objDio.httpClientAdapter = IOHttpClientAdapter(createHttpClient:() { return customHttpClient();});
                ///Working code for DIO////

                ///Working code for Proxy////
                getOAuth2ProxyClient();


                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  HttpClient customHttpClient() {
    final client = HttpClient();
    client.findProxy = (uri) { return 'PROXY ${textEditingController.text.trim().toString()}:8000'; };
    if(Platform.isAndroid) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    }
    return client;
  }

  http.Client createHttpClient() {
    return httpIOClient.IOClient(customHttpClient());
  }

  void getOAuth2ProxyClient() async {
    final client = createHttpClient();
    final authorizationEndpoint = Uri.parse('https://mdl.pfed.newyorklife.com/as/authorization.oauth2');
    final tokenEndpoint = Uri.parse('https://mdl.pfed.newyorklife.com/as/token.oauth2');
    final identifier = 'MDL_OAUTH_CLIENT_ID';
    final secret = 'MDL_OAUTH_CLIENT_SECRET';
    final redirectUrl = Uri.parse('https://mdl.mynyl.services.newyorklife.com/ss/*');

    final grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
      httpClient: client
    );
    final authorizationUrl = grant.getAuthorizationUrl(redirectUrl);
    print('Please go to the following URL and grant access:');
    print(authorizationUrl);

    final responseUrl = Uri.parse('https://mdl.beta1mynyl.newyorklife.com/ss/dashboard-1/api/v1/portfolio');
    final clientWithCredentials = await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    print('clientWithCredentials GET OAuth API - exception :==>${clientWithCredentials}');

    final result = await clientWithCredentials.read(Uri.parse('https://mdl.beta1mynyl.newyorklife.com/ss/dashboard-1/api/v1/portfolio'));
    print('GET OAuth API - exception :==>${result}');
    showToastMessage('GET OAuth API - exception :==> ${result}');

    clientWithCredentials.close();
    client.close();



    ////
    // var oAuth2Helper = OAuth2Helper(
    //   GoogleOAuth2Client(
    //       redirectUri: 'https://mdl.mynyl.services.newyorklife.com/ss/*',
    //       customUriScheme: 'com.teranet.app'),
    //   grantType: OAuth2Helper.authorizationCode,
    //   clientId: identifier,
    //   clientSecret: secret,
    //   scopes: ['openid','nylGenericScope-Employee'],
    // );
    //
    // var resp = await oAuth2Helper.get('https://mdl.beta1mynyl.newyorklife.com/ss/dashboard-1/api/v1/portfolio');
    //
    // print('GET OAuth API - exception :==>${resp.body}');
    // showToastMessage('GET OAuth API - exception :==> ${resp.body}');

  }

  void callPostAPI() async{
    try {
      var response = await objDio.post(
        'https://mdl.beta1mynyl.newyorklife.com/VSCRegWebApp/mobile/registration/verifyPersonalInfo',
        data: {
          "ssn": "6156",
          "dateOfBirth": "1962-10-16",
          "lastName": "Piittman",
          "clientId": ""
        },
        options: Options(
            headers: {Headers.contentTypeHeader: Headers.jsonContentType}),
      );
      print('POST API response :==>$response');
      showToastMessage('POST API response :==>${response
          .statusCode}\n response :==>$response');
      changeButtonStatus(false, 'Call POST API');
    }catch(ex){
      showToastMessage('POST API - exception :==> ${ex}');
      changeButtonStatus(false, 'Call POST API');
    }
  }

  changeButtonStatus(isGetCall, String msg, {bool isDummyGetCall = false,bool isOAuthGETCall = false}){
    setState(() {
      if(isGetCall)
        _strGetAPICall = msg;
      else if(isDummyGetCall)
        _strDummyGetAPICall = msg;
      else if(isOAuthGETCall)
        _strOAuthGetAPICall = msg;
      else
        _strPostAPICall = msg;

    });
  }

  showToastMessage(String msg){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(msg),
    ));
  }
}


class HarEntry {
  final String request;
  final String response;
  final int time;

  HarEntry(this.request, this.response, this.time);
}

class DioInterceptor extends Interceptor {
  final List<HarEntry> entries = [];
  var startTime,request;
  late List<Map<String, dynamic>> logEntries2 = [];
  Map<String, String> getHeadersAsMap(Headers headers) {
    final map = <String, String>{};
    headers.forEach((key, value) => map[key] = value.first);
    return map;
  }
  Headers convertIterableToHeaders(Iterable<MapEntry<String, dynamic>> entries) {
    final headers = Headers();
    for (final entry in entries) {
      headers.add(entry.key, entry.value);
    }
    return headers;
  }
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startTime = DateTime.now();
    request= {
    "method": options.method.toString(),
    "url": options.uri.toString(),
    "httpVersion": "HTTP/1.1",
  // "headers": [getHeadersAsMap(convertIterableToHeaders(options.headers.entries))],
     "headers":  [{"name":"Content-Type","value":"application/json"}],
    "queryString": [],
    "cookies": [],
    "headersSize": -1,
    "bodySize": -1,
    "postData": {
    "mimeType": "application/json",
    "text": jsonEncode(options.data)
    }
    };

    super.onRequest(options, handler);
  }
  @override
  void onResponse(Response res, ResponseInterceptorHandler handler) {
    final endTime = DateTime.now();
    final time = endTime.difference(startTime).inMilliseconds;
    var  response =   {
      "status": 200,
    "statusText": "OK",
    "httpVersion": "HTTP/1.1",
    "headers": [
     {"name": "Content-Type", "value": "application/json"}
    ],
    "cookies": [],
    "content": {
    "size": 500,
    "mimeType": "application/json",
    "text": jsonEncode(res.data)
  },
    "redirectURL": "",
    "headersSize": -1,
    "bodySize": -1,
      "cache": {},
      "timings": {
        "send": 50,
        "wait": 100,
        "receive": 50
      }
  };
    entries.add( HarEntry(jsonEncode(request), jsonEncode(response), time));



    logEntries2.add({
      "startedDateTime": "2023-05-21T12:00:00.000Z",
      "time": 200,
      "request": request,
      "response": response,
    }, );
    saveHarFile();


    return super.onResponse(res, handler);
  }

  void onError(DioException err, ErrorInterceptorHandler handler) async {
    handler.next(err);
  }

  List<Map<String, dynamic>> convertHarEntriesToJson(List<HarEntry> entries) {
    final jsonData = entries.map((entry) => {
      'request': jsonDecode(entry.request),
      'response': jsonDecode(entry.response),
      'time': entry.time,
    }).toList();
    return jsonData;
  }
  Future<void> saveHarFile() async {

    MyHomePageState.harTemplate2 = {
      "log": {
        "version": "1.2",
        "creator": {
          "name": "Custom Logger",
          "version": "1.0"
        },
        "entries": logEntries2
      }
    };
  }
}

// class ProxiedClient extends http.BaseClient {
//    HttpClient _httpClient = HttpClient()
//     ..findProxy = (uri) { return "PROXY 192.168.2.14:8000"; }
//     ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow self-signed certificates
//
//   final httpIOClient.IOClient? _client;
//
//   ProxiedClient() : _client = httpIOClient.IOClient(HttpClient());
//
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest? request) {
//     return _client!.send(request!);
//   }
// }
