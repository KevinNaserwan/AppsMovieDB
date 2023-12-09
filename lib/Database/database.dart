import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addFavorite(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("favorite")
        .doc()
        .set(userInfoMap);
  }
}
