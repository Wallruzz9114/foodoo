import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/components/shared/custom_button.dart';
import 'package:foodoo/src/components/shared/custom_text_field.dart';
import 'package:foodoo/src/models/user.dart';
import 'package:foodoo/src/state/auth/auth_cubit.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({
    Key? key,
    required this.controller,
    required this.authUpService,
  }) : super(key: key);

  final PageController controller;
  final IAuthService authUpService;

  @override
  _SignUpUIState createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  String _username = '';
  String _email = '';
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
            hint: 'Email',
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            onChanged: (String value) {
              _email = value;
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
            text: 'Sign Up',
            size: const Size(double.infinity, 54.0),
            onPressed: () {
              final User user = User(
                username: _username,
                email: _email,
                password: _password,
              );
              BlocProvider.of<AuthCubit>(context).signUp(
                widget.authUpService,
                user,
              );
            },
          ),
          const SizedBox(height: 60),
          RichText(
            text: TextSpan(
              text: 'Already have an account?',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
              children: <InlineSpan>[
                TextSpan(
                  text: ' Sign in',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      widget.controller.previousPage(
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
