import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  const PlayerTile({
    super.key,
    required this.name,
    required this.isHost,
    required this.connected,
  });

  final String name;
  final bool isHost;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name.substring(0, 1).toUpperCase())),
        title: Text(name),
        subtitle: isHost ? const Text('Host') : null,
        trailing: Icon(
          connected ? Icons.circle : Icons.circle_outlined,
          color: connected ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
