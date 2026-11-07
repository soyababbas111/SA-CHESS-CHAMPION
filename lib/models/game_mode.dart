enum GameMode {
  classic('Classic Chess (10 Min)'),
  quick('Quick Chess (5 Min)'),
  computer('vs Computer');

  const GameMode(this.title);
  final String title;
}