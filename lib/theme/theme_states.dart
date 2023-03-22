class ThemeState {
  final icon;
  final ligthTheme;

  ThemeState({this.icon, this.ligthTheme});

  factory ThemeState.init(bool isTheme) =>
      ThemeState(icon: isTheme, ligthTheme: isTheme);
}
