import 'package:flutter/material.dart';

import 'pages/html_viewer_page.dart';
import 'pages/webview/webview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HtmlViewerPage()),
                );
              },
              child: const Text('HTML Viewer Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WebviewPage(
                            titlePage: 'WebView Viewer Page',
                            enableShare: true,
                            url:
                                'https://exame.com/esporte/rebeca-andrade-faz-historia-e-brasil-conquista-bronze-na-ginastica-artistica-nas-olimpiadas/',
                          )),
                );
              },
              child: const Text('WebView Page'),
            ),
          ],
        ),
      ),
    );
  }
}
