import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> seedDatabase() async {
  // Verify if categories already exist
  final query = QueryBuilder<ParseObject>(ParseObject('Category'));
  final countResponse = await query.count();
  if (countResponse.success && countResponse.count > 0) {
    debugPrint('Database already seeded.');
    return;
  }

  debugPrint('Seeding database...');

  // Create Categories
  final mathCat = ParseObject('Category')
    ..set('name', 'Matemática')
    ..set('color', '#F44336'); // Red
  final histCat = ParseObject('Category')
    ..set('name', 'História')
    ..set('color', '#FF9800'); // Orange
  final geoCat = ParseObject('Category')
    ..set('name', 'Geografia')
    ..set('color', '#4CAF50'); // Green
  final langCat = ParseObject('Category')
    ..set('name', 'Linguagens')
    ..set('color', '#2196F3'); // Blue

  // Save categories to get objectIds
  final catResponse = await Future.wait([
    mathCat.save(),
    histCat.save(),
    geoCat.save(),
    langCat.save(),
  ]);

  for (var res in catResponse) {
    if (!res.success) {
      debugPrint('Error saving category: ${res.error?.message}');
      return;
    }
  }

  // Create Questions
  final questions = [
    ParseObject('Question')
      ..set('text', 'Quanto é 7 x 8?')
      ..set('category', mathCat.toPointer())
      ..set('options', ['54', '56', '58', '62'])
      ..set('correctAnswerIndex', 1),
    ParseObject('Question')
      ..set('text', 'Qual a raiz quadrada de 144?')
      ..set('category', mathCat.toPointer())
      ..set('options', ['10', '12', '14', '16'])
      ..set('correctAnswerIndex', 1),
    ParseObject('Question')
      ..set('text', 'Quem descobriu o Brasil?')
      ..set('category', histCat.toPointer())
      ..set('options', ['Pedro Álvares Cabral', 'Cristóvão Colombo', 'Vasco da Gama', 'Dom Pedro I'])
      ..set('correctAnswerIndex', 0),
    ParseObject('Question')
      ..set('text', 'Em que ano começou a Segunda Guerra Mundial?')
      ..set('category', histCat.toPointer())
      ..set('options', ['1914', '1939', '1945', '1989'])
      ..set('correctAnswerIndex', 1),
    ParseObject('Question')
      ..set('text', 'Qual o maior país do mundo em extensão territorial?')
      ..set('category', geoCat.toPointer())
      ..set('options', ['Brasil', 'Canadá', 'Estados Unidos', 'Rússia'])
      ..set('correctAnswerIndex', 3),
    ParseObject('Question')
      ..set('text', 'Qual é a capital da Austrália?')
      ..set('category', geoCat.toPointer())
      ..set('options', ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'])
      ..set('correctAnswerIndex', 2),
    ParseObject('Question')
      ..set('text', 'Qual a figura de linguagem presente em "Ele chorou rios de lágrimas"?')
      ..set('category', langCat.toPointer())
      ..set('options', ['Metáfora', 'Hipérbole', 'Eufemismo', 'Ironia'])
      ..set('correctAnswerIndex', 1),
    ParseObject('Question')
      ..set('text', 'Quem escreveu "Dom Casmurro"?')
      ..set('category', langCat.toPointer())
      ..set('options', ['José de Alencar', 'Machado de Assis', 'Monteiro Lobato', 'Graciliano Ramos'])
      ..set('correctAnswerIndex', 1),
  ];

  final qResponse = await Future.wait(questions.map((q) => q.save()));
  for (var res in qResponse) {
    if (!res.success) {
      debugPrint('Error saving question: ${res.error?.message}');
      return;
    }
  }

  debugPrint('Database seeded successfully!');
}

void debugPrint(String msg) {
  // ignore: avoid_print
  print(msg);
}
