import 'package:basic_needs/providers/order_provider.dart';
import 'package:basic_needs/services/payment/stripe_payment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ExistingCardsPage extends StatefulWidget {
  static const String id = 'existing-cards';
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  StripeService _service = StripeService();

  Future<StripeTransactionResponse> payViaExistingCard(
      BuildContext context, card, amount) async {
    await EasyLoading.show(status: 'Please wait...');
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '${amount}00', currency: 'INR', card: stripeCard);
    await EasyLoading.dismiss();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Choose existing card',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _service.cards.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.size == 0) {
            return Center(
              child: Text('No Credit Cards added in your account'),
            );
          }

          return Container(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 10,
              bottom: 10,
            ),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var card = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    payViaExistingCard(context, card, orderProvider.amount)
                        .then((response) {
                      if (response.success == true) {
                        orderProvider.paymentStatus(response.success);
                      }
                    });
                  },
                  child: CreditCardWidget(
                    cardNumber: card['cardNumber'],
                    expiryDate: card['expiryDate'],
                    cardHolderName: card['cardHolderName'],
                    cvvCode: card['cvvCode'],
                    showBackView: false,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
