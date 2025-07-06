import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_flutter_app/firebase_options.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('🔥 Firebase initialized successfully');

  // Test authentication
  try {
    final auth = FirebaseAuth.instance;

    // Try to sign in anonymously for testing
    final userCredential = await auth.signInAnonymously();
    final user = userCredential.user;

    if (user != null) {
      print('✅ Authentication working - User ID: ${user.uid}');

      // Test Firestore write
      final firestore = FirebaseFirestore.instance;
      final testDoc = await firestore.collection('test').add({
        'message': 'Test from Flutter',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      print('✅ Firestore write working - Document ID: ${testDoc.id}');

      // Test Firestore read
      final testQuery = await firestore
          .collection('test')
          .where('userId', isEqualTo: user.uid)
          .get();

      print(
        '✅ Firestore read working - Found ${testQuery.docs.length} documents',
      );

      // Test notes collection
      final notesQuery = await firestore
          .collection('notes')
          .where('userId', isEqualTo: user.uid)
          .get();

      print(
        '✅ Notes collection accessible - Found ${notesQuery.docs.length} notes',
      );

      // Clean up test document
      await testDoc.delete();
      print('✅ Test cleanup completed');
    } else {
      print('❌ Authentication failed - No user returned');
    }
  } catch (e) {
    print('❌ Error during testing: $e');

    if (e.toString().contains('PERMISSION_DENIED')) {
      print(
        '🔧 Solution: Update Firestore security rules to allow authenticated users',
      );
    } else if (e.toString().contains('FAILED_PRECONDITION')) {
      print('🔧 Solution: Create Firestore index for notes collection');
    } else if (e.toString().contains('NOT_FOUND')) {
      print('🔧 Solution: Create Firestore database');
    }
  }

  // Sign out
  await FirebaseAuth.instance.signOut();
  print('👋 Test completed');
}
