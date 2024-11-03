class FlashCardDeck {
  final String id;
  final String title;
  final List<String> tags;
  final List<FlashCard> cards;
  final bool exactMatch;

  FlashCardDeck(
      {required this.id,
      required this.title,
      required this.tags,
      required this.cards,
      this.exactMatch = true});
}

class FlashCard {
  final int index;
  final String front;
  final String? frontTex;
  final String back;
  final String? backTex;
  final String? imageUrl;
  final List<String>? mcqOptions;
  final List<String>? mcqOptionsTex;
  final int? correctOptionIndex;
  final String? explanation;
  final String? explanationTex;
  final String? mnemonic;

  FlashCard(
      {required this.index,
      required this.front,
      required this.frontTex,
      required this.back,
      required this.backTex,
      required this.imageUrl,
      required this.mcqOptions,
      required this.mcqOptionsTex,
      required this.correctOptionIndex,
      required this.explanation,
      required this.explanationTex,
      required this.mnemonic});

  static FlashCard createEmptyFlashCard() {
    return FlashCard(
        index: -1,
        front: '',
        frontTex: null,
        back: '',
        backTex: null,
        imageUrl: null,
        mcqOptions: [],
        mcqOptionsTex: null,
        correctOptionIndex: null,
        explanation: null,
        explanationTex: null,
        mnemonic: null);
  }
}
