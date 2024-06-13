import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ticketeasy/stripe_payment/stripe_keys.dart';

abstract class PaymentManager{

  static Future<void>makePayment(int amount,String currency)async{ 
    try {
      String clientSecret=await _getClientSecret((amount).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static Future<void>_initializePaymentSheet(String clientSecret)async{
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "TicketEasy",
      ),
    );
  }

  static Future<String> _getClientSecret(String amount,String currency)async{ // this function will talk with stripe and return the clent sercet based on the amound and currency
    Dio dio=Dio(); // http request
    var response= await dio.post(
      'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }

}