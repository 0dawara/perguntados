import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';

class GameRepository {
  Future<List<CategoryModel>> getCategories() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Category'));
    final response = await query.query();

    if (response.success && response.results != null) {
      return (response.results as List<ParseObject>)
          .map((e) => CategoryModel.fromParse(e))
          .toList();
    }
    return [];
  }

  Future<List<QuestionModel>> getQuestionsByCategory(String categoryId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Question'))
      ..whereEqualTo('category', (ParseObject('Category')..objectId = categoryId).toPointer());
    
    final response = await query.query();

    if (response.success && response.results != null) {
      return (response.results as List<ParseObject>)
          .map((e) => QuestionModel.fromParse(e))
          .toList();
    }
    return [];
  }

  Future<void> updateScore(int points) async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser != null) {
      final currentScore = currentUser.get<num>('totalScore') ?? 0;
      currentUser.set('totalScore', currentScore + points);
      await currentUser.save();
    }
  }

  Future<List<ParseObject>> getLeaderboard() async {
    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..orderByDescending('totalScore')
      ..setLimit(10);

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    }
    return [];
  }
}
