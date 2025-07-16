import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    bool success;
    if (_isLogin) {
      success = await authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await authProvider.signUp(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isLogin ? 'Successfully logged in!' : 'Account created successfully!',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
    Provider.of<AuthProvider>(context, listen: false).clearError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6366F1).withOpacity(0.1),
              const Color(0xFF8B5CF6).withOpacity(0.05),
              const Color(0xFFF9FAFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // App Icon and Title
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6366F1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.note_alt_rounded,
                                      size: 48,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Notes App',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _isLogin ? 'Welcome back!' : 'Create your account',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Email Field
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                      hintText: 'Enter your email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock_outlined),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                      hintText: 'Enter your password',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (!_isLogin && value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 32),

                                  // Submit Button
                                  Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: authProvider.isLoading ? null : _submitForm,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF6366F1),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: authProvider.isLoading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  _isLogin ? 'Sign In' : 'Create Account',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Error Message
                                  Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) {
                                      if (authProvider.error != null) {
                                        return Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF2F2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFFECACA)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                color: Color(0xFFDC2626),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  authProvider.error!,
                                                  style: const TextStyle(
                                                    color: Color(0xFFDC2626),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  const SizedBox(height: 32),

                                  // Toggle Login/Signup
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _isLogin ? "Don't have an account? " : "Already have an account? ",
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 16,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _toggleAuthMode,
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(0xFF6366F1),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        ),
                                        child: Text(
                                          _isLogin ? 'Sign Up' : 'Sign In',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 