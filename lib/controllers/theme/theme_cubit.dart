import 'package:boxch/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({state}) : super(ThemeState.init(Hive.box(mainBox).get(boxThemeKey) ?? false));

  Future<void> changeTheme() async {
    var box = Hive.box(mainBox);
    box.put(boxThemeKey, !state.ligthTheme);
    emit(ThemeState(icon: !state.icon, ligthTheme: !state.ligthTheme));
  }
}
