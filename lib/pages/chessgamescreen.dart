import 'dart:async';
import 'package:chess_clock/widgets/hovericonbutton.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../classes/gametime.dart';

// ignore: must_be_immutable
class ChessGameScreen extends StatefulWidget {
  GameTime deneme;
  ChessGameScreen(this.deneme, {super.key});
  @override
  State<ChessGameScreen> createState() => _ChessGameScreen();
}

class _ChessGameScreen extends State<ChessGameScreen> {
  bool isDropMinOptionSelected = false;
  bool isDropIncOptionSelected = false;
  int move = 0;
  int remainingTimePlayer1 = 0;
  int remainingTimePlayer2 = 0;
  Timer? countdownTimer;
  bool turn = true;
  int currentPlayer = 0;
  bool isRestart = false;
  int? selectedIncrementTemp;
  int selectedIncrement = 0;
  int selectedTime = 10;
  List<int> incrementOptions = [0, 1, 3, 5, 10, 15];
  List<int> timeOptions = [1, 3, 5, 10, 15, 20, 30, 60, 90, 120];
  TextEditingController? player1Controller = TextEditingController();

  TextEditingController? player2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    remainingTimePlayer1 = widget.deneme.time;
    remainingTimePlayer2 = widget.deneme.time;
    player1Controller?.text = (widget.deneme.player1);
    player2Controller?.text = (widget.deneme.player2);
  }

  _restart() {
    countdownTimer?.cancel();

    selectedIncrement = 0;

    setState(() {
      remainingTimePlayer1 = 10;
      remainingTimePlayer2 = 10;
      currentPlayer = 0;
      isRestart = true;
      move = 0;
    });
  }

  _incrementPlayer1() {
    setState(() {
      remainingTimePlayer1 += selectedIncrement;
    });
  }

  _incrementPlayer1Score() {
    setState(() {
      widget.deneme.scorePlayer1++;
    });
  }

  _decrementPlayer1Score() {
    setState(() {
      if (widget.deneme.scorePlayer1 <= 0) {
        return;
      }
      widget.deneme.scorePlayer1--;
    });
  }

  _incrementPlayer2() {
    setState(() {
      remainingTimePlayer2 += selectedIncrement;
    });
  }

  _incrementPlayer2Score() {
    setState(() {
      widget.deneme.scorePlayer2++;
    });
  }

  _decrementPlayer2Score() {
    setState(() {
      if (widget.deneme.scorePlayer2 <= 0) {
        return;
      }
      widget.deneme.scorePlayer2--;
    });
  }

  void startCountdownTimer(int time, int player) {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (time > 0) {
          if (isRestart) {
            timer.cancel();
          }
          if (player == 1 && currentPlayer == 2) {
            time--;
            remainingTimePlayer2--;
          } else if (player == 2 && currentPlayer == 1) {
            time--;
            remainingTimePlayer1--;
          }
        } else {
          timer.cancel();
          // Süre bittiğinde yapılacak işlemleri buraya yazın// Zil sesini çal
          if (remainingTimePlayer1 == 0) {
            // Player 2 kazandı
            showWinnerDialog(widget.deneme.player2, widget.deneme.scorePlayer2);
          } else if (remainingTimePlayer2 == 0) {
            // Player 1 kazandı
            showWinnerDialog(widget.deneme.player1, widget.deneme.scorePlayer1);
          }
        }
      });
    });
  }

  void showWinnerDialog(String winner, int score) {
    playBellSound();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Winner'),
          content: Text('Congrats !, $winner won the game!'),
          actions: [
            TextButton(
              child: const Text('Okey'),
              onPressed: () {
                // Skorunuzu artırabilirsiniz.
                // Örneğin, kazananın skorunu 1 artırmak için:
                if (winner == widget.deneme.player1) {
                  setState(() {
                    widget.deneme.scorePlayer1++;
                  });
                } else if (winner == widget.deneme.player2) {
                  setState(() {
                    widget.deneme.scorePlayer2++;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String formatTime(int timeFormat) {
    int minutes = (timeFormat ~/ 60);
    int seconds = (timeFormat % 60);

    String formattedTime = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: RotatedBox(
              quarterTurns: 2,
              child: GestureDetector(
                onTap: () {
                  if (currentPlayer == 2) {
                    return;
                  }
                  setState(() {
                    currentPlayer = 2;
                    isRestart = false;
                  });
                  countdownTimer?.cancel();
                  startCountdownTimer(remainingTimePlayer2, 1);
                  if (move != 0) {
                    _incrementPlayer1();
                  }
                  move++;
                },
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formatTime(remainingTimePlayer1),
                        style: const TextStyle(
                            fontSize: 128, fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RotatedBox(
              quarterTurns: 2,
              child: Container(
                color: const Color.fromARGB(255, 217, 210, 210),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.deneme.player1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HoverIconButton(
                          icon: (Icons.add_circle_outline_rounded),
                          onPressed: () => _incrementPlayer1Score(),
                        ),
                        Text(
                          "${widget.deneme.scorePlayer1}",
                          style: const TextStyle(fontSize: 48),
                        ),
                        HoverIconButton(
                          icon: (Icons.remove_circle_outline_rounded),
                          onPressed: () => _decrementPlayer1Score(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          //AYARLAR
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                return;
              },
              child: Container(
                color: const Color.fromARGB(255, 125, 72, 51),
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text("AYARLAR"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HoverIconButton(
                          icon: (Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        HoverIconButton(
                          icon: Icons.restart_alt,
                          onPressed: () => _restart(),
                        ),
                        HoverIconButton(
                            icon: (Icons.settings),
                            onPressed: () {
                              isDropMinOptionSelected = false;
                              isDropIncOptionSelected = false;

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Settings',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16.0),
                                          TextField(
                                            controller: player1Controller,
                                            decoration: const InputDecoration(
                                              labelText: 'Player 1',
                                              hintText: 'Player 1 Name',
                                            ),
                                            autofillHints: [
                                              widget.deneme.player1
                                            ],
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.deneme.player1 = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 8.0),
                                          TextField(
                                            controller: player2Controller,
                                            decoration: const InputDecoration(
                                              labelText: 'Player 2',
                                              hintText: 'Player 2 Name',
                                            ),
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.deneme.player2 = value;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 8.0),
                                          DropdownButtonFormField<int>(
                                            value: selectedTime,
                                            decoration: const InputDecoration(
                                              labelText: 'Time (Min)',
                                            ),
                                            items: timeOptions.map((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text('$value'),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                isDropMinOptionSelected = true;
                                                if (newValue != null) {
                                                  countdownTimer?.cancel();
                                                  selectedTime = newValue;
                                                  remainingTimePlayer1 = 0;
                                                  remainingTimePlayer2 = 0;
                                                  remainingTimePlayer1 =
                                                      selectedTime * 60;
                                                  remainingTimePlayer2 =
                                                      selectedTime * 60;
                                                } else {
                                                  countdownTimer?.cancel();
                                                  remainingTimePlayer1 = 0;
                                                  remainingTimePlayer2 = 0;
                                                  remainingTimePlayer1 =
                                                      10 * 60;
                                                  remainingTimePlayer2 =
                                                      10 * 60;
                                                }
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 8.0),
                                          DropdownButtonFormField<int>(
                                            value: selectedIncrement,
                                            decoration: const InputDecoration(
                                              labelText: 'Add Seconds',
                                            ),
                                            items: incrementOptions
                                                .map((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text('$value'),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue) {
                                              setState(() {
                                                isDropIncOptionSelected = true;
                                                selectedIncrement = newValue!;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 16.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                child: const Text(
                                                  'Start',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (!isDropMinOptionSelected) {
                                                    setState(() {});
                                                    countdownTimer?.cancel();
                                                    remainingTimePlayer1 = 0;
                                                    remainingTimePlayer2 = 0;
                                                    remainingTimePlayer1 =
                                                        selectedTime * 60;
                                                    remainingTimePlayer2 =
                                                        selectedTime * 60;
                                                  }
                                                  if (!isDropIncOptionSelected) {
                                                    setState(() {
                                                      selectedIncrement = 0;
                                                    });
                                                  }
                                                  move = 0;
                                                  currentPlayer = 0;
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade800,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.deneme.player2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HoverIconButton(
                        icon: (Icons.add_circle_outline_rounded),
                        onPressed: () => _incrementPlayer2Score(),
                      ),
                      Text(
                        "${widget.deneme.scorePlayer2}",
                        style: const TextStyle(fontSize: 48),
                      ),
                      HoverIconButton(
                        icon: (Icons.remove_circle_outline_rounded),
                        onPressed: () => _decrementPlayer2Score(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                if (currentPlayer == 1) {
                  return;
                }
                setState(() {
                  if (countdownTimer != null) {
                    countdownTimer!.cancel();
                  }
                  currentPlayer = 1;
                  isRestart = false;
                });
                countdownTimer?.cancel();

                startCountdownTimer(remainingTimePlayer2, 2);
                if (move != 0) {
                  _incrementPlayer2();
                }
                move++;
              },
              child: Container(
                color: Colors.grey.shade900,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(remainingTimePlayer2),
                      style: const TextStyle(
                          fontSize: 128,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> playBellSound() async {
    final player = AudioPlayer();
    await player.setSourceAsset("sounds/dong.wav");
    player.play(AssetSource("sounds/dong.wav"));
  }
}
