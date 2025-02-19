import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AppModel>> getApps() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('apps').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AppModel.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();
    } catch (e) {
      throw Exception("Failed to load apps: $e");
    }
  }

  Future<void> createApp(AppModel app) async {
    try {
      await _firestore.collection('apps').add({
        'name': app.name,
        'platform': app.platform,
        'version': app.version,
      });
    } catch (e) {
      throw Exception("Failed to create app: $e");
    }
  }
}
