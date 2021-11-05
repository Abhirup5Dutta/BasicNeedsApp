import 'package:basic_needs/widgets/categories_widget.dart';
import 'package:basic_needs/widgets/products/best_selling_product.dart';
import 'package:basic_needs/widgets/products/featured_products.dart';
import 'package:basic_needs/widgets/products/recently_added_products.dart';
import 'package:basic_needs/widgets/vendor_appbar.dart';
import 'package:basic_needs/widgets/vendor_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            // Recently added products
            // Best Selling Products
            // Featured Products
            RecentlyAddedProducts(),
            FeaturedProducts(),
            BestSellingProduct(),
          ],
        ),
      ),
    );
  }
}
