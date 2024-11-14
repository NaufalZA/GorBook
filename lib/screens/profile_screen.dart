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
            appBar: AppBar(title: const Text('Profil')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Silahkan Login Terlebih Dahulu'),
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
            title: const Text(
              'Profil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5669FF), Color(0xFF4054EA)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
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
              const Text('History Booking', 
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