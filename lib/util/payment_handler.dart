import 'package:apple_shop_application/util/extensions/string_extensions.dart';
import 'package:apple_shop_application/util/url_handler.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:zarinpal/zarinpal.dart';

abstract class PaymentHandler {
  Future<void> initPaymentRequest(int finalPrice);
  Future<void> sendPaymentRequest();
  Future<void> verifyPaymentRequest();
}

class ZarinpalPaymentHandler extends PaymentHandler {
  final PaymentRequest _paymentRequest;
  final UrlHandler _urlHandler;
  String? _authority;
  String? _status;
  ZarinpalPaymentHandler(this._paymentRequest, this._urlHandler);
  @override
  Future<void> initPaymentRequest(int finalPrice) async {
    _paymentRequest.setIsSandBox(true);
    _paymentRequest.setAmount(finalPrice);
    _paymentRequest.setDescription('صفحه ی تستی پرداخت سبد خرید اپل شاپ');
    _paymentRequest.setMerchantID('d645fba8-1b29-11ea-be59-000c295eb8fc');
    _paymentRequest.setCallbackURL('expertflutter://shop');
    linkStream.listen(
      (deepLink) {
        if (deepLink!.toLowerCase().contains('authority')) {
          _authority = deepLink.extractValueFromQuery('Authority');
          _status = deepLink.extractValueFromQuery('Status');
          verifyPaymentRequest();
        }
      },
    );
  }

  @override
  Future<void> sendPaymentRequest() async {
    ZarinPal().startPayment(
      _paymentRequest,
      (status, paymentGatewayUri) {
        if (status == 100) {
          _urlHandler.openUrl(paymentGatewayUri!);
        }
      },
    );
  }

  @override
  Future<void> verifyPaymentRequest() async {
    ZarinPal().verificationPayment(
      _status!,
      _authority!,
      _paymentRequest,
      (isPaymentSuccess, refID, paymentRequest) {
        if (isPaymentSuccess) {
          print(refID);
        } else {
          print('error');
        }
      },
    );
  }
}
