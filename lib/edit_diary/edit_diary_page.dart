import 'package:memo_project/domain/diary.dart';
import 'package:memo_project/edit_diary/edit_diary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatelessWidget {
  final Diary book;
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditDiaryModel>(
      create: (_) => EditDiaryModel(book),
      child: Scaffold(
        appBar: AppBar(
          title: Text('日記を編集'),
        ),
        body: Center(
          child: Consumer<EditDiaryModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.dateController,
                    decoration: InputDecoration(
                      hintText: '日付',
                    ),
                    onChanged: (text) {
                      model.setDate(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.contentController,
                    decoration: InputDecoration(
                      hintText: '内容',
                    ),
                    onChanged: (text) {
                      model.setContent(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                      // 追加の処理
                      try {
                        await model.update();
                        Navigator.of(context).pop(model.date);
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      }
                    }
                        : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}