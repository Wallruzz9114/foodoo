import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:foodoo/src/components/auth/sign_in_ui.dart';
import 'package:foodoo/src/components/auth/sign_up_ui.dart';

class AuthUI extends StatelessWidget {
  const AuthUI(
      {Key? key,
      required this.controller,
      required this.authUpService,
      required this.authManager})
      : super(key: key);

  final PageController controller;
  final IAuthService authUpService;
  final AuthManager authManager;

  @override
  Expanded build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          SignInUI(
            controller: controller,
            authUpService: authUpService,
            authManager: authManager,
          ),
          SignUpUI(controller: controller, authUpService: authUpService),
        ],
      ),
    );
  }
}
