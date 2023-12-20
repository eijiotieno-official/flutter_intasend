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
                  debugPrint("NEW URL ${change.url}");
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

  Future<bool> getElement({required String id}) async {
    bool found = false;
    await _webViewController?.runJavaScriptReturningResult('''
      var element = document.getElementById('$id');
      if (element !== null) {
        found = true;
      }
    ''').then((value) {
      setState(() {
        found = value.toString() == null.toString() ? false : true;
      });
    });

    return found;
  }

  // bool isCanceled = false;
  // Future<void> handleCancelButtonClick() async {
  //   // Check if _webViewController is not null
  //   if (_webViewController != null) {
  //     // Execute JavaScript code to close the modal
  //     await _webViewController!.runJavaScript('''
  //       var modal = document.getElementById('INTASEND-WEBSDK-MODAL-3');
  //       if (modal !== null) {
  //         modal.style.display = 'none';
  //       }
  //     ''');
  //   }
  //   setState(() {
  //     isCanceled = true;
  //   });
  // }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Never mind'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool found = await getElement(id: "INTASEND-WEBSDK-MODAL-3");
        if (!found) {
          _showBackDialog();
        }
        //  else {
        //   handleCancelButtonClick();
        // }
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
      ),
    );
  }
}
