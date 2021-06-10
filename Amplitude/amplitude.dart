import 'package:amplitude_flutter/amplitude.dart';

class AmplitudeAnalytics{

  static Amplitude analytics;
  static String apiKey = '8d63959df8b8e5b12b336de6da2823e5';

  static  Future<Amplitude> initialize(String user_id) async {


    analytics = Amplitude.getInstance(instanceName: "Pomidor");
    analytics.setServerUrl("https://api2.amplitude.com");
    analytics.init(apiKey);
    analytics.enableCoppaControl();
    await analytics.setUserId(user_id);
    analytics.trackingSessionEvents(true);

    return analytics;
  }
}