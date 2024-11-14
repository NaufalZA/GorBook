import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'reviews_screen.dart';

class BookingScreen extends StatefulWidget {
  final String courtType;
  const BookingScreen({super.key, required this.courtType});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '08:00';
  final List<String> timeSlots = [
    '08:00', '09:00', '10:00', '11:00', '13:00', 
    '14:00', '15:00', '16:00', '17:00', '18:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courtType}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.reviews),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewsScreen(courtType: widget.courtType),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text('Tanggal: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Jadwal:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeSlots.map((time) => ChoiceChip(
                label: Text(time),
                selected: selectedTime == time,
                onSelected: (selected) {
                  setState(() => selectedTime = selected ? time : selectedTime);
                },
              )).toList(),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Harga  : Rp 70.000/hour', style: TextStyle(fontSize: 16)),
                    Text('Durasi : 1 hour', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF5669FF), // Add this line
                  foregroundColor: Colors.white, // Add this line for text color
                ),
                onPressed: () => _showConfirmationDialog(context),
                child: const Text('BOOKING'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final authService = context.read<AuthService>();
    if (!authService.isAuthenticated) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to login to make a booking'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Login'),
            ),
          ],
        ),
      );
      
      if (result == true) {
        Navigator.pushNamed(context, '/login');
      }
      return;
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Court: ${widget.courtType}'),
            Text('Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}'),
            Text('Time: $selectedTime'),
            const Text('Price: Rp 70.000'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authService.addBooking(authService.currentUser!.email, {
                'courtType': widget.courtType,
                'date': DateFormat('dd/MM/yyyy').format(selectedDate),
                'time': selectedTime,
                'price': 100000,
                'timestamp': DateTime.now().toIso8601String(),
              });
              
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking successful!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}