// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetResultGroupCollection on Isar {
  IsarCollection<ResultGroup> get resultGroups => this.collection();
}

const ResultGroupSchema = CollectionSchema(
  name: r'ResultGroup',
  id: -408691540227752003,
  properties: {
    r'correct': PropertySchema(
      id: 0,
      name: r'correct',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'missed': PropertySchema(
      id: 2,
      name: r'missed',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    ),
    r'wrong': PropertySchema(
      id: 4,
      name: r'wrong',
      type: IsarType.long,
    )
  },
  estimateSize: _resultGroupEstimateSize,
  serialize: _resultGroupSerialize,
  deserialize: _resultGroupDeserialize,
  deserializeProp: _resultGroupDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _resultGroupGetId,
  getLinks: _resultGroupGetLinks,
  attach: _resultGroupAttach,
  version: '3.1.0+1',
);

int _resultGroupEstimateSize(
  ResultGroup object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _resultGroupSerialize(
  ResultGroup object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.correct);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.missed);
  writer.writeString(offsets[3], object.title);
  writer.writeLong(offsets[4], object.wrong);
}

ResultGroup _resultGroupDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResultGroup(
    reader.readString(offsets[3]),
    reader.readLong(offsets[0]),
    reader.readLong(offsets[4]),
    reader.readLong(offsets[2]),
    reader.readDateTime(offsets[1]),
  );
  object.id = id;
  return object;
}

P _resultGroupDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _resultGroupGetId(ResultGroup object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _resultGroupGetLinks(ResultGroup object) {
  return [];
}

void _resultGroupAttach(
    IsarCollection<dynamic> col, Id id, ResultGroup object) {
  object.id = id;
}

extension ResultGroupQueryWhereSort
    on QueryBuilder<ResultGroup, ResultGroup, QWhere> {
  QueryBuilder<ResultGroup, ResultGroup, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ResultGroupQueryWhere
    on QueryBuilder<ResultGroup, ResultGroup, QWhereClause> {
  QueryBuilder<ResultGroup, ResultGroup, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ResultGroup, ResultGroup, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterWhereClause> idBetween(
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

extension ResultGroupQueryFilter
    on QueryBuilder<ResultGroup, ResultGroup, QFilterCondition> {
  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> correctEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correct',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition>
      correctGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correct',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> correctLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correct',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> correctBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correct',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> missedEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missed',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition>
      missedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missed',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> missedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missed',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> missedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> wrongEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrong',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition>
      wrongGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrong',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> wrongLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrong',
        value: value,
      ));
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterFilterCondition> wrongBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrong',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ResultGroupQueryObject
    on QueryBuilder<ResultGroup, ResultGroup, QFilterCondition> {}

extension ResultGroupQueryLinks
    on QueryBuilder<ResultGroup, ResultGroup, QFilterCondition> {}

extension ResultGroupQuerySortBy
    on QueryBuilder<ResultGroup, ResultGroup, QSortBy> {
  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByMissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missed', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByMissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missed', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> sortByWrongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.desc);
    });
  }
}

extension ResultGroupQuerySortThenBy
    on QueryBuilder<ResultGroup, ResultGroup, QSortThenBy> {
  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correct', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByMissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missed', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByMissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missed', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.asc);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QAfterSortBy> thenByWrongDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrong', Sort.desc);
    });
  }
}

extension ResultGroupQueryWhereDistinct
    on QueryBuilder<ResultGroup, ResultGroup, QDistinct> {
  QueryBuilder<ResultGroup, ResultGroup, QDistinct> distinctByCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correct');
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QDistinct> distinctByMissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missed');
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResultGroup, ResultGroup, QDistinct> distinctByWrong() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrong');
    });
  }
}

extension ResultGroupQueryProperty
    on QueryBuilder<ResultGroup, ResultGroup, QQueryProperty> {
  QueryBuilder<ResultGroup, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ResultGroup, int, QQueryOperations> correctProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correct');
    });
  }

  QueryBuilder<ResultGroup, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ResultGroup, int, QQueryOperations> missedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missed');
    });
  }

  QueryBuilder<ResultGroup, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<ResultGroup, int, QQueryOperations> wrongProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrong');
    });
  }
}
