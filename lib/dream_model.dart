import 'package:hive/hive.dart';

part 'dream_model.g.dart';

@HiveType(typeId: 0)
class DreamModel extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  String interpretation;

  DreamModel(this.description, this.interpretation);
}