import 'package:chat_with_me_now/Views/error_view.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _WebShower extends StatefulWidget {
  const _WebShower({super.key, required this.url});
  final String? url;

  @override
  State<_WebShower> createState() => _WebShowerState();
}

class _WebShowerState extends State<_WebShower> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const LinearProgressIndicator(minHeight: 10),
        ],
      );
    } catch (e) {
      return ErrorView();
    }
  }
}

class WebView extends StatelessWidget {
  const WebView({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _WebShower(url: url),
      appBar: AppBar(),
    );
  }
}
