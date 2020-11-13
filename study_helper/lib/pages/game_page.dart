import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class GamePage extends StatefulWidget {
  final Course _course;
  final List<Chapter> _chapters;
  final bool _random;

  factory GamePage(Course course, List<Chapter> chapters, bool random,
      {Key key}) {
    return GamePage._(course, chapters, random, key: key);
  }

  GamePage._(this._course, this._chapters, this._random, {Key key})
      : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(_course, _chapters, _random);
}

class _GamePageState extends State<GamePage> {
  final Course _course;
  final List<Chapter> _chapters;
  List<MapEntry<Subject, Chapter>> _subjectsOri;
  List<MapEntry<Subject, Chapter>> _subjects;
  List<MapEntry<Subject, Chapter>> _putAsideSubjects;
  List<Color> _colors;
  final bool _random;
  MapEntry<Subject, Chapter> _currentSubject;
  Color _color;
  int _nbOfSubjects;
  int _counter;
  int _putAsideCounter;

  _GamePageState(this._course, this._chapters, this._random);

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "animationToFullScreen",
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: _color,
          centerTitle: true,
          title: Text(
            _course.name,
            style: customTextStyle(false),
          ),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
            ),
            color: Colors.black,
            tooltip: "Back",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Visibility(
              visible: _subjects.isNotEmpty,
              child: Padding(
                padding: EdgeInsets.only(
                    right: 15.0 / 360.0 * MediaQuery.of(context).size.width),
                child: Center(
                  child: Text(
                    _counter.toString() + " / " + _nbOfSubjects.toString(),
                    style: customTextStyle(false),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: _color,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (_subjects.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 30),
          Text(
            "Well done!",
            style: customTextStyle(false, size: 40),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 50.0,
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.refresh,
                      ),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 43,
                      onPressed: () {
                        setup();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 30),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              _currentSubject.key.name,
              style: customTextStyle(false, size: 40),
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff272827),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark),
                          color: _color,
                          enableFeedback: true,
                          iconSize: 30,
                          onPressed: () {
                            if (!_putAsideSubjects.contains(_currentSubject)) {
                              setState(
                                () {
                                  _putAsideSubjects.add(_currentSubject);
                                  _putAsideCounter++;
                                },
                              );
                            } else {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                  title: const Text('Oh oh...'),
                                  message: Text(_currentSubject.key.name +
                                      " was already put aside to be further studied!"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      child: const Text(
                                        "OK",
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text(
                                        "Remove it",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        setState(
                                          () {
                                            _putAsideCounter--;
                                            _putAsideSubjects
                                                .remove(_currentSubject);
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text(
                                      "Cancel",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '$_putAsideCounter',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff272827),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: _color,
                      enableFeedback: true,
                      iconSize: 30,
                      onPressed: () {
                        setState(
                          () {
                            _subjects.remove(_currentSubject);
                            _counter++;
                            if (_subjects.isEmpty) {
                              _color = Colors.lightGreenAccent;
                            } else {
                              _currentSubject = _subjects.first;
                              Color oldColor = _color;
                              while (_color == oldColor) {
                                _color = (_colors..shuffle()).first;
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  void setup() {
    // Set up the page
    _subjects = [];
    _subjectsOri = [];
    _putAsideSubjects = [];

    for (Chapter c in _chapters) {
      _subjectsOri.addAll(c.subjects.map((s) => MapEntry(s, c)).toList());
    }
    _colors = List.from(Colors.accents);
    _nbOfSubjects = _subjectsOri.length;

    setState(() {
      if (_random) {
        _subjects.shuffle();
      }
      _subjects = List.from(_subjectsOri);
      _color = (_colors..shuffle()).first;
      _counter = 1;
      _putAsideCounter = 0;
      _currentSubject = _subjects.first;
    });
  }
}
