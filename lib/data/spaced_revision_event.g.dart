// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaced_revision_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpacedRevisionEventGroupCollection on Isar {
  IsarCollection<SpacedRevisionEventGroup> get spacedRevisionEventGroups =>
      this.collection();
}

const SpacedRevisionEventGroupSchema = CollectionSchema(
  name: r'SpacedRevisionEventGroup',
  id: 1863230920878908013,
  properties: {
    r'deckId': PropertySchema(
      id: 0,
      name: r'deckId',
      type: IsarType.string,
    ),
    r'deckTitle': PropertySchema(
      id: 1,
      name: r'deckTitle',
      type: IsarType.string,
    ),
    r'revisions': PropertySchema(
      id: 2,
      name: r'revisions',
      type: IsarType.objectList,
      target: r'SpacedRevisionEvent',
    )
  },
  estimateSize: _spacedRevisionEventGroupEstimateSize,
  serialize: _spacedRevisionEventGroupSerialize,
  deserialize: _spacedRevisionEventGroupDeserialize,
  deserializeProp: _spacedRevisionEventGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'SpacedRevisionEvent': SpacedRevisionEventSchema},
  getId: _spacedRevisionEventGroupGetId,
  getLinks: _spacedRevisionEventGroupGetLinks,
  attach: _spacedRevisionEventGroupAttach,
  version: '3.1.0+1',
);

int _spacedRevisionEventGroupEstimateSize(
  SpacedRevisionEventGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deckId.length * 3;
  bytesCount += 3 + object.deckTitle.length * 3;
  bytesCount += 3 + object.revisions.length * 3;
  {
    final offsets = allOffsets[SpacedRevisionEvent]!;
    for (var i = 0; i < object.revisions.length; i++) {
      final value = object.revisions[i];
      bytesCount +=
          SpacedRevisionEventSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _spacedRevisionEventGroupSerialize(
  SpacedRevisionEventGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.deckId);
  writer.writeString(offsets[1], object.deckTitle);
  writer.writeObjectList<SpacedRevisionEvent>(
    offsets[2],
    allOffsets,
    SpacedRevisionEventSchema.serialize,
    object.revisions,
  );
}

SpacedRevisionEventGroup _spacedRevisionEventGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpacedRevisionEventGroup(
    reader.readString(offsets[0]),
    reader.readString(offsets[1]),
    reader.readObjectList<SpacedRevisionEvent>(
          offsets[2],
          SpacedRevisionEventSchema.deserialize,
          allOffsets,
          SpacedRevisionEvent(),
        ) ??
        [],
  );
  object.id = id;
  return object;
}

P _spacedRevisionEventGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<SpacedRevisionEvent>(
            offset,
            SpacedRevisionEventSchema.deserialize,
            allOffsets,
            SpacedRevisionEvent(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _spacedRevisionEventGroupGetId(SpacedRevisionEventGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _spacedRevisionEventGroupGetLinks(
    SpacedRevisionEventGroup object) {
  return [];
}

void _spacedRevisionEventGroupAttach(
    IsarCollection<dynamic> col, Id id, SpacedRevisionEventGroup object) {
  object.id = id;
}

extension SpacedRevisionEventGroupQueryWhereSort on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QWhere> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SpacedRevisionEventGroupQueryWhere on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QWhereClause> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SpacedRevisionEventGroupQueryFilter on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QFilterCondition> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deckId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
          QAfterFilterCondition>
      deckIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deckId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
          QAfterFilterCondition>
      deckIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deckId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deckId',
        value: '',
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deckId',
        value: '',
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deckTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
          QAfterFilterCondition>
      deckTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deckTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
          QAfterFilterCondition>
      deckTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deckTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deckTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> deckTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deckTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
      QAfterFilterCondition> revisionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'revisions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SpacedRevisionEventGroupQueryObject on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QFilterCondition> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup,
          QAfterFilterCondition>
      revisionsElement(FilterQuery<SpacedRevisionEvent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'revisions');
    });
  }
}

