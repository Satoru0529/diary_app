import 'package:memo_project/add_diary/add_diary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDiaryPage extends StatefulWidget {
  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {

  var addDiaryModel = AddDiaryModel();

  DateTime targetday = DateTime.now();
  String dateString ='';
  DateFormat format = DateFormat('yyyy-MM-dd');
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);

    dateString = format.format(targetday);
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddDiaryModel>(
      create: (_) => AddDiaryModel(),
      child: GestureDetector(

      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('日記を追加'),
          actions: [Consumer<AddDiaryModel>(builder: (context, model, child) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                // 追加の処理
                try {
                  model.startLoading();
                  await model.addDiary();
                  Navigator.of(context).pop(true);
                } catch (e) {
                  print(e);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                } finally {
                  model.endLoading();
                }
              },
            );
          }),],
        ),
        body: Center(
          child: Consumer<AddDiaryModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 30,
                            onChanged: (text) {
                              model.title = text;
                            },
                          ),
                          TextButton.icon(
                            icon: const Icon(FontAwesomeIcons.calendarAlt,
                                color: Colors.blue, size: 25.0),
                            label: Text(format.format(targetday)),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                            // ボタンが押された時に表示する
                            onPressed: () {
                              model.date = format.format(targetday);
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1900, 1, 1),
                                  maxTime: DateTime(2049, 12, 31),
                                  onConfirm: (date) {
                                    setState(() {
                                      dateString = format.format(date);
                                      targetday = date;
                                    });
                                    model.date = dateString;
                                  },
                                  currentTime: targetday, locale: LocaleType.jp
                              );
                            },
                          ),

                        ],
                      ),

                      // ↓ColumnをSingleChildScrollViewでラップする
                      SingleChildScrollView(

                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          height: 2200.h,
                          child: Scrollbar(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (text) {
                                model.content = text;
                              },
                            ),
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}