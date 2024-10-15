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

