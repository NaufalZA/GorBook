import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/booking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';  // Add this import
import 'screens/signup_screen.dart';  // Add this import
import 'screens/register_screen.dart';  // Update this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.init();
  
  runApp(
    ChangeNotifierProvider<AuthService>.value(
      value: authService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GOR Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),  // Use SplashScreen as initial route
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),  // Add this route
        '/signup': (context) => const SignupScreen(),  // Add this route
        '/register': (context) => const RegisterScreen(),  // Update this route
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CourtsListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sports_tennis),
            label: 'Courts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CourtsListScreen extends StatelessWidget {
  const CourtsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('GOR Booking'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildPopularCourts(context),
          const SizedBox(height: 24),
          _buildCourtsList(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search courts...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildPopularCourts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Popular Courts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPopularCourtCard(
                context,
                'Gor Badminton Haji Nopal',
                '4.8',
                'assets/images/gor_badminton.png',
              ),
              _buildPopularCourtCard(
                context,
                'Gor Basket ITENAS',
                '4.8',
                'assets/images/gor_basket.png',
              ),
              _buildPopularCourtCard(
                context,
                'Gor Futsal AutoWin',
                '4.6',
                'assets/images/gor_futsal.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCourtCard(
    BuildContext context,
    String name,
    String rating,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingScreen(courtType: name),
        ),
      ),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Consumer<AuthService>(
                builder: (context, authService, _) => FutureBuilder<double>(
                  future: authService.getCourtRating(name),
                  builder: (context, snapshot) {
                    final rating = snapshot.data ?? 0.0;
                    return Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourtsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'All Courts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildModernCourtCard(
          context,
          'Gor Badminton Haji Nopal',
          'Rp 70.000/Jam',
          Icons.sports_tennis,
          4.8,
          28,
          'assets/images/gor_badminton.png',
        ),
        _buildModernCourtCard(
          context,
          'Gor Basket ITENAS',
          'Rp 70.000/Jam',
          Icons.sports_basketball,
          4.6,
          42,
          'assets/images/gor_basket.png',
        ),
        _buildModernCourtCard(
          context,
          'Gor Futsal AutoWin',
          'Rp 70.000/Jam',
          Icons.sports_soccer,
          4.7,
          35,
          'assets/images/gor_futsal.png',
        ),
      ],
    );
  }

  Widget _buildModernCourtCard(
    BuildContext context,
    String title,
    String price,
    IconData icon,
    double rating,
    int reviews,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<AuthService>(
                    builder: (context, authService, _) => FutureBuilder<List<Map<String, dynamic>>>(
                      future: authService.getCourtReviews(title),
                      builder: (context, snapshot) {
                        final reviewCount = snapshot.data?.length ?? 0;
                        return Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            FutureBuilder<double>(
                              future: authService.getCourtRating(title),
                              builder: (context, ratingSnapshot) {
                                final rating = ratingSnapshot.data ?? 0.0;
                                return Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount reviews)',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingScreen(courtType: title),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                minimumSize: const Size(60, 32),
                              ),
                              child: const Text('Book'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
