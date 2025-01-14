import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


class ThemeCubit extends Cubit<bool>{
  ThemeCubit(bool state) : super(true);

  void toggleTheme({required bool value }){
    emit(value);
  }
  @override
  bool? fromJson(Map<String, dynamic> json){
    return json['isDark'];
  }
  @override 
  Map<String, dynamic>? toJson(bool state){
    return {"isDark": state};
  }
}