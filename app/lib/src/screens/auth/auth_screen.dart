import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/components/auth/auth_ui.dart';
import 'package:foodoo/src/components/auth/logo.dart';
import 'package:foodoo/src/state/auth/auth_cubit.dart';
import 'package:foodoo/src/state/auth/auth_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    Key? key,
    required this.authManager,
    required this.authService,
  }) : super(key: key);

  final AuthManager authManager;
  final IAuthService authService;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _controller = PageController();

  void _showLoader() {
    showDialog<AlertDialog>(
      context: context,
      builder: (_) => const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white70,
          ),
        ),
      ),
    );
  }

  void _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 110.0),
              child: Logo(imgPath: 'assets/logo.svg'),
            ),
            const SizedBox(height: 60.0),
            BlocConsumer<AuthCubit, AuthState>(
              builder: (_, AuthState state) {
                return AuthUI(
                  controller: _controller,
                  authUpService: widget.authService,
                  authManager: widget.authManager,
                );
              },
              listener: (BuildContext context, AuthState state) {
                if (state is AuthLoadingState) {
                  _showLoader();
                }
                if (state is AuthErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  );

                  _hideLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
