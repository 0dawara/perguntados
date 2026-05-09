import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<ParseObject> _topUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..orderByDescending('totalScore')
      ..setLimit(10); // Top 10

    final response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        _topUsers = response.results as List<ParseObject>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Placar Global'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _topUsers.isEmpty
                  ? const Center(child: Text('Nenhum jogador encontrado.', style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: _topUsers.length,
                      itemBuilder: (context, index) {
                        final user = _topUsers[index];
                        final username = user.get<String>('username') ?? 'Desconhecido';
                        final score = user.get<num>('totalScore') ?? 0;

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: index == 0
                                  ? Colors.amber
                                  : index == 1
                                      ? Colors.grey[400]
                                      : index == 2
                                          ? Colors.brown[300]
                                          : Colors.blue,
                              child: Text(
                                '${index + 1}º',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            trailing: Text(
                              '$score pts',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
