import 'package:flutter/material.dart';
import 'dart:async';

class CardModel {
  final String imageAssetPath;
  bool isFaceUp;
  bool isMatched;

  CardModel({
    required this.imageAssetPath,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}

void main() {
  runApp(CardMatchingGame());
}

class CardMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CardMatchingScreen(),
    );
  }
}

class CardMatchingScreen extends StatefulWidget {
  @override 
  _CardMatchingScreenState createState() => _CardMatchingScreenState();
}

class _CardMatchingScreenState extends State<CardMatchingScreen> {
  List<CardModel> cards = [];
  CardModel? firstSelectedCard;
  CardModel? secondSelectedCard;
  bool isCheckingMatch = false;

  @override 
  void initState() {
    super.initState();
    _intializeCards();
  }
  void _intializeCards() {
    List<String> images = [
      'assets/images/Angel.png',
      'assets/images/Crying.png',
      'assets/images/Goofy.png',
      'assets/images/Love.png',
      'assets/images/Quiet.png',
      'assets/images/Sad.png',
      'assets/images/Smiley.png',
      'assets/images/Thinking.png',
    ];

    //This duplicates the images to create pairs
    cards = images
      .map((image) => CardModel(imageAssetPath: image))
      .toList();
    cards.addAll(images.map((image) => CardModel(imageAssetPath: image)).toList());
    
    //This shuffles the cards
    cards.shuffle();
  }

  //This handles the card tap
  void _onCardTap(CardModel card) {
    if (isCheckingMatch || card.isFaceUp || card.isMatched) {
      return;
    }
    setState(() {
      card.isFaceUp = true;

      if (firstSelectedCard == null) {
        firstSelectedCard = card;
      } else {
        secondSelectedCard = card;
        _checkMatch();
      }
    });
  }
  // This checks if the two selected cards match
  void _checkMatch() {
    if (firstSelectedCard != null && secondSelectedCard != null) {
      isCheckingMatch = true;

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (firstSelectedCard!.imageAssetPath == secondSelectedCard!.imageAssetPath) {
          //This marks them as matched if the cards match.
          firstSelectedCard!.isMatched = true;
          secondSelectedCard!.isMatched = true;
        } else {
          //This flips them back if they don't match.
          firstSelectedCard!.isFaceUp = false;
          secondSelectedCard!.isFaceUp = false;
        }
        firstSelectedCard = null;
        secondSelectedCard = null;
        isCheckingMatch = false;
      });
    });
    }
  }
  void _resetGame() {
    setState(() {
      firstSelectedCard = null;
      secondSelectedCard = null;
      isCheckingMatch = false;
      _intializeCards();
    });
  }
  bool _areAllCardsMatched() {
    return cards.every((card) => card.isMatched);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: Stack(
        children: [
          // Grid of cards
          GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, 
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return _buildCard(cards[index]);
            },
          ),
          // Show reset button when all cards are matched
          if (_areAllCardsMatched())
            Center(
              child: ElevatedButton(
                onPressed: _resetGame, // Call reset function
                child: Text('Reset Game'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(CardModel card) {
    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(card.isFaceUp || card.isMatched
              ? card.imageAssetPath
              : 'assets/images/BackImage.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
