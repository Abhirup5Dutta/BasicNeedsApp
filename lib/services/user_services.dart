// For all firebase related services for user
import 'package:basic_needs/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = 'users';

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  // Update user data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  // Get user data by user id
  Future<void> getUserById(String id) async {
    await _firestore.collection(collection).doc(id).get().then((doc) {
      if (doc.data() == null) {
        return null;
      }

      return UserModel.fromSnapshot(doc);
    });
  }
}
