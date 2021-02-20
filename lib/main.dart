import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MainView());

final savedUrls = <String>[];

Completer<WebViewController> _controller = Completer<WebViewController>();
WebViewController cnt;

void changePage(BuildContext context, nextPage) {
  Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => nextPage()));
}

void not(i) {
  i ? i = false : i = true;
  return i;
}

Future<String> getControllerUrl(BuildContext context) async {
  final i = await cnt.currentUrl();

  if (i.contains("dp")) {
    savedUrls.add(i);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainHome()));
  } else {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Invalid URL!"),
          content: new Text("Please select a valid Amazon item!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  savedUrls.forEach((element) {
    print(element);
  });
  print(i);
}

class MainView extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainHome(),
    );
  }
}

class MainHome extends StatefulWidget {
  @override
  MainHomeState createState() => MainHomeState();
}

class MainHomeState extends State<MainHome> {
  Widget ListViewBuilder() {
    return ListView.builder(
        itemCount: savedUrls.length,
        itemBuilder: (BuildContext cntx, int i) {
          return ListTile(
            title: Text("Element"),
          );
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PriceApp")),
      body: ListViewBuilder(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_sharp),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => WebViewPage())),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(home: WebViewPageHome());
  }
}

class WebViewPageHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PriceApp")),
      body: WebViewExample(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite),
        onPressed: () {
          getControllerUrl(context);
        },
      ),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: 'https://www.amazon.de',
        javaScriptMode: JavaScriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          setState(() {
            _controller.complete(webViewController);
            cnt = webViewController;
          });
        });
  }
}
