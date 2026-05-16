import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class QuestionModel {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String categoryId;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.categoryId,
  });

  factory QuestionModel.fromParse(ParseObject object) {
    return QuestionModel(
      id: object.objectId!,
      text: object.get<String>('text') ?? '',
      options: List<String>.from(object.get<List>('options') ?? []),
      correctAnswerIndex: object.get<int>('correctAnswerIndex') ?? 0,
      categoryId: object.get<ParseObject>('category')?.objectId ?? '',
    );
  }
}
