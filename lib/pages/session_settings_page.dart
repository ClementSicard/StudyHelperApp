import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/pages/game_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class SessionSettingsPage extends StatefulWidget {
  final Course _course;
  final List<Chapter> _chapters;

  SessionSettingsPage(this._course, this._chapters, {Key key})
      : super(key: key);

  @override
  _SessionSettingsPageState createState() =>
      _SessionSettingsPageState(_course, _chapters);
}

class _SessionSettingsPageState extends State<SessionSettingsPage> {
  final Course _course;
  final List<Chapter> _chapters;
  List<bool> _selected;
  bool _all = false;
  bool _random = true;
  bool _onlyAside = false;
  bool _zeroStar = false;
  bool _oneStar = false;
  bool _twoStar = false;
  bool _threeStar = false;

  _SessionSettingsPageState(this._course, this._chapters);

  @override
  void initState() {
    _selected = _chapters.map((c) => false).toList();
    _selected[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tune your session",
          textAlign: TextAlign.center,
          style: customTextStyle(
            themeChange.darkTheme,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
          ),
          tooltip: "Back",
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          children: [
            const SizedBox(height: 30),
            Text(
              "Select chapters",
              textAlign: TextAlign.center,
              style: customTextStyle(themeChange.darkTheme),
            ),
            const SizedBox(height: 15),
          ]
            ..addAll(
              [
                ListTile(
                  leading: const Icon(CupertinoIcons.book_solid),
                  title: Text(
                    "All chapters",
                    style: customTextStyle(themeChange.darkTheme, size: 20),
                  ),
                  trailing: CupertinoSwitch(
                    activeColor: Colors.red,
                    value: _all,
                    onChanged: (bool value) {
                      setState(() {
                        _all = value;
                        _selected = _chapters
                            .map((c) => c.subjects.isEmpty ? !value : value)
                            .toList();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _all = !_all;
                    });
                  },
                ),
                const SizedBox(height: 15),
              ],
            )
            ..addAll(_chapterSelection(themeChange.darkTheme))
            ..addAll(
              [
                Visibility(
                  visible: !_all,
                  child: const SizedBox(height: 60),
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.shuffle),
                  title: Text(
                    "Random order",
                    style: customTextStyle(themeChange.darkTheme, size: 20),
                  ),
                  trailing: CupertinoSwitch(
                    value: _random,
                    onChanged: (value) => setState(() => _random = value),
                  ),
                  onTap: () => setState(() => _random = !_random),
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.bookmark),
                  title: Text(
                    "Only bookmarked subjects",
                    style: customTextStyle(themeChange.darkTheme, size: 20),
                  ),
                  trailing: CupertinoSwitch(
                    activeColor: Colors.redAccent[100],
                    value: _onlyAside,
                    onChanged: (value) {
                      setState(() {
                        _onlyAside = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _onlyAside = !_onlyAside;
                    });
                  },
                ),
                const SizedBox(height: 50),
                ListTile(
                  leading: const Icon(Icons.school_sharp),
                  title: Row(
                    children: [
                      Text(
                        "Only   ",
                        style: customTextStyle(themeChange.darkTheme, size: 20),
                      ),
                      const Icon(Ionicons.ios_star_outline),
                      const Icon(Ionicons.ios_star_outline),
                      const Icon(Ionicons.ios_star_outline),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: _zeroStar,
                    onChanged: (value) {
                      setState(() => _zeroStar = value);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _zeroStar = !_zeroStar;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: Row(
                    children: [
                      Text(
                        "Only   ",
                        style: customTextStyle(themeChange.darkTheme, size: 20),
                      ),
                      const Icon(Ionicons.ios_star),
                      const Icon(Ionicons.ios_star_outline),
                      const Icon(Ionicons.ios_star_outline),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: _oneStar,
                    onChanged: (value) {
                      setState(() => _oneStar = value);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _oneStar = !_oneStar;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: Row(
                    children: [
                      Text(
                        "Only   ",
                        style: customTextStyle(themeChange.darkTheme, size: 20),
                      ),
                      const Icon(Ionicons.ios_star),
                      const Icon(Ionicons.ios_star),
                      const Icon(Ionicons.ios_star_outline),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: _twoStar,
                    onChanged: (value) {
                      setState(() => _twoStar = value);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _twoStar = !_twoStar;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: Row(
                    children: [
                      Text(
                        "Only   ",
                        style: customTextStyle(themeChange.darkTheme, size: 20),
                      ),
                      const Icon(Ionicons.ios_star),
                      const Icon(Ionicons.ios_star),
                      const Icon(Ionicons.ios_star),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: _threeStar,
                    onChanged: (value) {
                      setState(() => _threeStar = value);
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _threeStar = !_threeStar;
                    });
                  },
                ),
                const SizedBox(height: 90)
              ],
            ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
          onPressed: () async {
            List<Chapter> selectedChapters = [];
            bool emptyChapter = false;

            for (int i = 0; i < _chapters.length; i++) {
              if (_selected[i]) {
                selectedChapters.add(_chapters[i]);
              }
            }

            for (Chapter c in selectedChapters) {
              if (c.subjects.isEmpty) {
                emptyChapter = true;
                break;
              }
            }

            if (emptyChapter) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  title: const Text('Chapter with no subjects selected'),
                  message:
                      const Text("You must only select chapters with subjects"),
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text(
                      'Cancel',
                      style: const TextStyle(color: Colors.blue),
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  ),
                ),
              );
            } else if (selectedChapters.isEmpty) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  title: const Text('No chapter selected'),
                  message: const Text("You must select at least one chapter!"),
                  cancelButton: CupertinoActionSheetAction(
                    child: const Text(
                      'Cancel',
                      style: const TextStyle(color: Colors.blue),
                    ),
                    isDefaultAction: true,
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                  ),
                ),
              );
            } else {
              if (_onlyAside) {
                selectedChapters.forEach((c) =>
                    c.subjects = c.subjects.where((s) => s.aside).toList());
              }

              bool nonEmptySubjects = false;
              for (Chapter c in selectedChapters) {
                nonEmptySubjects |= c.subjects.isNotEmpty;
              }

              print(selectedChapters
                  .map((c) => c.subjects.map((s) => s.toMap())));

              if (!nonEmptySubjects) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: const Text("No subject aside"),
                    message: const Text("You didn't put aside any subject"),
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        'Cancel',
                        style: const TextStyle(color: Colors.blue),
                      ),
                      isDefaultAction: true,
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                    ),
                  ),
                );
              } else {
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        GamePage(_course, selectedChapters, _random),
                  ),
                );
              }
            }
          },
          label: Text(
            "Let's start!",
            style: customTextStyle(false),
          ),
          icon: const Icon(
            CupertinoIcons.play_arrow_solid,
            size: 35,
          ),
          backgroundColor: Colors.greenAccent,
          elevation: 0,
          heroTag: "animationToFullScreen",
        ),
      ),
    );
  }

  List<Visibility> _chapterSelection(bool darkTheme) {
    List<Visibility> switchesTiles = [];
    for (int i = 0; i < _chapters.length; i++) {
      Chapter current = _chapters[i];
      switchesTiles.add(
        Visibility(
          visible: _all == false,
          child: ListTile(
            leading: Icon(CupertinoIcons.book),
            title: Text(
              current.name,
              style: customTextStyle(darkTheme, size: 20),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: CupertinoSwitch(
              value: _selected[i],
              onChanged: (bool value) {
                setState(() {
                  _selected[i] = value;
                });
              },
            ),
            onTap: () {
              setState(
                () {
                  _selected[i] = !_selected[i];
                  if (_selected.any((element) => false)) {
                    _all = false;
                  } else if (!_selected.any((element) => false)) {
                    _all = true;
                  }
                },
              );
            },
          ),
        ),
      );
    }
    return switchesTiles;
  }
}
