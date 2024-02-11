import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plane/config/config_variables.dart';

class GoogleSignInApi {
  static final _googleSingIn = GoogleSignIn(
    serverClientId: Config.googleServerClientId,
    clientId:
        Platform.isIOS ? Config.googleIosClientId :Config.googleServerClientId,
    scopes: ['email', 'profile'],
  );

  static Future<GoogleSignInAccount?> logIn() => _googleSingIn.signIn();

  static Future logout() => _googleSingIn.disconnect();
}
