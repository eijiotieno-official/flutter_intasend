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
  void loadPage() {
    setState(() {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(false)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            // Callback when URL changes
            onUrlChange: (change) {
              debugPrint("NEW URL ${change.url}");
              setState(() {
                _url = change.url;
              });
            },
            // Callback for page loading progress
            onProgress: (int progress) {
              setState(() {
                _progress = (progress / 100).toDouble();
                _isLoading = true;
              });
            },
            // Callback when page finishes loading
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
              // _injectJavaScript();
            },
            // Handle web resource errors
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
            // Handle navigation requests
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://intasend.com/security/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        // ..addJavaScriptChannel(
        //   'buttonClicks',
        //   onMessageReceived: (JavaScriptMessage message) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text(message.message)),
        //     );
        //   },
        // )
        ..loadRequest(Uri.parse(_url!));
    });
  }

  void _injectJavaScript() async {
    await getElement(id: "INTASEND-WEBSDK-MODAL-3").then(
      (value) async {
        if (value) {
          await _webViewController!.runJavaScript('''
      document.querySelector('button').addEventListener('click', function() {

        alert('Button Clicked');
      });
    ''');
        }
      },
    );
  }

  @override
  void initState() {
    // Initialize state variables and set up WebView
    _url = widget.url;
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        loadPage();
      },
    );
  }

  void _showCancelPaymentDialog() {
    // Implement your logic to show the cancel payment dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Payment"),
          content: const Text("Are you sure you want to cancel the payment?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Never mind'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                loadPage();
              },
              child: const Text("Cancel Payment"),
            ),
          ],
        );
      },
    );
  }

  // Function to check if an element with a given ID exists on the page
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

  // Function to show a confirmation dialog when attempting to go back
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
      // Disable system back button
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        // Check if a specific element exists on the page
        bool found = await getElement(id: "INTASEND-WEBSDK-MODAL-3");
        if (!found) {
          // If element doesn't exist, show the confirmation dialog
          _showBackDialog();
        } else {
          _showCancelPaymentDialog();
        }
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
                  // Show progress indicator while loading
                  if (_isLoading) LinearProgressIndicator(value: _progress),
                  // WebView widget to display the web content
                  Expanded(
                      child: WebViewWidget(controller: _webViewController!)),
                ],
              ),
      ),
    );
  }
}