extension SpacedRevisionEventGroupQueryLinks on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QFilterCondition> {}

extension SpacedRevisionEventGroupQuerySortBy on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QSortBy> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      sortByDeckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.asc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      sortByDeckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.desc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      sortByDeckTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckTitle', Sort.asc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      sortByDeckTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckTitle', Sort.desc);
    });
  }
}

extension SpacedRevisionEventGroupQuerySortThenBy on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QSortThenBy> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenByDeckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.asc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenByDeckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.desc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenByDeckTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckTitle', Sort.asc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenByDeckTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckTitle', Sort.desc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension SpacedRevisionEventGroupQueryWhereDistinct on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QDistinct> {
  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QDistinct>
      distinctByDeckId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deckId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, SpacedRevisionEventGroup, QDistinct>
      distinctByDeckTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deckTitle', caseSensitive: caseSensitive);
    });
  }
}

extension SpacedRevisionEventGroupQueryProperty on QueryBuilder<
    SpacedRevisionEventGroup, SpacedRevisionEventGroup, QQueryProperty> {
  QueryBuilder<SpacedRevisionEventGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, String, QQueryOperations>
      deckIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deckId');
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, String, QQueryOperations>
      deckTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deckTitle');
    });
  }

  QueryBuilder<SpacedRevisionEventGroup, List<SpacedRevisionEvent>,
      QQueryOperations> revisionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revisions');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SpacedRevisionEventSchema = Schema(
  name: r'SpacedRevisionEvent',
  id: 5570983316544894982,
  properties: {
    r'dateRevised': PropertySchema(
      id: 0,
      name: r'dateRevised',
      type: IsarType.dateTime,
    ),
    r'revisionDate': PropertySchema(
      id: 1,
      name: r'revisionDate',
      type: IsarType.dateTime,
    ),
    r'scoreAcquired': PropertySchema(
      id: 2,
      name: r'scoreAcquired',
      type: IsarType.long,
    ),
    r'totalScore': PropertySchema(
      id: 3,
      name: r'totalScore',
      type: IsarType.long,
    )
  },
  estimateSize: _spacedRevisionEventEstimateSize,
  serialize: _spacedRevisionEventSerialize,
  deserialize: _spacedRevisionEventDeserialize,
  deserializeProp: _spacedRevisionEventDeserializeProp,
);

int _spacedRevisionEventEstimateSize(
  SpacedRevisionEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _spacedRevisionEventSerialize(
  SpacedRevisionEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateRevised);
  writer.writeDateTime(offsets[1], object.revisionDate);
  writer.writeLong(offsets[2], object.scoreAcquired);
  writer.writeLong(offsets[3], object.totalScore);
}

SpacedRevisionEvent _spacedRevisionEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpacedRevisionEvent();
  object.dateRevised = reader.readDateTime(offsets[0]);
  object.revisionDate = reader.readDateTime(offsets[1]);
  object.scoreAcquired = reader.readLong(offsets[2]);
  object.totalScore = reader.readLong(offsets[3]);
  return object;
}

P _spacedRevisionEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SpacedRevisionEventQueryFilter on QueryBuilder<SpacedRevisionEvent,
    SpacedRevisionEvent, QFilterCondition> {
  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      dateRevisedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateRevised',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      dateRevisedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateRevised',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      dateRevisedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateRevised',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      dateRevisedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateRevised',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      revisionDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revisionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      revisionDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revisionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      revisionDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revisionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      revisionDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revisionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      scoreAcquiredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scoreAcquired',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      scoreAcquiredGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scoreAcquired',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      scoreAcquiredLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scoreAcquired',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      scoreAcquiredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scoreAcquired',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      totalScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScore',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      totalScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalScore',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      totalScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalScore',
        value: value,
      ));
    });
  }

  QueryBuilder<SpacedRevisionEvent, SpacedRevisionEvent, QAfterFilterCondition>
      totalScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SpacedRevisionEventQueryObject on QueryBuilder<SpacedRevisionEvent,
    SpacedRevisionEvent, QFilterCondition> {}
