import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {
  bool expired;
  DocumentSnapshot document;
  int discountRate = 0;

  getCouponDetails(title, sellerId) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();
    if (document != null) {
      if (document.exists) {
        this.document = document;
        notifyListeners();
        if (document.data()['sellerId'] == sellerId) {
          checkExpiry(document);
        }
      } else {
        this.document = null;
        notifyListeners();
      }
    }
  }

  checkExpiry(DocumentSnapshot document) {
    DateTime date = document.data()['Expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff < 0) {
      // coupon expired
      this.expired = true;
      notifyListeners();
    } else {
      this.document = document;
      this.expired = false;
      this.discountRate = document.data()['discountRate'];
      notifyListeners();
    }
  }
}
