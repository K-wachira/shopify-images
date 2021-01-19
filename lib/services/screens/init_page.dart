import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopify_image/services/auth_services/authentification/email_login.dart';
import 'package:shopify_image/services/auth_services/authentification/email_signup.dart';
import 'package:shopify_image/services/shared%20widgets/shopify_logo.dart';

class init_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PNetworkImage(
                'https://cdn.shopify.com/assets/images/logos/shopify-bag.png'),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                RaisedButton(
                  color: HexColor("#95BF46"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmailLogIn()));
                  },
                  child: Text('LogIn'),
                ),
                RaisedButton(
                  color: HexColor("#95BF46"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()));
                  },
                  child: Text('SignUp'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
