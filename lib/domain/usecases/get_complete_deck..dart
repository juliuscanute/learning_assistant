import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/data/firebase_service.dart';
import 'package:learning_assistant/data/flash_card.dart';

class GetCompleteDeck implements UseCase<FlashCardDeck, String> {
  final FirebaseService firebaseService;

  GetCompleteDeck(this.firebaseService);

  @override
  Future<FlashCardDeck> call(String deckId) async {
    var deckData = await firebaseService.getDeckData(deckId);
    List<FlashCard> cards =
        List<FlashCard>.generate(deckData['cards'].length, (index) {
      var card = deckData['cards'][index];
      return FlashCard(
          index: index,
          front: card['front'],
          frontTex: card['front_tex'],
          back: card['back'],
          backTex: card['back_tex'],
          imageUrl: card['imageUrl'],
          mcqOptions: (card['mcq']?['options'] as List<dynamic>?)
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          mcqOptionsTex: (card['mcq']?['options_tex'] as List<dynamic>?)
                  ?.map<String>((e) => e.toString())
                  .toList() ??
              [],
          correctOptionIndex: card['mcq']?['answer_index'],
          explanation: card['explanation'],
          explanationTex: card['explanation_tex'],
          mnemonic: card['mnemonic']);
    });
    return FlashCardDeck(
      id: deckId,
      title: deckData['title'],
      tags: [],
      cards: cards,
      exactMatch: deckData['exactMatch'] ?? true,
    );
  }
}
