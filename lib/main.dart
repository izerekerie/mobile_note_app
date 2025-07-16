import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/note_provider.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1), // Indigo
            brightness: Brightness.light,
          ),
          // Enhanced App Bar Theme
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFF1F2937),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          // Enhanced Card Theme
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            shadowColor: const Color(0xFF6366F1).withOpacity(0.1),
          ),
          // Enhanced Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Enhanced Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Enhanced Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
          ),
          // Enhanced Floating Action Button Theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          // Enhanced Icon Theme
          iconTheme: const IconThemeData(color: Color(0xFF6366F1), size: 24),
          // Enhanced Text Theme
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF374151),
              height: 1.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (authProvider.isAuthenticated) {
          return const NotesScreen();
        }

        return const AuthScreen();
      },
    );
  }
}
