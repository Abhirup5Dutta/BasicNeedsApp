import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<DocumentReference> saveOrder(Map<String, dynamic> data) {
    var result = orders.add(data);
    return result;
  }

  Color statusColor(document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.deepPurpleAccent;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(
        Icons.cases,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  String statusComment(document) {
    if (document.data()['orderStatus'] == 'Picked Up') {
      return 'Your order is Picked by ${document.data()['deliveryBoy']['name']}';
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return 'Your delivery person ${document.data()['deliveryBoy']['name']} is on the way';
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return 'Your order is now completed';
    }
    return 'Mr.${document.data()['deliveryBoy']['name']} is on the way to pick your Order';
  }
}
