import 'package:learning_assistant/domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    required DateTime date,
    required List<DescriptionModel> descriptions,
  }) : super(date: date, descriptions: descriptions);

  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      date: entity.date,
      descriptions: entity.descriptions
          .map((desc) => DescriptionModel.fromEntity(desc))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'descriptions': descriptions
          .map((desc) => (desc as DescriptionModel).toJson())
          .toList(),
    };
  }
}

class DescriptionModel extends DescriptionEntity {
  DescriptionModel({
    required String description,
    required bool isReviewed,
  }) : super(description: description, isReviewed: isReviewed);

  factory DescriptionModel.fromEntity(DescriptionEntity entity) {
    return DescriptionModel(
      description: entity.description,
      isReviewed: entity.isReviewed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isReviewed': isReviewed,
    };
  }
}
