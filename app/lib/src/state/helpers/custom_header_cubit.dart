import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/models/custom_header.dart';

class CustomHeaderCubit extends Cubit<CustomHeader> {
  CustomHeaderCubit() : super(CustomHeader(title: '', imageUrl: ''));

  void update(String title, String imageUrl) =>
      emit(CustomHeader(title: title, imageUrl: imageUrl));
}
