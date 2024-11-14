import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (!authService.isAuthenticated) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please login to view your profile'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = authService.currentUser!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authService.logout(),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(user.name),
                subtitle: const Text('Member since 2024'),
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(user.email),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(user.phone),
              ),
              const Divider(),
              const Text('Booking History', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: authService.getUserBookings(user.email),
                builder: (context, snapshot) {
                  final bookings = snapshot.data ?? [];
                  return Column(
                    children: bookings.map((booking) => _buildHistoryItem(
                      booking['courtType'],
                      booking['date'],
                      booking['time'],
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
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