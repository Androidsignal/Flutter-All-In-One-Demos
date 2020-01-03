import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps/timer_notification/DateAndTimeModel.dart';
import 'package:intl/intl.dart';

class TimerListNotification extends StatefulWidget {
  @override
  _TimerListNotificationState createState() => _TimerListNotificationState();
}

class _TimerListNotificationState extends State<TimerListNotification> {
  List<DateAndTime> dateAndTimeList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Timer"),
        ),
        body: new FutureBuilder(
            future: setDataIntoList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                physics: BouncingScrollPhysics(),
                itemCount: dateAndTimeList.length,
                itemBuilder: (context, index) => Center(
                  child: Card(
                    child: ListTile(
                      trailing: IconButton(icon: Icon(Icons.timer), onPressed: null),
                      title: Text(dateAndTimeList[index].notification),
                      subtitle: TimerView(
                        dateTime: dateAndTimeList[index],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  Future setDataIntoList() async {
    dateAndTimeList = new List<DateAndTime>();
    DateAndTime dateAndTime = new DateAndTime(
        "Notification 1", DateTime.now().add(Duration(seconds: 50)));
    dateAndTimeList.add(dateAndTime);
    DateAndTime dateAndTime2 = new DateAndTime(
        "Notification 2", DateTime.now().add(Duration(seconds: 28)));
    dateAndTimeList.add(dateAndTime2);
    DateAndTime dateAndTime3 = new DateAndTime(
        "Notification 3", DateTime.now().add(Duration(hours: 18)));
    dateAndTimeList.add(dateAndTime3);
    DateAndTime dateAndTime4 = new DateAndTime(
        "Notification 4", DateTime.now().add(Duration(hours: 2)));
    dateAndTimeList.add(dateAndTime4);
    DateAndTime dateAndTime5 = new DateAndTime(
        "Notification 5", DateTime.now().subtract(Duration(hours: 5)));
    dateAndTimeList.add(dateAndTime5);
    DateAndTime dateAndTime6 = new DateAndTime(
        "Notification 6", DateTime.now().subtract(Duration(hours: 20)));
    dateAndTimeList.add(dateAndTime6);
    DateAndTime dateAndTime7 = new DateAndTime(
        "Notification 7", DateTime.now().subtract(Duration(hours: 32)));
    dateAndTimeList.add(dateAndTime7);
      return dateAndTimeList;
  }
}

class TimerView extends StatefulWidget {
//  final DateTime dateTime;
  final DateAndTime dateTime;

  const TimerView({Key key, this.dateTime}) : super(key: key);

  @override
  _TimerViewState createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var timerCountDown = '00:00:00';
  DateTime dateCheck;
  Timer timer;
  DateTime dateTimeStart;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    if (widget.dateTime == null) {
      dateTimeStart = DateTime.now();
    } else {
      dateTimeStart = widget.dateTime.dateAndTime;
    }

    dateCheck =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeStart.toString());
    setTime();
    super.initState();
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        '${widget.dateTime.notification}',
        'Flutter Local Notification',
        platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  void setTime() {
    if (dateCheck.difference(DateTime.now()).inSeconds < 0) {
      setState(() {
        timerCountDown = getData(dateTimeStart.millisecondsSinceEpoch);
      });
    } else {
      if (dateCheck.difference(DateTime.now()).inHours < 24) {
        timer?.cancel();
        timer = new Timer(new Duration(seconds: 1), () {
          print("Timer Complete");
          setJustTime();
          setTime();
        });
      } else {
        final date = DateFormat('yyyy-MM-dd').parse(dateTimeStart.toString());
        final today = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
        if (date.difference(today).inDays == 1) {
          timerCountDown = 'Tomorrow';
        } else {
          if (!mounted) return;
          setState(() {
            timerCountDown = DateFormat.E().format(date) +
                ', ' +
                DateFormat.d().format(date) +
                ' ' +
                DateFormat.MMM().format(date);
          });
        }
      }
    }
  }

  void setJustTime() {
    final seconds = dateCheck.difference(DateTime.now()).inSeconds;
    if (!mounted) return;
    setState(() {
      timerCountDown = secondsToHoursMinutesSeconds(seconds);
    });
  }

  String getData(int seconds) {
    var messageDate = new DateTime.fromMillisecondsSinceEpoch(seconds);
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(messageDate);
    var finalDate = DateTime.parse(formatted);
    var days = DateTime.now().difference(finalDate).inDays;
    if (days == 0) {
      if (DateTime.now().difference(messageDate).inHours > 0) {
        return '${DateTime.now().difference(messageDate).inHours} hours ago.';
      } else if (DateTime.now().difference(messageDate).inMinutes > 0) {
        return '${DateTime.now().difference(messageDate).inMinutes} minutes ago.';
      } else {
        showNotification();
        return 'Few seconds ago.';
      }
    } else if (days == 1) {
//      colors = Colors.red;
      return 'Yesterday ${DateFormat.jm().format(messageDate)}';
    } else if (days >= 2 && days <= 6) {
      return DateFormat.EEEE().format(messageDate) +
          " " +
          DateFormat.jm().format(messageDate);
    } else {
      return DateFormat.yMd().add_jm().format(messageDate);
    }
  }

  String secondsToHoursMinutesSeconds(int seconds) {
    var hour = seconds ~/ 3600;
    var minute = (seconds % 3600) ~/ 60;
    var second = (seconds % 3600) % 60;
    final hourUpdate = hour < 10 ? '0$hour' : '$hour';
    final minuteUpdate = minute < 10 ? '0$minute' : '$minute';
    final secondUpdate = second < 10 ? '0$second' : '$second';
    return hourUpdate + ' : ' + minuteUpdate + ' : ' + secondUpdate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(timerCountDown.toString()));
  }
}
