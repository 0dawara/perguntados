import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'gameplay_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ParseObject> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Category'));
    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        _categories = response.results as List<ParseObject>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playCategory(ParseObject category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameplayScreen(category: category)),
    );
  }

  void _playRandom() {
    if (_categories.isEmpty) return;
    final random = Random();
    final randomCategory = _categories[random.nextInt(_categories.length)];
    _playCategory(randomCategory);
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Escolha uma Categoria'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final catName = cat.get<String>('name') ?? 'Categoria';
                  final catColorHex = cat.get<String>('color') ?? '#cccccc';
                  final catColor = _hexToColor(catColorHex);

                  return InkWell(
                    onTap: () => _playCategory(cat),
                    child: Container(
                      decoration: BoxDecoration(
                        color: catColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          catName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.shuffle, size: 30),
                label: const Text('Roleta: Categoria Aleatória', style: TextStyle(fontSize: 18)),
                onPressed: _playRandom,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
