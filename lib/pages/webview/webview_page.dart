import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/share_file_bytes.dart';
import 'web_view_widget.dart';

class WebviewPage extends StatelessWidget {
  const WebviewPage({
    super.key,
    required this.url,
    this.onBackPressed,
    this.titlePage,
    this.enableAppar = true,
    this.enableShare = false,
  });
  final String url;
  final String? titlePage;
  final bool enableAppar;
  final bool enableShare;

  Uri get uriParse => Uri.parse(url);

  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final webViewWidget = WebViewWidget(
      url: uriParse,
      urlString: url,
      enableShare: false,
      onTakeScreenshot: (bytes) => shareFileBytes(bytes),
    );
    return Scaffold(
      appBar: !enableAppar
          ? null
          : AppBar(
              backgroundColor: colorScheme.surface,
              iconTheme: IconThemeData(color: colorScheme.primary),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 16,
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    onTap: () {
                      if (onBackPressed != null) {
                        return onBackPressed?.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  if (titlePage != null)
                    Expanded(
                      child: Text(
                        titlePage ?? '',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  if (enableShare)
                    InkWell(
                      onTap: () => webViewWidget.takeScreenshot(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.shareNodes,
                            color: colorScheme.primary,
                            size: 16,
                          ),
                        ],
                      ),
                    )
                  else ...[
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      FontAwesomeIcons.shareNodes,
                      color: Colors.transparent,
                      size: 16,
                    ),
                  ],
                ],
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              surfaceTintColor: colorScheme.surfaceTint,
              actions: [
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: url));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to Clipboard'),
                      ),
                    );
                  },
                  icon: Icon(
                    FontAwesomeIcons.copy,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
      body: webViewWidget,
    );
  }
}
