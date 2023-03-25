String generateGoogleSignInUrl(String clientId, String redirectUri) {
  const String baseUrl = "https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount";
  const String responseType = "code";
  const String scope = "email";
  const String prompt = "select_account";

  return Uri.encodeFull(
      "$baseUrl?client_id=$clientId&redirect_uri=$redirectUri&scope=$scope&response_type=$responseType&prompt=$prompt");
}


import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

Future<void> signInWithGoogle() async {
  String clientId = "your_google_client_id_here";
  String redirectUri = "your_redirect_uri_here";

  String signInUrl = generateGoogleSignInUrl(clientId, redirectUri);

  // Open the modified URL in the user's browser
  if (await canLaunch(signInUrl)) {
    await launch(signInUrl);
  } else {
    throw 'Could not launch $signInUrl';
  }
}



dependencies:
  url_launcher: ^6.0.13
  uni_links: ^0.5.1


  import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';

// Replace these values with your own
const String clientId = "your_google_client_id";
const String clientSecret = "your_google_client_secret";
const String redirectUri = "your_redirect_uri";

// This method exchanges the authorization code for tokens
Future<Map<String, dynamic>> exchangeCodeForTokens(String code) async {
  final response = await http.post(
    Uri.parse("https://oauth2.googleapis.com/token"),
    body: {
      "code": code,
      "client_id": clientId,
      "client_secret": clientSecret,
      "redirect_uri": redirectUri,
      "grant_type": "authorization_code",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to exchange code for tokens');
  }
}

// This method listens for the incoming link containing the authorization code
StreamSubscription? _sub;

void _listenForLink() async {
  _sub = getUriLinksStream().listen((Uri? uri) async {
    if (uri != null && uri.queryParameters.containsKey('code')) {
      // Extract the authorization code from the incoming link
      String code = uri.queryParameters['code']!;

      // Exchange the authorization code for tokens
      try {
        Map<String, dynamic> tokens = await exchangeCodeForTokens(code);

        // Use the tokens to authenticate with Cognito or manage user sessions manually
        print('Access token: ${tokens["access_token"]}');
        print('Refresh token: ${tokens["refresh_token"]}');
        print('ID token: ${tokens["id_token"]}');
      } catch (e) {
        print('Error exchanging code for tokens: $e');
      }
    }
  }, onError: (Object err) {
    print('Failed to listen for incoming link: $err');
  });
}

@override
void initState() {
  super.initState();
  _listenForLink();
}

@override
void dispose() {
  _sub?.cancel();
  super.dispose();
}



dependencies:
  amazon_cognito_identity_dart_2: ^0.2.2


import 'package:amazon_cognito_identity_dart_2/cognito.dart';

CognitoUser createCognitoUserWithTokens(
    String username, Map<String, dynamic> tokens) {
  // Replace these values with your own
  String userPoolId = 'your_cognito_user_pool_id';
  String clientId = 'your_cognito_client_id';

  // Create CognitoUserPool and CognitoUser objects
  CognitoUserPool userPool =
      new CognitoUserPool(userPoolId, clientId);
  CognitoUser user = new CognitoUser(username, userPool);

  // Create CognitoUserSession with the tokens
  CognitoUserSession session = new CognitoUserSession(
    idToken: new CognitoIdToken(tokens['id_token']),
    accessToken: new CognitoAccessToken(tokens['access_token']),
    refreshToken: new CognitoRefreshToken(tokens['refresh_token']),
  );

  // Set the session for the user
  user.setSession(session);

  return user;
}



void getUserAttributes(CognitoUser user) async {
  try {
    List<CognitoUserAttribute> attributes = await user.getUserAttributes();
    attributes.forEach((attribute) {
      print('Attribute ${attribute.getName()}: ${attribute.getValue()}');
    });
  } catch (e) {
    print('Error getting user attributes: $e');
  }
}

void signOut(CognitoUser user) {
  user.signOut();
}



