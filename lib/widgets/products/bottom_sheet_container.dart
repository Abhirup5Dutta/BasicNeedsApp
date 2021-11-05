import 'package:basic_needs/widgets/products/add_to_cart_widget.dart';
import 'package:basic_needs/widgets/products/save_for_later.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot document;

  BottomSheetContainer(this.document);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: SaveForLater(widget.document),
          ),
          Flexible(
            flex: 1,
            child: AddToCartWidget(widget.document),
          ),
        ],
      ),
    );
  }
}
