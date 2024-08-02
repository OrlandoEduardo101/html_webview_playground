import 'package:flutter/material.dart';
import 'package:html_webview_playground/widgets/html_viewer_widget.dart';

import '../shared/example_html.dart';

class HtmlViewerPage extends StatelessWidget {
  const HtmlViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTML Viewer'),
      ),
      body: const SingleChildScrollView(child: HtmlViewerWidget(textString: htmlExample)),
    );
  }
}
