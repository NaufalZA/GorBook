
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('John Doe'),
            subtitle: Text('Member since 2024'),
          ),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('john.doe@example.com'),
          ),
          const ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text('+62 123 4567 890'),
          ),
          const Divider(),
          const Text('Booking History', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildHistoryItem('Lapangan Badminton', '01/03/2024', '08:00'),
          _buildHistoryItem('Lapangan Futsal', '28/02/2024', '16:00'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String court, String date, String time) {
    return Card(
      child: ListTile(
        title: Text(court),
        subtitle: Text('$date - $time'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}