import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IntasendWebView extends StatefulWidget {
  final String url;
  const IntasendWebView({super.key, required this.url});

  @override
  State<IntasendWebView> createState() => _IntasendWebViewState();
}

class _IntasendWebViewState extends State<IntasendWebView> {
  String? _url;
  WebViewController? _webViewController;
  bool _isLoading = false;
  double _progress = 0;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        setState(() {
          _webViewController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..enableZoom(false)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onUrlChange: (change) {
                  debugPrint(change.url);
                  setState(() {
                    _url = change.url;
                  });
                },
                onProgress: (int progress) {
                  setState(() {
                    _progress = (progress / 100).toDouble();
                    _isLoading = true;
                  });
                },
                onPageFinished: (String url) {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onWebResourceError: (WebResourceError error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        error.description,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url
                      .startsWith('https://intasend.com/security/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(_url!));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _url == widget.url,
      onPopInvoked: (didPop) {
        _webViewController!.goBack();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Intasend CheckOut"),
        ),
        body: _webViewController == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_isLoading) LinearProgressIndicator(value: _progress),
                  Expanded(
                      child: WebViewWidget(controller: _webViewController!)),
                ],
              ),
        // bottomNavigationBar: BottomAppBar(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       IconButton(
        //         icon: const Icon(Icons.arrow_back_ios_rounded),
        //         onPressed: () {
        //           if (_url == widget.url) {
        //             _showBackDialog();
        //           } else {
        //             _webViewController!.goBack();
        //           }
        //         },
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.autorenew_rounded),
        //         onPressed: () {
        //           _webViewController!.reload();
        //         },
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.arrow_forward_ios_rounded),
        //         onPressed: () {
        //           _webViewController!.goForward();
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
