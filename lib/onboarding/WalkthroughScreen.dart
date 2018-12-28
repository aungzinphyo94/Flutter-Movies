import 'package:flutter/material.dart';
import 'package:flutter_flim/main.dart';
import 'package:flutter_flim/onboarding/Walkthrough.dart';

class WalkthroughScreen extends StatefulWidget {
  final List<Walkthrough> walkthroughList;
  final MaterialPageRoute pageRoute;

  WalkthroughScreen(this.walkthroughList, this.pageRoute);

  @override
  WalkthroughScreenState createState() {
    return new WalkthroughScreenState();
  }
}

class WalkthroughScreenState extends State<WalkthroughScreen> {
  PageController _controller;
  bool lastScreen = false;
  int _currentScreen = 0;

  @override
  void initState() {
    super.initState();
    _controller = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new Container(
      color: new Color(0xFFC5CAE9),
      padding: const EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
            child: new Material(
              child: new PageView(
                children: widget.walkthroughList,
                controller: _controller,
                onPageChanged: _onPageChanged,
              ),
              elevation: 8.0,
            ),
            flex: 10,
          ),
          new Expanded(
            child: new ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: double.infinity,
                  minWidth: double.infinity,
                ),
              child: new MaterialButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                      builder: (_) => new MainApp(),
                    ),
                  ),
                color: Colors.lightBlueAccent,
                splashColor: Colors.redAccent,
                elevation: 8.0,
                textColor: Colors.white,
                child: new Text(
                  "Let's Start",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  void _onPageChanged(int value){
    setState(() {
      _currentScreen = value;
      if (_currentScreen == widget.walkthroughList.length - 1) {
        lastScreen = true;
      } else {
        lastScreen = false;
      }
    });
  }


}


