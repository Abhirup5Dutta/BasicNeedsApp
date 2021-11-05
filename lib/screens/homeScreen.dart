import 'package:basic_needs/widgets/near_by_store.dart';
import 'package:basic_needs/widgets/top_pick_store.dart';
import 'package:basic_needs/widgets/images_slider.dart';
import 'package:basic_needs/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-sreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: [
            ImageSlider(),
            Container(
              color: Colors.white,
              child: TopPickStore(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
              ),
              child: NearByStores(),
            ),
          ],
        ),
      ),
    );
  }
}
