import 'package:memo_project/domain/diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDiaryModel extends ChangeNotifier {
  final Diary diary;
  EditDiaryModel(this.diary) {
    dateController.text = diary.date;
    contentController.text = diary.content;
  }

  final dateController = TextEditingController();
  final contentController = TextEditingController();

  String? date;
  String? content;

  void setDate(String date) {
    this.date = date;
    notifyListeners();
  }

  void setContent(String content) {
    this.content = content;
    notifyListeners();
  }

  bool isUpdated() {
    return date != null || content != null;
  }

  Future update() async {
    this.date = dateController.text;
    this.content = contentController.text;

    // firestoreに追加
    await FirebaseFirestore.instance.collection('diarys').doc(diary.id).update({
      'date': date,
      'content': content,
    });
  }
}