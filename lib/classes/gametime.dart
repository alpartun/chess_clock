class GameTime {
  int time = 0;
  int increment = 0;

  String player1 = "Player 1";
  String player2 = "Player 2";
  int scorePlayer1 = 0;
  int scorePlayer2 = 0;

  GameTime(
    this.time,
    this.increment,
    this.player1,
    this.player2,
    this.scorePlayer1,
    this.scorePlayer2,
  );
  GameTime.Default(this.time, this.increment);
}
