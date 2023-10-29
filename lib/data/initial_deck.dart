import 'package:learning_assistant/data/card_repository.dart';
import 'package:learning_assistant/data/cards.dart';
import 'package:learning_assistant/di/service_locator.dart';

class LoadDeck {
  final eventRepository = ServiceLocator.instance.get<CardsRepository>();
  void initialise() {
    createDeck1();
    createDeck2();
    createDeck3();
  }

  void createDeck1() {
    eventRepository.addDeck("Memorize 10 Shopping items", [
      addCard(0, "Mango"),
      addCard(1, "Geometry box"),
      addCard(2, "Razor"),
      addCard(3, "Stapler pin"),
      addCard(4, "Lipstick"),
      addCard(5, "Cofee powder"),
      addCard(6, "Soap"),
      addCard(7, "Jasmine flower"),
      addCard(8, "Cabbage"),
      addCard(9, "Tennis ball"),
    ]);
  }

  void createDeck2() {
    eventRepository.addDeck("13 Essential Vitamins & Their Names", [
      addCard(0, "A Retinol"),
      addCard(1, "C Ascorbic acid"),
      addCard(2, "D Calciferol"),
      addCard(3, "E Tocopherol"),
      addCard(4, "K Phylloquinone"),
      addCard(5, "B1 Thaiamine"),
      addCard(6, "B2 Riboflavin"),
      addCard(7, "B3 Niacin"),
      addCard(8, "B5 Pantothenic acid"),
      addCard(9, "B6 Pyrofoxine"),
      addCard(10, "B7 Biotin"),
      addCard(11, "B9 Folic acid"),
      addCard(12, "B12 Cyanocobalamin"),
    ]);
  }

  void createDeck3() {
    eventRepository.addDeck("Alphabets - Eatables", [
      addCard(0, "A Apple"),
      addCard(1, "B Banana"),
      addCard(2, "C Chocolates"),
      addCard(3, "D Dates"),
      addCard(4, "E Egg"),
      addCard(5, "F Fish"),
      addCard(6, "G Grapes"),
      addCard(7, "H Ham burger"),
      addCard(8, "I Ice-cream"),
      addCard(9, "J Jack fruit"),
      addCard(10, "K Ketchup"),
      addCard(11, "L Laddu"),
      addCard(12, "M Mango"),
      addCard(13, "N Noodles"),
      addCard(14, "O Orange"),
      addCard(15, "P Pizza"),
      addCard(16, "Q Quinoa"),
      addCard(17, "R Radish"),
      addCard(18, "S Sugar"),
      addCard(19, "T Toast"),
      addCard(20, "U Uppuma"),
      addCard(21, "V Vadai"),
      addCard(22, "W Watermelon"),
      addCard(23, "X Xmas cake"),
      addCard(24, "Y Yogurt"),
      addCard(25, "Z Ziti"),
    ]);
  }

  CardEmbedded addCard(int index, String front) {
    return CardEmbedded()
      ..index = index
      ..front = front
      ..back = "";
  }
}
