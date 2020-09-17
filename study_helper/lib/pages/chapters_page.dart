import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/subject.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class ChaptersPage extends StatefulWidget {
  final Course _course;

  factory ChaptersPage(Course course, {Key key}) {
    return ChaptersPage._(course, key: key);
  }

  ChaptersPage._(
    this._course, {
    Key key,
  }) : super(key: key);

  @override
  _ChaptersPageState createState() => _ChaptersPageState(_course);
}

class _ChaptersPageState extends State<ChaptersPage> {
  final Course _course;
  List<Chapter> _chapters;

  _ChaptersPageState(this._course);

  List<List<Subject>> subjectsByColumn() {
    List<List<Subject>> subjectsByChapter =
        _chapters.map((c) => c.subjects).toList();

    // Find max length
    int maxLength = 0, minLength = 4294967296;
    for (List<Subject> list in subjectsByChapter) {
      if (maxLength < list.length) {
        maxLength = list.length;
      }
      if (minLength > list.length) {
        minLength = list.length;
      }
    }

    List<List<Subject>> subjectsByCol = [];
    for (int i = 0; i < maxLength; i++) {
      List<Subject> subList = [];
      for (int j = 0; j < _chapters.length; j++) {
        subList.add(_chapters[j].subjects.length > i
            ? _chapters[j].subjects[i]
            : Subject(""));
      }
      print(subList.map((s) => s.name).toList());
      subjectsByCol.add(subList);
    }
    return subjectsByCol;
  }

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<CoursesDataHandler>(context, listen: true);
    // _chapters = coursesData.getChapters(_course);
    _chapters = [
      Chapter(
        "Analyse IV",
        subjects: [
          Subject("Fonctions"),
          Subject("Zebi"),
          Subject("Ok1"),
          Subject("Cauchy"),
          Subject("Dior"),
          Subject("asdsads"),
          Subject("hieori"),
          Subject("sss"),
        ],
      ),
      Chapter(
        "Covid 19",
        subjects: [
          Subject("sss"),
          Subject("Zebi"),
          Subject("Ok1"),
          Subject("Fonctions"),
          Subject("Cauchy"),
          Subject("sss"),
          Subject("Dior"),
          Subject("hieori"),
          Subject("sss"),
          Subject("asdsads"),
          Subject("asdsd"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qeweqws"),
          Subject("qweqew"),
        ],
      ),
      Chapter(
        "Mange moi le poireau",
        subjects: [
          Subject("zizon"),
          Subject("ses"),
          Subject("Osdsg"),
          Subject("Casdady"),
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _course.name,
          textAlign: TextAlign.center,
          style: customTextStyle(),
          maxLines: 2,
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 30,
          ),
          tooltip: "Back",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () async {
              TextEditingController _textFieldController =
                  TextEditingController();
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 0,
                    title: Text(
                      'Rename this course',
                      style: customTextStyle(),
                    ),
                    content: TextField(
                      autocorrect: false,
                      controller: _textFieldController,
                      decoration:
                          InputDecoration(hintText: "Input the new name"),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: const Text('OK'),
                        onPressed: () async {
                          String inputName = _textFieldController.text;
                          if (inputName == _course.name) {
                            return AlertDialog(
                              elevation: 0,
                              title: Text(
                                  'The new name is the same as the previous one !'),
                              content: Text("You must input a different name"),
                              actions: [
                                FlatButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          } else {
                            final coursesData = Provider.of<CoursesDataHandler>(
                                context,
                                listen: false);
                            await coursesData.renameCourse(_course, inputName);
                            _course.name = inputName;
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: _body(),
      backgroundColor: Colors.white,
    );
  }

  Widget _body() {
    if (_chapters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.0,
              ),
              Text(
                "Add a first chapter",
                style: customTextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 17.0,
                backgroundColor: Colors.orange,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  enableFeedback: true,
                  iconSize: MediaQuery.of(context).size.height / 17.0,
                  onPressed: () async {
                    TextEditingController _textFieldController =
                        TextEditingController();
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          elevation: 0,
                          title: Text(
                            'Add a new chapter',
                            style: customTextStyle(),
                          ),
                          content: TextField(
                            autocorrect: false,
                            controller: _textFieldController,
                            decoration:
                                InputDecoration(hintText: "Input the name"),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                String inputName = _textFieldController.text;
                                if (_course.getChapters
                                    .map((c) => c.name)
                                    .toSet()
                                    .contains(inputName)) {
                                  return AlertDialog(
                                    elevation: 0,
                                    title: Text(
                                        'There already exists a chapter with the same name'),
                                    content: Text("Please try a different one"),
                                    actions: [
                                      FlatButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  final coursesData =
                                      Provider.of<CoursesDataHandler>(context,
                                          listen: false);
                                  await coursesData.addChapter(
                                      _course, Chapter(inputName));
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      List<List<Subject>> subjectsByCol = subjectsByColumn();

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _chapters
                  .map(
                    (c) => DataColumn(
                      label: Text(c.name),
                      numeric: false,
                    ),
                  )
                  .toList(),
              rows: subjectsByCol
                  .map(
                    (r) => DataRow(
                      cells: r
                          .map(
                            (s) => DataCell(
                              Text(
                                s.name,
                                style: customTextStyle(),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    }
  }
}
