import 'package:basic_needs/providers/auth_provider.dart';
import 'package:basic_needs/providers/cart_provider.dart';
import 'package:basic_needs/providers/coupon_provider.dart';
import 'package:basic_needs/providers/location_provider.dart';
import 'package:basic_needs/providers/order_provider.dart';
import 'package:basic_needs/providers/store_provider.dart';
import 'package:basic_needs/screens/cart_screen.dart';
import 'package:basic_needs/screens/homeScreen.dart';
import 'package:basic_needs/screens/landing_screen.dart';
import 'package:basic_needs/screens/login_screen.dart';
import 'package:basic_needs/screens/main_screen.dart';
import 'package:basic_needs/screens/map_screen.dart';
import 'package:basic_needs/screens/my_orders_screen.dart';
import 'package:basic_needs/screens/payment/create_new_card_screen.dart';
import 'package:basic_needs/screens/payment/credit_card_list.dart';
import 'package:basic_needs/screens/payment/razorpay/razorpay_payment_screen.dart';
import 'package:basic_needs/screens/payment/stripe/existing-cards.dart';
import 'package:basic_needs/screens/payment/payment_home.dart';
import 'package:basic_needs/screens/product_details_screen.dart';
import 'package:basic_needs/screens/product_list_screen.dart';
import 'package:basic_needs/screens/profile_screen.dart';
import 'package:basic_needs/screens/profile_update_screen.dart';
import 'package:basic_needs/screens/splash_screen.dart';
import 'package:basic_needs/screens/vendor_home_screen.dart';
import 'package:basic_needs/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        CartScreen.id: (context) => CartScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        UpdateProfile.id: (context) => UpdateProfile(),
        ExistingCardsPage.id: (context) => ExistingCardsPage(),
        PaymentHome.id: (context) => PaymentHome(),
        MyOrders.id: (context) => MyOrders(),
        CreditCardList.id: (context) => CreditCardList(),
        CreateNewCreditCard.id: (context) => CreateNewCreditCard(),
        RazorPaymentScreen.id: (context) => RazorPaymentScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
