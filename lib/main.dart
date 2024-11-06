import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

Future<Map> getData() async {
  final urlApi = dotenv.env['URL_API'];
  final apiKey = dotenv.env['KEY_API'];

  if (urlApi == null || apiKey == null) {
    throw Exception('URL_API ou API_KEY não está definida no arquivo .env');
  }

  final request = "$urlApi/finance/quotations?key=$apiKey";

  http.Response response = await http.get(Uri.parse(request));

  return (json.decode(response.body));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Container(color: Colors.green);
              }
          }
        },
      ),
    );
  }
}
