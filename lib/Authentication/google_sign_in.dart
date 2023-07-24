import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSingIn = GoogleSignIn(
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
    clientId:Platform.isIOS ? dotenv.env['GOOGLE_IOS_CLIENT_ID'] :  dotenv.env['GOOGLE_CLIENT_ID'],
    scopes: [
      'email',
      'profile'
    ],
  );

  static Future<GoogleSignInAccount?> logIn() => _googleSingIn.signIn();

  static Future logout() => _googleSingIn.disconnect();
}
