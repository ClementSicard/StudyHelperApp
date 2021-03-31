import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/courses_data_handler.dart';
import 'package:study_helper/objects/dark_theme_handler.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/pages/chapters_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';
import 'package:study_helper/utils/nice_button.dart';
import 'package:study_helper/utils/routes.dart';
import '../utils/custom_text_styles.dart';
import 'course_prompt_page.dart';

class CoursesPage extends StatefulWidget {
  final Semester _semester;
  CoursesPage(this._semester, {Key key}) : super(key: key);

  @override
  CoursesPageState createState() => CoursesPageState(_semester);
}

class CoursesPageState extends State<CoursesPage> {
  final Semester _semester;
  CoursesPageState(this._semester);

  Widget _body(List<Course> courses, bool darkTheme) {
    if (courses == null) {
      return Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                "Loading...",
                style: customTextStyle(darkTheme),
              )
            ],
          ),
        ),
      );
    } else if (courses.isEmpty) {
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
                "Add your first course!",
                style: customTextStyle(darkTheme),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CircleAvatar(
                radius: MediaQuery.of(context).size.height / 17.0,
                backgroundColor: Colors.orange,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: darkTheme ? Color(0xff282728) : Colors.white,
                  ),
                  enableFeedback: true,
                  iconSize: MediaQuery.of(context).size.height / 17.0,
                  onPressed: () async => await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoursePromptPage(_semester),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      courses.sort((a, b) => a.name.compareTo(b.name));
      return Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 25.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            Course current = courses[index];
            return Column(
              children: [
                GestureDetector(
                  child: CupertinoContextMenu(
                    actions: [
                      CupertinoContextMenuAction(
                        child: const Text(
                          "Remove course",
                          textAlign: TextAlign.center,
                        ),
                        isDefaultAction: false,
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.delete,
                        onPressed: () async {
                          final dataProvider =
                              Provider.of<DataHandler>(context, listen: false);
                          await dataProvider.removeCourse(current);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    child: NiceButton(
                      darkTheme,
                      text: current.name,
                      color: Colors.orange,
                      width: 500,
                      onPressed: () async => await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChaptersPage(current)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final dataProvider = Provider.of<DataHandler>(context, listen: true);
    return FutureBuilder(
      future: dataProvider.getSemesters(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final List<Semester> semesters = snapshot.data;
          final List<Course> courses = semesters
              .firstWhere(
                (s) => s.id == _semester.id,
              )
              .courses;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${_semester.name} - Courses",
                textAlign: TextAlign.center,
                style: customTextStyle(themeChange.darkTheme),
              ),
              leading: IconButton(
                icon: const Icon(
                  CupertinoIcons.back,
                ),
                tooltip: "Back",
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(MaterialCommunityIcons.information),
                  tooltip: "Description",
                  onPressed: () async => await Navigator.push(
                    context,
                    createRoute(
                      Scaffold(
                        appBar: AppBar(
                          title: Text(
                            "${_semester.name} - Description",
                            style: customTextStyle(!themeChange.darkTheme),
                          ),
                          backgroundColor: Colors.orange[400],
                          leading: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            tooltip: "Close",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                Text(
                                  _semester.description,
                                  style: customTextStyle(themeChange.darkTheme),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: _body(courses, themeChange.darkTheme),
            floatingActionButton: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.white54,
              ),
              child: FloatingActionButton(
                onPressed: () async => await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => CoursePromptPage(_semester)),
                ),
                child: const Icon(Icons.add),
                backgroundColor: Colors.orange[400],
                elevation: 0,
              ),
            ),
          );
        } else
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }
}
