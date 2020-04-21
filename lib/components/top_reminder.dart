import 'dart:async';

import 'package:flutter/material.dart';

class TopReminder extends StatefulWidget {
  final title;
  final subtitle;
  final nextScreen;

  const TopReminder(
      {Key key, this.title, this.subtitle, @required this.nextScreen})
      : super(key: key);

  @override
  _TopReminderState createState() => _TopReminderState();
}

class _TopReminderState extends State<TopReminder> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      Duration(seconds: 5),
          (timer) {
        Navigator.of(context).pop(false);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _timer.cancel();
        Navigator.of(context).pop(true);
      },
      onPanUpdate: (details) {
        if (details.delta.dy < 0) {
          Navigator.of(context).pop(false);
        }
      },
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              width: double.infinity,
              height: 85,
              alignment: Alignment.topCenter,
              child: Material(
                child: Card(
                  child: ListTile(
                    title: Text(widget.title),
                    subtitle: Text(widget.subtitle),
                  ),
                ),
              ),
            ),
          ),
          Opacity(opacity: 0.5,),
        ],
      ),
    );
  }
}
