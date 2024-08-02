import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final _keyWebviewComponent = GlobalKey<_WebViewWidgetState>();

class WebViewWidget extends StatefulWidget {
  final Uri url;
  final bool enableShare;
  final String urlString;
  final Function(Uint8List bytes)? onTakeScreenshot;

  WebViewWidget({
    required this.url,
    this.urlString = '',
    this.onTakeScreenshot,
    this.enableShare = false,
  }) : super(key: _keyWebviewComponent);

  void takeScreenshot() {
    _keyWebviewComponent.currentState?.takeScreenShot();
  }

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late InAppWebViewController _webViewController;
  int _progress = 0;
  PullToRefreshController? pullToRefreshController;

  final GlobalKey webViewKey = GlobalKey();

  final bool _enableBackButton = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (Platform.isAndroid) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(true);
        }
      },
    );

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                await _webViewController.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                await _webViewController.loadUrl(
                  urlRequest: URLRequest(url: await _webViewController.getUrl()),
                );
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void takeScreenShot() {
    _webViewController
        .takeScreenshot(
      screenshotConfiguration: ScreenshotConfiguration(
        afterScreenUpdates: true,

        // rect: InAppWebViewRect(height: 2000, x: 0, y: 0, width: 375),
      ),
    )
        .then((bytes) async {
      final len = bytes?.lengthInBytes;
      debugPrint('screenshot taken bytes $len');
      if (bytes != null) widget.onTakeScreenshot?.call(bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(
            url: WebUri.uri(widget.url),
          ),
          pullToRefreshController: pullToRefreshController,
          onLoadStart: (controller, uri) async {
            // Recupera a URL após o carregamento da página
            log('URL atual: $uri');
          },
          onWebViewCreated: (InAppWebViewController controller) async {
            _webViewController = controller;

            // await _webViewController.clearCache();
          },
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          onProgressChanged: (controller, progress) async {
            setState(() {
              _progress = progress;
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            log('WEBVIEW-LOG: $consoleMessage');
          },
          onPrintRequest: (controller, uri, jobController) async {
            log('WEBVIEW-PRINT: ${uri?.data}');
            return true;
          },
          onDownloadStartRequest: (controller, request) {
            log('LOG: onPageCommitVisible $request');
          },
          onPageCommitVisible: (controller, uri) {
            log('LOG: onPageCommitVisible $_progress');
            if (_progress < 15) {
              // setState(() {
              //   _enableBackButton = false;
              // });
            }
          },
          onLoadStop: (controller, url) async {
            log('LOG: onLoadStop $_progress');
          },
          // onDownloadStart: (controller, url) async {
          //   log("LOG: onLoadStop $_progress");
          // },
          initialSettings: InAppWebViewSettings(
            useHybridComposition: true,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            allowContentAccess: true,
            allowFileAccess: true,
            loadsImagesAutomatically: true,
            useWideViewPort: true,
            hardwareAcceleration: false,
            allowsAirPlayForMediaPlayback: false,
            allowsInlineMediaPlayback: true,

            // useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
            javaScriptEnabled: true,
            incognito: true,
            clearCache: true,
            javaScriptCanOpenWindowsAutomatically: false,
            // cacheMode: AndroidCacheMode.LOAD_DEFAULT,
            // clearSessionCache: true,
          ),

          onPermissionRequest: (InAppWebViewController controller, PermissionRequest request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
        ),
        if (_progress < 51)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_progress == 100 ? 'Aguarde...' : '$_progress %', style: textTheme.titleMedium),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        if (_enableBackButton)
          Positioned(
            right: 12,
            top: 12,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                await _webViewController.goBack();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffC1C1C1),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.close,
                    color: Color(0xff000000),
                  ),
                ),
              ),
            ),
          ),
        if (widget.enableShare)
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: takeScreenShot,
              icon: Icon(
                FontAwesomeIcons.shareNodes,
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
