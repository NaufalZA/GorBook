import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/booking_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';  // Add this import
import 'screens/register_screen.dart';  // Update this import
import 'Matematis/calculator.dart';  // Add this import

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
          seedColor: const Color(0xFF5669FF), // Changed this color
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
    Calculator(),          // First position
    const CourtsListScreen(),  // Middle position
    const ProfileScreen(), // Last position
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for curved navbar
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBarCurved(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

// Add these new classes
class BottomNavBarCurved extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavBarCurved({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Colors.black54;
    final backgroundColor = Colors.white;

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height + 6),
            painter: BottomNavCurvePainter(backgroundColor: backgroundColor),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF5669FF), // Update FAB color
              shape: const CircleBorder(), // Add this line
              child: const ImageIcon(
                AssetImage('assets/images/icon.png'),
                color: Colors.white,
              ),
              elevation: 0.1,
              onPressed: () => onItemSelected(1),
            ),
          ),
          SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Change from spaceAround
              children: [
                NavBarIcon(
                  text: "Math",
                  icon: Icons.calculate,
                  selected: selectedIndex == 0,
                  onPressed: () => onItemSelected(0),
                  selectedColor: const Color(0xFF5669FF), // Update color
                ),
                const SizedBox(width: 56),
                NavBarIcon(
                  text: "Profile",
                  icon: Icons.person,
                  selected: selectedIndex == 2,
                  onPressed: () => onItemSelected(2),
                  selectedColor: const Color(0xFF5669FF), // Update color
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  final Color backgroundColor;
  final double insetRadius;

  BottomNavCurvePainter({
    this.backgroundColor = Colors.white,
    this.insetRadius = 38,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 12);

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;
    double transitionToInsetCurveWidth = size.width * .05;

    path.quadraticBezierTo(size.width * 0.20, 0,
        insetCurveBeginnningX - transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(
        insetCurveBeginnningX, 0, insetCurveBeginnningX, insetRadius / 2);

    path.arcToPoint(Offset(insetCurveEndX, insetRadius / 2),
        radius: const Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(
        insetCurveEndX, 0, insetCurveEndX + transitionToInsetCurveWidth, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 12);
    path.lineTo(size.width, size.height + 56);
    path.lineTo(0, size.height + 56);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class NavBarIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color selectedColor;
  final Color defaultColor;

  const NavBarIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.selectedColor = const Color(0xFF5669FF), // Update selected color
    this.defaultColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? selectedColor : defaultColor,
          ),
        ),
      ],
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
        title: const Text('GorBook'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Update padding to add more space at bottom
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
            'For You GOR',
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
            'List GOR',
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
                  ),  // Add missing comma and closing parenthesis here
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
                                backgroundColor: const Color(0xFF5669FF), // Update this color
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
