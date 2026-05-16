import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

bool _isSeeding = false;

Future<void> seedDatabase({bool force = false}) async {
  if (_isSeeding) {
    debugPrint(
      '[SEED] Sincronização já está em andamento. Ignorando nova chamada.',
    );
    return;
  }
  _isSeeding = true;

  try {
    if (force) {
      debugPrint('[SEED] Forçando limpeza do banco de dados...');

      // Delete all existing Questions
      debugPrint('[SEED] Buscando Questões para deletar...');
      final qQuery = QueryBuilder<ParseObject>(ParseObject('Question'))
        ..setLimit(1000);
      final qResponse = await qQuery.query();
      if (qResponse.success && qResponse.results != null) {
        final questionsToDelete = qResponse.results as List<ParseObject>;
        debugPrint(
          '[SEED] Deletando ${questionsToDelete.length} questões antigas...',
        );
        for (var q in questionsToDelete) {
          final res = await q.delete();
          if (!res.success) {
            debugPrint('[SEED] Erro ao deletar questão: ${res.error?.message}');
          }
        }
      }

      // Delete all existing Categories
      debugPrint('[SEED] Buscando Categorias para deletar...');
      final cQuery = QueryBuilder<ParseObject>(ParseObject('Category'))
        ..setLimit(1000);
      final cResponse = await cQuery.query();
      if (cResponse.success && cResponse.results != null) {
        final categoriesToDelete = cResponse.results as List<ParseObject>;
        debugPrint(
          '[SEED] Deletando ${categoriesToDelete.length} categorias antigas...',
        );
        for (var c in categoriesToDelete) {
          final res = await c.delete();
          if (!res.success) {
            debugPrint(
              '[SEED] Erro ao deletar categoria: ${res.error?.message}',
            );
          }
        }
      }
      debugPrint('[SEED] Limpeza concluída.');
    } else {
      // Verify if categories already exist
      final query = QueryBuilder<ParseObject>(ParseObject('Category'));
      final countResponse = await query.count();
      if (countResponse.success && countResponse.count > 0) {
        debugPrint(
          '[SEED] Banco de dados já possui categorias. Sincronização ignorada.',
        );
        _isSeeding = false;
        return;
      }
    }

    debugPrint('[SEED] Iniciando leitura do JSON de dados...');
    final String jsonString = await rootBundle.loadString(
      'assets/seed_data.json',
    );
    final Map<String, dynamic> data = jsonDecode(jsonString);

    // Parse Categories
    final List<dynamic> categoriesData = data['categories'];
    debugPrint(
      '[SEED] Encontradas ${categoriesData.length} categorias no JSON.',
    );

    Map<String, ParseObject> categoryMap = {};

    for (var cat in categoriesData) {
      debugPrint('[SEED] Salvando categoria: ${cat['name']}...');
      final obj = ParseObject('Category')
        ..set('name', cat['name'])
        ..set('color', cat['color']);

      final res = await obj.save();
      if (res.success) {
        categoryMap[cat['name']] = obj; // Reference with objectId
      } else {
        debugPrint(
          '[SEED] Erro ao salvar categoria ${cat['name']}: ${res.error?.message}',
        );
      }
    }

    // Parse Questions
    final List<dynamic> questionsData = data['questions'];
    debugPrint('[SEED] Encontradas ${questionsData.length} questões no JSON.');

    int savedQuestionsCount = 0;
    for (int i = 0; i < questionsData.length; i++) {
      var q = questionsData[i];
      final categoryName = q['category'];
      final catPointer = categoryMap[categoryName]?.toPointer();

      if (catPointer == null) {
        debugPrint(
          '[SEED] AVISO: Categoria "$categoryName" não encontrada para a questão: ${q['text']}',
        );
        continue;
      }

      final obj = ParseObject('Question')
        ..set('text', q['text'])
        ..set('category', catPointer)
        ..set('options', List<String>.from(q['options']))
        ..set('correctAnswerIndex', q['correctAnswerIndex']);

      final res = await obj.save();
      if (res.success) {
        savedQuestionsCount++;
        debugPrint(
          '[SEED] [${i + 1}/${questionsData.length}] Questão salva com sucesso: ${q['text']}',
        );
      } else {
        debugPrint('[SEED] Erro ao salvar questão: ${res.error?.message}');
      }
    }

    debugPrint(
      '[SEED] Sincronização concluída! Categorias salvas: ${categoryMap.length}, Questões salvas: $savedQuestionsCount.',
    );
  } catch (e) {
    debugPrint('[SEED] Erro geral durante o processo de seed: $e');
  } finally {
    _isSeeding = false;
  }
}

void debugPrint(String msg) {
  // ignore: avoid_print
  print(msg);
}
