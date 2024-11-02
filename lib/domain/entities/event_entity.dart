class EventEntity {
  final DateTime date;
  final List<DescriptionEntity> descriptions;

  EventEntity({
    required this.date,
    required this.descriptions,
  });
}

class DescriptionEntity {
  final String description;
  final bool isReviewed;

  DescriptionEntity({
    required this.description,
    required this.isReviewed,
  });
}

class EventGroupEntity {
  final int id;
  final List<EventEntity> events;

  EventGroupEntity({
    required this.id,
    required this.events,
  });
}
