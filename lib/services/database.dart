import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .set(userInfoMap);
  }

  Future addProduct(String categoryName, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance.collection(categoryName).add(userInfoMap);
  }
}
