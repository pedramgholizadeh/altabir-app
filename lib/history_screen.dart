import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dream_model.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<DreamModel>('dreams').listenable(),
      builder: (context, Box<DreamModel> box, _) {
        if (box.isEmpty) {
          return Center(child: Text('هیچ تعبیری ثبت نشده است'));
        }
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final dream = box.getAt(index)!;
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('شرح خواب: ${dream.description}'),
                subtitle: Text('تعبیر: ${dream.interpretation}'),
              ),
            );
          },
        );
      },
    );
  }
}