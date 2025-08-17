import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String displayName;
  final String handle;
  final String email;
  const UserCard({
    super.key,
    required this.displayName,
    required this.handle,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(displayName),
        subtitle: Text('$handle\n$email'),
        isThreeLine: true,
      ),
    );
  }
}
