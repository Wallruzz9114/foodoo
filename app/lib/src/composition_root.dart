import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/fake_restaurant_api.dart';
import 'package:foodoo/src/cache/i_local_store.dart';
import 'package:foodoo/src/cache/local_store.dart';
import 'package:foodoo/src/screens/auth/auth_screen.dart';
import 'package:foodoo/src/screens/home/home_screen.dart';
import 'package:foodoo/src/screens/home/home_screen_adapter.dart';
import 'package:foodoo/src/screens/restaurant/restaurant_details_screen.dart';
import 'package:foodoo/src/screens/search/search_results_screen.dart';
import 'package:foodoo/src/screens/search/search_results_screen_adapter.dart';
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
  static late FakeRestaurantAPI _api;

  static Future<void> configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStore = LocalStore(_sharedPreferences);
    _client = Client();
    _baseURL = 'http://localhost:3000';
    _api = FakeRestaurantAPI(50);
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

  static MultiBlocProvider composeRestaurantsListUI() {
    final RestaurantCubit _restaurantCubit =
        RestaurantCubit(_api, defaultPageSize: 20);
    const IHomeScreenAdapter _homeScreenAdaptor = HomeScreenAdapter(
        onSearch: _composeSearchUI, onSelection: _composeDetailsUI);

    return MultiBlocProvider(
      providers: <BlocProvider<Cubit<dynamic>>>[
        BlocProvider<RestaurantCubit>(
          create: (BuildContext context) => _restaurantCubit,
        ),
        BlocProvider<CustomHeaderCubit>(
          create: (BuildContext context) => CustomHeaderCubit(),
        ),
      ],
      child: const HomeScreen(adapter: _homeScreenAdaptor),
    );
  }

  static Widget _composeSearchUI(String query) {
    final RestaurantCubit restaurantCubit =
        RestaurantCubit(_api, defaultPageSize: 10);
    const ISearchResultsScreenAdapter searchResultsScreenAdapter =
        SearchResultsScreenAdapter(onSelection: _composeDetailsUI);

    return SearchResultsScreen(
      restaurantCubit: restaurantCubit,
      query: query,
      adapter: searchResultsScreenAdapter,
    );
  }

  static Widget _composeDetailsUI(Restaurant restaurant) {
    final RestaurantCubit restaurantCubit =
        RestaurantCubit(_api, defaultPageSize: 10);

    return RestaurantDetailsScreen(
      restaurant: restaurant,
      restaurantCubit: restaurantCubit,
    );
  }
}
