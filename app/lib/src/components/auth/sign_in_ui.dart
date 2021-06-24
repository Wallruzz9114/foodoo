import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/components/shared/custom_button.dart';
import 'package:foodoo/src/components/shared/custom_text_field.dart';
import 'package:foodoo/src/state/auth/auth_cubit.dart';

class SignInUI extends StatefulWidget {
  const SignInUI({
    Key? key,
    required this.controller,
    required this.authUpService,
    required this.authManager,
  }) : super(key: key);

  final PageController controller;
  final IAuthService authUpService;
  final AuthManager authManager;

  @override
  _SignInUIState createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {
  String _username = '';
  String _password = '';

  @override
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          CustomTextField(
            hint: 'Username',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            onChanged: (String value) {
              _username = value;
            },
          ),
          const SizedBox(height: 30.0),
          CustomTextField(
            hint: 'Password',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            onChanged: (String value) {
              _password = value;
            },
          ),
          const SizedBox(height: 30.0),
          CustomButton(
            text: 'Sign In',
            size: const Size(double.infinity, 54.0),
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).signIn(
                widget.authManager.signInManager(
                  username: _username,
                  password: _password,
                ),
              );
            },
          ),
          const SizedBox(height: 60),
          RichText(
            text: TextSpan(
              text: "Don't have an account?",
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
              children: <InlineSpan>[
                TextSpan(
                  text: ' Sign up',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.controller.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                      );
                    },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
