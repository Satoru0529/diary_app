import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddDiaryModel extends ChangeNotifier {
  String? date;
  String? title;
  String? content;
  bool isLoading = false;

  DateTime targetday = DateTime.now();
  DateFormat format = DateFormat('yyyy-MM-dd');

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addDiary() async {

    date = format.format(targetday);
    // if (date == null || date == "") {
    //   throw '日付が入力されていません';
    // }

    if (title == null || title!.isEmpty) {
      throw 'タイトルが入力されていません';
    }

    if (content == null || content!.isEmpty) {
      throw '内容が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('diarys').doc();

    // firestoreに追加
    await doc.set({
      'title': title,
      'date': date,
      'content': content,
    });

  }

}