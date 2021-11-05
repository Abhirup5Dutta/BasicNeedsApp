import 'package:basic_needs/providers/store_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  int _index = 0;
  int _dataLength = 1;

  @override
  void didChangeDependencies() {
    // We can use context here
    var _storeProvider = Provider.of<StoreProvider>(context);
    getBannerImageFromDb(_storeProvider);
    super.didChangeDependencies();
  }

  Future getBannerImageFromDb(StoreProvider storeProvider) async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore
        .collection('vendorbanner')
        .where('sellerUid', isEqualTo: storeProvider.storedetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getBannerImageFromDb(_storeProvider),
              builder: (_, snapShot) {
                return snapShot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                        ),
                        child: CarouselSlider.builder(
                          itemCount: snapShot.data.length,
                          itemBuilder: (context, int index) {
                            DocumentSnapshot sliderImage = snapShot.data[index];
                            Map getImage = sliderImage.data();
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                getImage['imageUrl'],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 180,
                            onPageChanged: (int i, carouselPageChangedReason) {
                              setState(() {
                                _index = i;
                              });
                            },
                          ),
                        ),
                      );
              },
            ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
    ;
  }
}
