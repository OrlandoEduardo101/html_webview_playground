import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/html_utils.dart';

class HtmlViewerWidget extends StatefulWidget {
  const HtmlViewerWidget({
    super.key,
    required this.textString,
    this.showExcerpt = true,
    this.showImg = true,
    this.needsEllipsis = false,
    this.showPadding = true,
    this.textStyle,
  });
  final String textString;
  final bool showExcerpt;
  final bool showImg;
  final bool showPadding;
  final bool needsEllipsis;
  final TextStyle? textStyle;

  @override
  State<HtmlViewerWidget> createState() => _HtmlViewerWidgetState();
}

class _HtmlViewerWidgetState extends State<HtmlViewerWidget> {
  // late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Inicialize o controlador da WebView para a plataforma correta
    // webview_flutter ainda não funciona pra macos e windows
    // _controller = WebViewController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    String text = transformHtml(widget.textString);

    const descriptionFontSize = 14.0;

    final descriptionText = text.replaceAll('<p><br></p>', '');

    return HtmlWidget(
      descriptionText,
      textStyle: widget.textStyle ?? theme.bodyMedium!.copyWith(fontSize: descriptionFontSize, height: 1.3),
      customStylesBuilder: (element) {
        if (element.localName == 'img' && element.attributes['style'] != null) {
          final style = element.attributes['style']!;
          if (style.contains('border-radius')) {
            final radiusValue = _extractBorderRadius(style);
            return {
              'border-radius': radiusValue,
              'display': 'block',
              'margin-left': 'auto',
              'margin-right': 'auto',
            };
          }
        }
        return null;
      },
      customWidgetBuilder: (element) {
        if (!widget.showImg && (element.localName == 'iframe' || element.localName == 'img')) {
          return const SizedBox.shrink(); // Retorna um widget vazio para ocultar o iframe
        }

        final style = element.attributes['style'] ?? '';

        if (style.contains('border-radius')) {
          final radiusValue = _extractBorderRadius(style);
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(double.parse(radiusValue)),
              child: Image.network(
                element.attributes['src']!,
                width: double.tryParse(element.attributes['width'] ?? '100'),
                height: double.tryParse(element.attributes['height'] ?? '100'),
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return null;
      },
      onTapUrl: (url) {
        Link().open(url);
        return true;
      },
    );
  }

  String _extractBorderRadius(String style) {
    final borderRadiusRegex = RegExp(r'border-radius\s*:\s*([0-9]+)%');
    final match = borderRadiusRegex.firstMatch(style);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    }
    return '0';
  }
}

class MyWidgetFactory extends WidgetFactory {}

class Link {
  factory Link() => _instance;
  Link._();
  static final _instance = Link._();

  Future<void> open(String? url) async {
    if (url == null || !(await canLaunchUrl(Uri.parse(url)))) {
      return;
    }

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
