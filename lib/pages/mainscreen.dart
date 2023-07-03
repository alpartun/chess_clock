import 'package:flutter/material.dart';
import '../classes/gametime.dart';
import 'chessgamescreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String img = "assets/images/chess_board.jpg";
  static const String title = "Chess Clock";
  static const double fontSize = 26;
  static const String buttonTitle = "Let's Start";
  GameTime? gameTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage(img), fit: BoxFit.fitHeight)),
        child: Center(
          child: GestureDetector(
            onTap: () {
              gameTime = GameTime.Default(10 * 60, 0);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChessGameScreen(gameTime!),
                  ));
            },
            child: Container(
              height: 75,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black,
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonTitle,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
