import 'package:memo_project/add_diary/add_diary_page.dart';
import 'package:memo_project/diary_list/diary_list_model.dart';
import 'package:memo_project/domain/diary.dart';
import 'package:memo_project/edit_diary/edit_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DiaryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DiaryListModel>(
      create: (_) => DiaryListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('日記一覧'),
        ),
        body: Center(
          child: Consumer<DiaryListModel>(builder: (context, model, child) {
            final List<Diary>? diarys = model.diarys;

            if (diarys == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = diarys
                .map(
                  (diary) => Slidable(
                actionPane: SlidableDrawerActionPane(),
                child: ListTile(
                  title: Text(diary.date.substring(5,7)+"/"+diary.date.substring(8,10)),
                  subtitle: Text(diary.title),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '編集',
                    color: Colors.black45,
                    icon: Icons.edit,
                    onTap: () async {
                      // 編集画面に遷移

                      // 画面遷移
                      final String? title = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBookPage(diary),
                        ),
                      );

                      if (title != null) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('$titleを編集しました'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      }

                      model.fetchBookList();
                    },
                  ),
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      // 削除しますか？って聞いて、はいだったら削除
                      await showConfirmDialog(context, diary, model);
                    },
                  ),
                ],
              ),
            )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
        Consumer<DiaryListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              // 画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDiaryPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('日記を追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

              model.fetchBookList();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future showConfirmDialog(
      BuildContext context,
      Diary diary,
      DiaryListModel model,
      ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${diary.date}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // modelで削除
                await model.delete(diary);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${diary.date}を削除しました'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}