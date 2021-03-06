import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_helper/objects/chapter.dart';
import 'package:study_helper/objects/course.dart';
import 'package:study_helper/objects/db_helper.dart';
import 'package:study_helper/objects/mastered.dart';
import 'package:study_helper/objects/semester.dart';
import 'package:study_helper/objects/subject.dart';

class DataHandler with ChangeNotifier {
  List<Semester> _semesters;

  DataHandler() {
    _update();
  }

  Future<bool> exportData() async {
    try {
      final path = "${await getDatabasesPath()}/${DBHelper.databaseName}";
      final file = File(path);

      final _bytes = await file.readAsBytes();

      FilePickerCross myFile = FilePickerCross(
        _bytes,
        fileExtension: "db",
      );

      final date = DateTime.now();
      final filePath =
          "StudyHelper_${date.day.toString().padLeft(2, "0")}_${date.month.toString().padLeft(2, "0")}_${date.year}.db";

      myFile.exportToStorage(
        fileName: filePath,
      );

      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<bool> clearData() async {
    final Database db = await DBHelper.instance.database;
    await DBHelper.instance.clearDB(db);
    await _update();
    print("[DataHandler] Data successfully cleared!");
    return true;
  }

  Future<bool> _update() async {
    final Database db = await DBHelper.instance.database;
    List<Map> semestersFromDB = await db.query('Semester');

    List<Semester> semesters = semestersFromDB.isNotEmpty
        ? semestersFromDB
            .map(
              (m) => Semester(
                  id: m["SemesterID"],
                  name: m["Name"],
                  description: m["Description"]),
            )
            .toList()
        : [];

    for (Semester semester in semesters) {
      final List<Course> courses = await _getCoursesFromDB(db, semester.id);
      semester.courses = courses;
    }

    this._semesters = semesters;
    notifyListeners();
    return true;
  }

  Future<List<Course>> getCoursesFromSemester(Semester semester) async {
    final Database db = await DBHelper.instance.database;
    final List<Course> courses = await _getCoursesFromDB(db, semester.id);
    return courses;
  }

  Future<List<Chapter>> getChaptersFromCourse(Course course) async {
    final Database db = await DBHelper.instance.database;
    final List<Chapter> chapters = await _getChaptersFromDB(
      db,
      course.id,
    );
    return chapters;
  }

  Future<List<Subject>> getSubjectsFromChapter(Chapter chapter) async {
    final Database db = await DBHelper.instance.database;
    final List<Subject> subjects = await _getSubjectsFromDB(
      db,
      chapter.id,
    );
    return subjects;
  }

  Future<List<Course>> _getCoursesFromDB(Database db, String semesterID) async {
    final List<Map> coursesFromDB = await db.query(
      'Course',
      where: "SemesterID = ?",
      whereArgs: [semesterID],
    );

    final List<Course> courses = coursesFromDB.isNotEmpty
        ? coursesFromDB.map(
            (c) {
              return Course(
                name: c["Name"],
                id: c["CourseID"],
                semesterID: semesterID,
              );
            },
          ).toList()
        : [];

    for (Course course in courses) {
      final List<Chapter> chapters = await _getChaptersFromDB(db, semesterID);
      course.chapters = chapters;
    }

    return courses;
  }

  Future<List<Chapter>> _getChaptersFromDB(Database db, String courseID) async {
    var query = '''
        SELECT Chapter.ChapterID, Chapter.Name, Chapter.Mastered, Chapter.Description FROM Course 
          JOIN Chapter 
          ON Chapter.CourseID = Course.CourseID 
        WHERE 
          Course.CourseID = ?;
        ''';

    final List<Map> chaptersFromDB = await db.rawQuery(query, [courseID]);

    final List<Chapter> chapters = chaptersFromDB.isNotEmpty
        ? chaptersFromDB
            .map(
              (m) => Chapter(
                id: m["ChapterID"],
                name: m["Name"],
                mas: Mastered(m["Mastered"]),
                description: m["Description"],
                courseID: courseID,
              ),
            )
            .toList()
        : [];

    for (Chapter chapter in chapters) {
      final List<Subject> subjects = await _getSubjectsFromDB(db, chapter.id);
      chapter.subjects = subjects;
    }

    return chapters;
  }

  Future<List<Subject>> _getSubjectsFromDB(
      Database db, String chapterID) async {
    var query = '''
        SELECT Subject.SubjectID, Subject.Name, Subject.Mastered, Subject.Aside FROM Chapter 
          JOIN Subject 
          ON Subject.ChapterID = Chapter.ChapterID 
        WHERE 
          Chapter.ChapterID = ?;
        ''';

    List<Map> subjectsFromDB = await db.rawQuery(query, [chapterID]);

    List<Subject> subjects = subjectsFromDB.isNotEmpty
        ? subjectsFromDB.map(
            (m) {
              return Subject(
                id: m["SubjectID"],
                name: m["Name"],
                mas: Mastered(m["Mastered"]),
                chapterID: chapterID,
                aside: m["Aside"] == 1 ? true : false ?? false,
              );
            },
          ).toList()
        : [];

    return subjects;
  }

// Semester methods

  Future<bool> addSemester(Semester semester) async {
    await DBHelper.instance.addSemester(semester);
    await _update();
    print("[DataHandler] Semester well added!");
    return true;
  }

  Future<bool> renameSemester(Semester semester, String newName) async {
    await DBHelper.instance.renameSemester(semester, newName);
    await _update();
    print("[DataHandler] Semester well renamed!");
    return true;
  }

  Future<bool> removeSemester(Semester semester) async {
    await DBHelper.instance.deleteSemester(semester);
    await _update();
    print("[DataHandler] Semester well removed!");
    return true;
  }

  Future<bool> updateSemesterDescription(
      Semester semester, String newDescription) async {
    await DBHelper.instance.updateSemesterDescription(semester, newDescription);
    await _update();
    print("[DataHandler] Semester description updated!");
    return true;
  }

// Course methods

  Future<bool> addCourse(Course course) async {
    await DBHelper.instance.addCourse(course);
    await _update();
    print("[DataHandler] Course well added!");
    return true;
  }

  Future<bool> removeCourse(Course course) async {
    await DBHelper.instance.deleteCourse(course);
    await _update();
    print("[DataHandler] Course well deleted!");
    return true;
  }

  Future<bool> renameCourse(Course course, String newName) async {
    await DBHelper.instance.renameCourse(course, newName);
    await _update();
    print("[DataHandler] Course well renamed!");
    return true;
  }

  Future<bool> updateCourseDescription(
      Course course, String newDescription) async {
    await DBHelper.instance.updateCourseDescription(course, newDescription);
    await _update();
    print("[DataHandler] Course description updated!");
    return true;
  }

// Chapter methods

  Future<bool> addChapter(Chapter chapter) async {
    await DBHelper.instance.addChapter(chapter);
    await _update();
    print("[DataHandler] Chapter well added!");
    return true;
  }

  Future<bool> renameChapter(Chapter chapter, String newName) async {
    await DBHelper.instance.renameChapter(chapter, newName);
    await _update();
    print("[DataHandler] Chapter well renamed!");
    return true;
  }

  Future<bool> removeChapter(Chapter chapter) async {
    await DBHelper.instance.deleteChapter(chapter);
    await _update();
    print("[DataHandler] Chapter well removed!");
    return true;
  }

  Future<bool> updateChapterMastering(Chapter chapter, Mastered mas) async {
    await DBHelper.instance.updateChapterMastering(chapter, mas);
    await _update();
    print("[DataHandler] Chapter mastering well changed!");
    return true;
  }

// Subject methods

  Future<bool> addSubject(Subject subject) async {
    await DBHelper.instance.addSubject(subject);
    await _update();
    print("[DataHandler] Subject well added!");
    return true;
  }

  Future<bool> renameSubject(Subject subject, String newName) async {
    await DBHelper.instance.renameSubject(subject, newName);
    await _update();
    print("[DataHandler] Subject well renamed!");
    return true;
  }

  Future<bool> removeSubject(Subject subject) async {
    await DBHelper.instance.deleteSubject(subject);
    await _update();
    print("[DataHandler] Subject well removed!");
    return true;
  }

  Future<bool> updateSubjectMastering(Subject subject, Mastered mas) async {
    await DBHelper.instance.updateSubjectMastering(subject, mas);
    await _update();
    print("[DataHandler] Subject mastering well changed!");
    return true;
  }

  Future<bool> updateSubjectAside(Subject subject, bool value) async {
    await DBHelper.instance.updateSubjectAside(subject, value);
    await _update();
    print("[DataHandler] Subject aside well changed!");
    return true;
  }

  Future<List<Semester>> getSemesters() async {
    if (_semesters == null) {
      await _update();
    }
    return this._semesters;
  }
}
