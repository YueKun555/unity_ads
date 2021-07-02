import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String urlString;
  final String title;
  WebPage({
    this.title,
    @required this.urlString,
  });

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  /// 标题
  String _title = "";

  /// WebViewController
  WebViewController _webViewController;

  @override
  void initState() {
    if (widget.title != null) {
      _title = widget.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: WebView(
        initialUrl: widget.urlString,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onPageFinished: (url) {
          _getTitle();
        },
      ),
    );
  }

  void _getTitle() async {
    if (widget.title == null) {
      var title = await _webViewController.getTitle();
      setState(() {
        _title = title;
      });
    }
  }
}
