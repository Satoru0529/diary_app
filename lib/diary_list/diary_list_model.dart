import 'package:memo_project/domain/diary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryListModel extends ChangeNotifier {
  List<Diary>? diarys;

  void fetchBookList() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('diarys').get();

    final List<Diary> diarys = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String date = data['date'];
      final String content = data['content'];
      return Diary(id, title, date, content);
    }).toList();

    this.diarys = diarys;
    notifyListeners();
  }

  Future delete(Diary diary) {
    return FirebaseFirestore.instance.collection('diarys').doc(diary.id).delete();
  }
}