import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/di/injection_container.dart';

class SearchDecksUseCase {
  final FirebaseService _firebaseService = sl<FirebaseService>();

  Future<List<Map<String, dynamic>>> call(String prefix) async {
    return await _firebaseService.searchDecksByTitle(prefix.toLowerCase());
  }
}