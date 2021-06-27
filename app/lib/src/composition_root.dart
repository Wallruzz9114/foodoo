import 'package:auth/auth.dart';
import 'package:common/shared/apis/shared_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/cache/i_local_store.dart';
import 'package:foodoo/src/cache/local_store.dart';
import 'package:foodoo/src/screens/auth/auth_screen.dart';
import 'package:foodoo/src/screens/restaurant/restaurants_list_screen.dart';
import 'package:foodoo/src/state/auth/auth_cubit.dart';
import 'package:foodoo/src/state/helpers/custom_header_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';
import 'package:http/http.dart';
import 'package:restaurant/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompositionRoot {
  static late SharedPreferences _sharedPreferences;
  static late ILocalStore _localStore;
  static late String _baseURL;
  static late Client _client;
  static late SharedHttpClient _httpClient;

  static Future<void> configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStore = LocalStore(_sharedPreferences);
    _client = Client();
    _baseURL = 'http://localhost:3000';
    _httpClient = SharedHttpClient(_client);
  }

  static BlocProvider<AuthCubit> composeAuthUI() {
    final IAuthAPI _api = AuthenticationAPI(_baseURL, _client);
    final AuthManager _manager = AuthManager(_api);
    final AuthCubit _authCubit = AuthCubit(_localStore);
    final IAuthService _authService = AuthService(_api);

    return BlocProvider<AuthCubit>(
      create: (BuildContext context) => _authCubit,
      child: AuthScreen(authManager: _manager, authService: _authService),
    );
  }

  static Widget composeRestaurantsListUI() {
    final IRestaurantAPI _api =
        RestaurantAPI(client: _httpClient, baseUrl: _baseURL);
    final RestaurantCubit _restaurantCubit =
        RestaurantCubit(_api, defaultPageSize: 5);

    return MultiBlocProvider(
      providers: <BlocProvider<Cubit<dynamic>>>[
        BlocProvider<RestaurantCubit>(
          create: (BuildContext context) => _restaurantCubit,
        ),
        BlocProvider<CustomHeaderCubit>(
          create: (BuildContext context) => CustomHeaderCubit(),
        ),
      ],
      child: const RestaurantsListScreen(),
    );
  }
}
