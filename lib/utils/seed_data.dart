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
    Map<String, ParseObject> categoryMap = {};
    Set<String> existingQuestions = {};

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
      debugPrint('[SEED] Carregando categorias existentes do banco...');
      final catQuery = QueryBuilder<ParseObject>(ParseObject('Category'))
        ..setLimit(1000);
      final catRes = await catQuery.query();
      if (catRes.success && catRes.results != null) {
        for (var cat in catRes.results as List<ParseObject>) {
          final name = cat.get<String>('name');
          if (name != null) {
            categoryMap[name] = cat;
          }
        }
      }

      debugPrint('[SEED] Carregando questões existentes do banco...');
      final qQuery = QueryBuilder<ParseObject>(ParseObject('Question'))
        ..setLimit(1000);
      final qRes = await qQuery.query();
      if (qRes.success && qRes.results != null) {
        for (var q in qRes.results as List<ParseObject>) {
          final text = q.get<String>('text');
          if (text != null) {
            existingQuestions.add(text);
          }
        }
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

    for (var cat in categoriesData) {
      final name = cat['name'] as String;
      if (categoryMap.containsKey(name)) {
        continue;
      }
      debugPrint('[SEED] Salvando categoria: $name...');
      final obj = ParseObject('Category')
        ..set('name', name)
        ..set('color', cat['color']);

      final res = await obj.save();
      if (res.success) {
        categoryMap[name] = obj; // Reference with objectId
      } else {
        debugPrint(
          '[SEED] Erro ao salvar categoria $name: ${res.error?.message}',
        );
      }
    }

    // Parse Questions
    final List<dynamic> questionsData = data['questions'];
    debugPrint('[SEED] Encontradas ${questionsData.length} questões no JSON.');

    int savedQuestionsCount = 0;
    int skippedQuestionsCount = 0;
    for (int i = 0; i < questionsData.length; i++) {
      var q = questionsData[i];
      final qText = q['text'] as String;
      if (existingQuestions.contains(qText)) {
        skippedQuestionsCount++;
        continue;
      }

      final categoryName = q['category'];
      final catPointer = categoryMap[categoryName]?.toPointer();

      if (catPointer == null) {
        debugPrint(
          '[SEED] AVISO: Categoria "$categoryName" não encontrada para a questão: $qText',
        );
        continue;
      }

      final obj = ParseObject('Question')
        ..set('text', qText)
        ..set('category', catPointer)
        ..set('options', List<String>.from(q['options']))
        ..set('correctAnswerIndex', q['correctAnswerIndex']);

      final res = await obj.save();
      if (res.success) {
        savedQuestionsCount++;
        debugPrint(
          '[SEED] [${i + 1}/${questionsData.length}] Questão salva com sucesso: $qText',
        );
      } else {
        debugPrint('[SEED] Erro ao salvar questão: ${res.error?.message}');
      }
    }

    debugPrint(
      '[SEED] Sincronização concluída! Categorias no mapa: ${categoryMap.length}, Novas questões salvas: $savedQuestionsCount (Existentes/Ignoradas: $skippedQuestionsCount).',
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
