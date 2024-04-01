import 'package:string_similarity/string_similarity.dart';

extension StringExtension on String {
  String removeSpecialSymbols() {
    // This regular expression removes anything that's not a letter, number, or space
    return replaceAll(RegExp('[^A-Za-z0-9 ]'), '');
  }

  bool isSimilar(String other, bool exacctMatch) {
    if (exacctMatch) {
      return this == other;
    }
    final thisString = removeSpecialSymbols().toLowerCase();
    final otherString = other.removeSpecialSymbols().toLowerCase();
    double similarityScore =
        StringSimilarity.compareTwoStrings(thisString, otherString);
    return similarityScore > 0.75;
  }
}
