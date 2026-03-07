// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InterviewSessionsTable extends InterviewSessions
    with TableInfo<$InterviewSessionsTable, InterviewSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterviewSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTypeMeta = const VerificationMeta(
    'questionType',
  );
  @override
  late final GeneratedColumn<String> questionType = GeneratedColumn<String>(
    'question_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _questionCountMeta = const VerificationMeta(
    'questionCount',
  );
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
    'question_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timePerQuestionMeta = const VerificationMeta(
    'timePerQuestion',
  );
  @override
  late final GeneratedColumn<int> timePerQuestion = GeneratedColumn<int>(
    'time_per_question',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<double> totalScore = GeneratedColumn<double>(
    'total_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overallFeedbackMeta = const VerificationMeta(
    'overallFeedback',
  );
  @override
  late final GeneratedColumn<String> overallFeedback = GeneratedColumn<String>(
    'overall_feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthsMeta = const VerificationMeta(
    'strengths',
  );
  @override
  late final GeneratedColumn<String> strengths = GeneratedColumn<String>(
    'strengths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weaknessesMeta = const VerificationMeta(
    'weaknesses',
  );
  @override
  late final GeneratedColumn<String> weaknesses = GeneratedColumn<String>(
    'weaknesses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    position,
    company,
    level,
    questionType,
    language,
    questionCount,
    timePerQuestion,
    totalScore,
    overallFeedback,
    strengths,
    weaknesses,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interview_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InterviewSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('question_type')) {
      context.handle(
        _questionTypeMeta,
        questionType.isAcceptableOrUnknown(
          data['question_type']!,
          _questionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTypeMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('question_count')) {
      context.handle(
        _questionCountMeta,
        questionCount.isAcceptableOrUnknown(
          data['question_count']!,
          _questionCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCountMeta);
    }
    if (data.containsKey('time_per_question')) {
      context.handle(
        _timePerQuestionMeta,
        timePerQuestion.isAcceptableOrUnknown(
          data['time_per_question']!,
          _timePerQuestionMeta,
        ),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('overall_feedback')) {
      context.handle(
        _overallFeedbackMeta,
        overallFeedback.isAcceptableOrUnknown(
          data['overall_feedback']!,
          _overallFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('strengths')) {
      context.handle(
        _strengthsMeta,
        strengths.isAcceptableOrUnknown(data['strengths']!, _strengthsMeta),
      );
    }
    if (data.containsKey('weaknesses')) {
      context.handle(
        _weaknessesMeta,
        weaknesses.isAcceptableOrUnknown(data['weaknesses']!, _weaknessesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterviewSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterviewSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      questionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_type'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      questionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_count'],
      )!,
      timePerQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_per_question'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_score'],
      ),
      overallFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overall_feedback'],
      ),
      strengths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strengths'],
      ),
      weaknesses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weaknesses'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InterviewSessionsTable createAlias(String alias) {
    return $InterviewSessionsTable(attachedDatabase, alias);
  }
}

class InterviewSession extends DataClass
    implements Insertable<InterviewSession> {
  final String id;
  final String position;
  final String company;
  final String level;
  final String questionType;
  final String language;
  final int questionCount;
  final int timePerQuestion;
  final double? totalScore;
  final String? overallFeedback;
  final String? strengths;
  final String? weaknesses;
  final DateTime createdAt;
  const InterviewSession({
    required this.id,
    required this.position,
    required this.company,
    required this.level,
    required this.questionType,
    required this.language,
    required this.questionCount,
    required this.timePerQuestion,
    this.totalScore,
    this.overallFeedback,
    this.strengths,
    this.weaknesses,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position'] = Variable<String>(position);
    map['company'] = Variable<String>(company);
    map['level'] = Variable<String>(level);
    map['question_type'] = Variable<String>(questionType);
    map['language'] = Variable<String>(language);
    map['question_count'] = Variable<int>(questionCount);
    map['time_per_question'] = Variable<int>(timePerQuestion);
    if (!nullToAbsent || totalScore != null) {
      map['total_score'] = Variable<double>(totalScore);
    }
    if (!nullToAbsent || overallFeedback != null) {
      map['overall_feedback'] = Variable<String>(overallFeedback);
    }
    if (!nullToAbsent || strengths != null) {
      map['strengths'] = Variable<String>(strengths);
    }
    if (!nullToAbsent || weaknesses != null) {
      map['weaknesses'] = Variable<String>(weaknesses);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InterviewSessionsCompanion toCompanion(bool nullToAbsent) {
    return InterviewSessionsCompanion(
      id: Value(id),
      position: Value(position),
      company: Value(company),
      level: Value(level),
      questionType: Value(questionType),
      language: Value(language),
      questionCount: Value(questionCount),
      timePerQuestion: Value(timePerQuestion),
      totalScore: totalScore == null && nullToAbsent
          ? const Value.absent()
          : Value(totalScore),
      overallFeedback: overallFeedback == null && nullToAbsent
          ? const Value.absent()
          : Value(overallFeedback),
      strengths: strengths == null && nullToAbsent
          ? const Value.absent()
          : Value(strengths),
      weaknesses: weaknesses == null && nullToAbsent
          ? const Value.absent()
          : Value(weaknesses),
      createdAt: Value(createdAt),
    );
  }

  factory InterviewSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterviewSession(
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<String>(json['position']),
      company: serializer.fromJson<String>(json['company']),
      level: serializer.fromJson<String>(json['level']),
      questionType: serializer.fromJson<String>(json['questionType']),
      language: serializer.fromJson<String>(json['language']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
      timePerQuestion: serializer.fromJson<int>(json['timePerQuestion']),
      totalScore: serializer.fromJson<double?>(json['totalScore']),
      overallFeedback: serializer.fromJson<String?>(json['overallFeedback']),
      strengths: serializer.fromJson<String?>(json['strengths']),
      weaknesses: serializer.fromJson<String?>(json['weaknesses']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<String>(position),
      'company': serializer.toJson<String>(company),
      'level': serializer.toJson<String>(level),
      'questionType': serializer.toJson<String>(questionType),
      'language': serializer.toJson<String>(language),
      'questionCount': serializer.toJson<int>(questionCount),
      'timePerQuestion': serializer.toJson<int>(timePerQuestion),
      'totalScore': serializer.toJson<double?>(totalScore),
      'overallFeedback': serializer.toJson<String?>(overallFeedback),
      'strengths': serializer.toJson<String?>(strengths),
      'weaknesses': serializer.toJson<String?>(weaknesses),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InterviewSession copyWith({
    String? id,
    String? position,
    String? company,
    String? level,
    String? questionType,
    String? language,
    int? questionCount,
    int? timePerQuestion,
    Value<double?> totalScore = const Value.absent(),
    Value<String?> overallFeedback = const Value.absent(),
    Value<String?> strengths = const Value.absent(),
    Value<String?> weaknesses = const Value.absent(),
    DateTime? createdAt,
  }) => InterviewSession(
    id: id ?? this.id,
    position: position ?? this.position,
    company: company ?? this.company,
    level: level ?? this.level,
    questionType: questionType ?? this.questionType,
    language: language ?? this.language,
    questionCount: questionCount ?? this.questionCount,
    timePerQuestion: timePerQuestion ?? this.timePerQuestion,
    totalScore: totalScore.present ? totalScore.value : this.totalScore,
    overallFeedback: overallFeedback.present
        ? overallFeedback.value
        : this.overallFeedback,
    strengths: strengths.present ? strengths.value : this.strengths,
    weaknesses: weaknesses.present ? weaknesses.value : this.weaknesses,
    createdAt: createdAt ?? this.createdAt,
  );
  InterviewSession copyWithCompanion(InterviewSessionsCompanion data) {
    return InterviewSession(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      company: data.company.present ? data.company.value : this.company,
      level: data.level.present ? data.level.value : this.level,
      questionType: data.questionType.present
          ? data.questionType.value
          : this.questionType,
      language: data.language.present ? data.language.value : this.language,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      timePerQuestion: data.timePerQuestion.present
          ? data.timePerQuestion.value
          : this.timePerQuestion,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      overallFeedback: data.overallFeedback.present
          ? data.overallFeedback.value
          : this.overallFeedback,
      strengths: data.strengths.present ? data.strengths.value : this.strengths,
      weaknesses: data.weaknesses.present
          ? data.weaknesses.value
          : this.weaknesses,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterviewSession(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('company: $company, ')
          ..write('level: $level, ')
          ..write('questionType: $questionType, ')
          ..write('language: $language, ')
          ..write('questionCount: $questionCount, ')
          ..write('timePerQuestion: $timePerQuestion, ')
          ..write('totalScore: $totalScore, ')
          ..write('overallFeedback: $overallFeedback, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    position,
    company,
    level,
    questionType,
    language,
    questionCount,
    timePerQuestion,
    totalScore,
    overallFeedback,
    strengths,
    weaknesses,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterviewSession &&
          other.id == this.id &&
          other.position == this.position &&
          other.company == this.company &&
          other.level == this.level &&
          other.questionType == this.questionType &&
          other.language == this.language &&
          other.questionCount == this.questionCount &&
          other.timePerQuestion == this.timePerQuestion &&
          other.totalScore == this.totalScore &&
          other.overallFeedback == this.overallFeedback &&
          other.strengths == this.strengths &&
          other.weaknesses == this.weaknesses &&
          other.createdAt == this.createdAt);
}

class InterviewSessionsCompanion extends UpdateCompanion<InterviewSession> {
  final Value<String> id;
  final Value<String> position;
  final Value<String> company;
  final Value<String> level;
  final Value<String> questionType;
  final Value<String> language;
  final Value<int> questionCount;
  final Value<int> timePerQuestion;
  final Value<double?> totalScore;
  final Value<String?> overallFeedback;
  final Value<String?> strengths;
  final Value<String?> weaknesses;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const InterviewSessionsCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.company = const Value.absent(),
    this.level = const Value.absent(),
    this.questionType = const Value.absent(),
    this.language = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.timePerQuestion = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.overallFeedback = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InterviewSessionsCompanion.insert({
    required String id,
    required String position,
    required String company,
    required String level,
    required String questionType,
    this.language = const Value.absent(),
    required int questionCount,
    this.timePerQuestion = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.overallFeedback = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       position = Value(position),
       company = Value(company),
       level = Value(level),
       questionType = Value(questionType),
       questionCount = Value(questionCount);
  static Insertable<InterviewSession> custom({
    Expression<String>? id,
    Expression<String>? position,
    Expression<String>? company,
    Expression<String>? level,
    Expression<String>? questionType,
    Expression<String>? language,
    Expression<int>? questionCount,
    Expression<int>? timePerQuestion,
    Expression<double>? totalScore,
    Expression<String>? overallFeedback,
    Expression<String>? strengths,
    Expression<String>? weaknesses,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (company != null) 'company': company,
      if (level != null) 'level': level,
      if (questionType != null) 'question_type': questionType,
      if (language != null) 'language': language,
      if (questionCount != null) 'question_count': questionCount,
      if (timePerQuestion != null) 'time_per_question': timePerQuestion,
      if (totalScore != null) 'total_score': totalScore,
      if (overallFeedback != null) 'overall_feedback': overallFeedback,
      if (strengths != null) 'strengths': strengths,
      if (weaknesses != null) 'weaknesses': weaknesses,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InterviewSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? position,
    Value<String>? company,
    Value<String>? level,
    Value<String>? questionType,
    Value<String>? language,
    Value<int>? questionCount,
    Value<int>? timePerQuestion,
    Value<double?>? totalScore,
    Value<String?>? overallFeedback,
    Value<String?>? strengths,
    Value<String?>? weaknesses,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return InterviewSessionsCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      company: company ?? this.company,
      level: level ?? this.level,
      questionType: questionType ?? this.questionType,
      language: language ?? this.language,
      questionCount: questionCount ?? this.questionCount,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      totalScore: totalScore ?? this.totalScore,
      overallFeedback: overallFeedback ?? this.overallFeedback,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (questionType.present) {
      map['question_type'] = Variable<String>(questionType.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (timePerQuestion.present) {
      map['time_per_question'] = Variable<int>(timePerQuestion.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<double>(totalScore.value);
    }
    if (overallFeedback.present) {
      map['overall_feedback'] = Variable<String>(overallFeedback.value);
    }
    if (strengths.present) {
      map['strengths'] = Variable<String>(strengths.value);
    }
    if (weaknesses.present) {
      map['weaknesses'] = Variable<String>(weaknesses.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterviewSessionsCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('company: $company, ')
          ..write('level: $level, ')
          ..write('questionType: $questionType, ')
          ..write('language: $language, ')
          ..write('questionCount: $questionCount, ')
          ..write('timePerQuestion: $timePerQuestion, ')
          ..write('totalScore: $totalScore, ')
          ..write('overallFeedback: $overallFeedback, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InterviewQuestionsTable extends InterviewQuestions
    with TableInfo<$InterviewQuestionsTable, InterviewQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterviewQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interview_sessions (id)',
    ),
  );
  static const VerificationMeta _questionNumberMeta = const VerificationMeta(
    'questionNumber',
  );
  @override
  late final GeneratedColumn<int> questionNumber = GeneratedColumn<int>(
    'question_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerTextMeta = const VerificationMeta(
    'answerText',
  );
  @override
  late final GeneratedColumn<String> answerText = GeneratedColumn<String>(
    'answer_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feedbackMeta = const VerificationMeta(
    'feedback',
  );
  @override
  late final GeneratedColumn<String> feedback = GeneratedColumn<String>(
    'feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idealAnswerMeta = const VerificationMeta(
    'idealAnswer',
  );
  @override
  late final GeneratedColumn<String> idealAnswer = GeneratedColumn<String>(
    'ideal_answer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _starAnalysisMeta = const VerificationMeta(
    'starAnalysis',
  );
  @override
  late final GeneratedColumn<String> starAnalysis = GeneratedColumn<String>(
    'star_analysis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedKeywordsMeta = const VerificationMeta(
    'suggestedKeywords',
  );
  @override
  late final GeneratedColumn<String> suggestedKeywords =
      GeneratedColumn<String>(
        'suggested_keywords',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    questionNumber,
    questionText,
    category,
    answerText,
    score,
    feedback,
    idealAnswer,
    starAnalysis,
    suggestedKeywords,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interview_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<InterviewQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('question_number')) {
      context.handle(
        _questionNumberMeta,
        questionNumber.isAcceptableOrUnknown(
          data['question_number']!,
          _questionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionNumberMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('answer_text')) {
      context.handle(
        _answerTextMeta,
        answerText.isAcceptableOrUnknown(data['answer_text']!, _answerTextMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('feedback')) {
      context.handle(
        _feedbackMeta,
        feedback.isAcceptableOrUnknown(data['feedback']!, _feedbackMeta),
      );
    }
    if (data.containsKey('ideal_answer')) {
      context.handle(
        _idealAnswerMeta,
        idealAnswer.isAcceptableOrUnknown(
          data['ideal_answer']!,
          _idealAnswerMeta,
        ),
      );
    }
    if (data.containsKey('star_analysis')) {
      context.handle(
        _starAnalysisMeta,
        starAnalysis.isAcceptableOrUnknown(
          data['star_analysis']!,
          _starAnalysisMeta,
        ),
      );
    }
    if (data.containsKey('suggested_keywords')) {
      context.handle(
        _suggestedKeywordsMeta,
        suggestedKeywords.isAcceptableOrUnknown(
          data['suggested_keywords']!,
          _suggestedKeywordsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterviewQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterviewQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      questionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_number'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      answerText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_text'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      feedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feedback'],
      ),
      idealAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ideal_answer'],
      ),
      starAnalysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}star_analysis'],
      ),
      suggestedKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_keywords'],
      ),
    );
  }

  @override
  $InterviewQuestionsTable createAlias(String alias) {
    return $InterviewQuestionsTable(attachedDatabase, alias);
  }
}

class InterviewQuestion extends DataClass
    implements Insertable<InterviewQuestion> {
  final String id;
  final String sessionId;
  final int questionNumber;
  final String questionText;
  final String category;
  final String? answerText;
  final double? score;
  final String? feedback;
  final String? idealAnswer;
  final String? starAnalysis;
  final String? suggestedKeywords;
  const InterviewQuestion({
    required this.id,
    required this.sessionId,
    required this.questionNumber,
    required this.questionText,
    required this.category,
    this.answerText,
    this.score,
    this.feedback,
    this.idealAnswer,
    this.starAnalysis,
    this.suggestedKeywords,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['question_number'] = Variable<int>(questionNumber);
    map['question_text'] = Variable<String>(questionText);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || answerText != null) {
      map['answer_text'] = Variable<String>(answerText);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || feedback != null) {
      map['feedback'] = Variable<String>(feedback);
    }
    if (!nullToAbsent || idealAnswer != null) {
      map['ideal_answer'] = Variable<String>(idealAnswer);
    }
    if (!nullToAbsent || starAnalysis != null) {
      map['star_analysis'] = Variable<String>(starAnalysis);
    }
    if (!nullToAbsent || suggestedKeywords != null) {
      map['suggested_keywords'] = Variable<String>(suggestedKeywords);
    }
    return map;
  }

  InterviewQuestionsCompanion toCompanion(bool nullToAbsent) {
    return InterviewQuestionsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      questionNumber: Value(questionNumber),
      questionText: Value(questionText),
      category: Value(category),
      answerText: answerText == null && nullToAbsent
          ? const Value.absent()
          : Value(answerText),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      feedback: feedback == null && nullToAbsent
          ? const Value.absent()
          : Value(feedback),
      idealAnswer: idealAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(idealAnswer),
      starAnalysis: starAnalysis == null && nullToAbsent
          ? const Value.absent()
          : Value(starAnalysis),
      suggestedKeywords: suggestedKeywords == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedKeywords),
    );
  }

  factory InterviewQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterviewQuestion(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      questionNumber: serializer.fromJson<int>(json['questionNumber']),
      questionText: serializer.fromJson<String>(json['questionText']),
      category: serializer.fromJson<String>(json['category']),
      answerText: serializer.fromJson<String?>(json['answerText']),
      score: serializer.fromJson<double?>(json['score']),
      feedback: serializer.fromJson<String?>(json['feedback']),
      idealAnswer: serializer.fromJson<String?>(json['idealAnswer']),
      starAnalysis: serializer.fromJson<String?>(json['starAnalysis']),
      suggestedKeywords: serializer.fromJson<String?>(
        json['suggestedKeywords'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'questionNumber': serializer.toJson<int>(questionNumber),
      'questionText': serializer.toJson<String>(questionText),
      'category': serializer.toJson<String>(category),
      'answerText': serializer.toJson<String?>(answerText),
      'score': serializer.toJson<double?>(score),
      'feedback': serializer.toJson<String?>(feedback),
      'idealAnswer': serializer.toJson<String?>(idealAnswer),
      'starAnalysis': serializer.toJson<String?>(starAnalysis),
      'suggestedKeywords': serializer.toJson<String?>(suggestedKeywords),
    };
  }

  InterviewQuestion copyWith({
    String? id,
    String? sessionId,
    int? questionNumber,
    String? questionText,
    String? category,
    Value<String?> answerText = const Value.absent(),
    Value<double?> score = const Value.absent(),
    Value<String?> feedback = const Value.absent(),
    Value<String?> idealAnswer = const Value.absent(),
    Value<String?> starAnalysis = const Value.absent(),
    Value<String?> suggestedKeywords = const Value.absent(),
  }) => InterviewQuestion(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    questionNumber: questionNumber ?? this.questionNumber,
    questionText: questionText ?? this.questionText,
    category: category ?? this.category,
    answerText: answerText.present ? answerText.value : this.answerText,
    score: score.present ? score.value : this.score,
    feedback: feedback.present ? feedback.value : this.feedback,
    idealAnswer: idealAnswer.present ? idealAnswer.value : this.idealAnswer,
    starAnalysis: starAnalysis.present ? starAnalysis.value : this.starAnalysis,
    suggestedKeywords: suggestedKeywords.present
        ? suggestedKeywords.value
        : this.suggestedKeywords,
  );
  InterviewQuestion copyWithCompanion(InterviewQuestionsCompanion data) {
    return InterviewQuestion(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionNumber: data.questionNumber.present
          ? data.questionNumber.value
          : this.questionNumber,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      category: data.category.present ? data.category.value : this.category,
      answerText: data.answerText.present
          ? data.answerText.value
          : this.answerText,
      score: data.score.present ? data.score.value : this.score,
      feedback: data.feedback.present ? data.feedback.value : this.feedback,
      idealAnswer: data.idealAnswer.present
          ? data.idealAnswer.value
          : this.idealAnswer,
      starAnalysis: data.starAnalysis.present
          ? data.starAnalysis.value
          : this.starAnalysis,
      suggestedKeywords: data.suggestedKeywords.present
          ? data.suggestedKeywords.value
          : this.suggestedKeywords,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterviewQuestion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionNumber: $questionNumber, ')
          ..write('questionText: $questionText, ')
          ..write('category: $category, ')
          ..write('answerText: $answerText, ')
          ..write('score: $score, ')
          ..write('feedback: $feedback, ')
          ..write('idealAnswer: $idealAnswer, ')
          ..write('starAnalysis: $starAnalysis, ')
          ..write('suggestedKeywords: $suggestedKeywords')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    questionNumber,
    questionText,
    category,
    answerText,
    score,
    feedback,
    idealAnswer,
    starAnalysis,
    suggestedKeywords,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterviewQuestion &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.questionNumber == this.questionNumber &&
          other.questionText == this.questionText &&
          other.category == this.category &&
          other.answerText == this.answerText &&
          other.score == this.score &&
          other.feedback == this.feedback &&
          other.idealAnswer == this.idealAnswer &&
          other.starAnalysis == this.starAnalysis &&
          other.suggestedKeywords == this.suggestedKeywords);
}

class InterviewQuestionsCompanion extends UpdateCompanion<InterviewQuestion> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> questionNumber;
  final Value<String> questionText;
  final Value<String> category;
  final Value<String?> answerText;
  final Value<double?> score;
  final Value<String?> feedback;
  final Value<String?> idealAnswer;
  final Value<String?> starAnalysis;
  final Value<String?> suggestedKeywords;
  final Value<int> rowid;
  const InterviewQuestionsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionNumber = const Value.absent(),
    this.questionText = const Value.absent(),
    this.category = const Value.absent(),
    this.answerText = const Value.absent(),
    this.score = const Value.absent(),
    this.feedback = const Value.absent(),
    this.idealAnswer = const Value.absent(),
    this.starAnalysis = const Value.absent(),
    this.suggestedKeywords = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InterviewQuestionsCompanion.insert({
    required String id,
    required String sessionId,
    required int questionNumber,
    required String questionText,
    required String category,
    this.answerText = const Value.absent(),
    this.score = const Value.absent(),
    this.feedback = const Value.absent(),
    this.idealAnswer = const Value.absent(),
    this.starAnalysis = const Value.absent(),
    this.suggestedKeywords = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       questionNumber = Value(questionNumber),
       questionText = Value(questionText),
       category = Value(category);
  static Insertable<InterviewQuestion> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? questionNumber,
    Expression<String>? questionText,
    Expression<String>? category,
    Expression<String>? answerText,
    Expression<double>? score,
    Expression<String>? feedback,
    Expression<String>? idealAnswer,
    Expression<String>? starAnalysis,
    Expression<String>? suggestedKeywords,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (questionNumber != null) 'question_number': questionNumber,
      if (questionText != null) 'question_text': questionText,
      if (category != null) 'category': category,
      if (answerText != null) 'answer_text': answerText,
      if (score != null) 'score': score,
      if (feedback != null) 'feedback': feedback,
      if (idealAnswer != null) 'ideal_answer': idealAnswer,
      if (starAnalysis != null) 'star_analysis': starAnalysis,
      if (suggestedKeywords != null) 'suggested_keywords': suggestedKeywords,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InterviewQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? questionNumber,
    Value<String>? questionText,
    Value<String>? category,
    Value<String?>? answerText,
    Value<double?>? score,
    Value<String?>? feedback,
    Value<String?>? idealAnswer,
    Value<String?>? starAnalysis,
    Value<String?>? suggestedKeywords,
    Value<int>? rowid,
  }) {
    return InterviewQuestionsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionNumber: questionNumber ?? this.questionNumber,
      questionText: questionText ?? this.questionText,
      category: category ?? this.category,
      answerText: answerText ?? this.answerText,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
      idealAnswer: idealAnswer ?? this.idealAnswer,
      starAnalysis: starAnalysis ?? this.starAnalysis,
      suggestedKeywords: suggestedKeywords ?? this.suggestedKeywords,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (questionNumber.present) {
      map['question_number'] = Variable<int>(questionNumber.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (answerText.present) {
      map['answer_text'] = Variable<String>(answerText.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (feedback.present) {
      map['feedback'] = Variable<String>(feedback.value);
    }
    if (idealAnswer.present) {
      map['ideal_answer'] = Variable<String>(idealAnswer.value);
    }
    if (starAnalysis.present) {
      map['star_analysis'] = Variable<String>(starAnalysis.value);
    }
    if (suggestedKeywords.present) {
      map['suggested_keywords'] = Variable<String>(suggestedKeywords.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterviewQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionNumber: $questionNumber, ')
          ..write('questionText: $questionText, ')
          ..write('category: $category, ')
          ..write('answerText: $answerText, ')
          ..write('score: $score, ')
          ..write('feedback: $feedback, ')
          ..write('idealAnswer: $idealAnswer, ')
          ..write('starAnalysis: $starAnalysis, ')
          ..write('suggestedKeywords: $suggestedKeywords, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ResumeProfilesTable extends ResumeProfiles
    with TableInfo<$ResumeProfilesTable, ResumeProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResumeProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisMeta = const VerificationMeta(
    'analysis',
  );
  @override
  late final GeneratedColumn<String> analysis = GeneratedColumn<String>(
    'analysis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthsMeta = const VerificationMeta(
    'strengths',
  );
  @override
  late final GeneratedColumn<String> strengths = GeneratedColumn<String>(
    'strengths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weaknessesMeta = const VerificationMeta(
    'weaknesses',
  );
  @override
  late final GeneratedColumn<String> weaknesses = GeneratedColumn<String>(
    'weaknesses',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedQuestionsMeta =
      const VerificationMeta('suggestedQuestions');
  @override
  late final GeneratedColumn<String> suggestedQuestions =
      GeneratedColumn<String>(
        'suggested_questions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    extractedText,
    analysis,
    strengths,
    weaknesses,
    suggestedQuestions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resume_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResumeProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractedTextMeta);
    }
    if (data.containsKey('analysis')) {
      context.handle(
        _analysisMeta,
        analysis.isAcceptableOrUnknown(data['analysis']!, _analysisMeta),
      );
    }
    if (data.containsKey('strengths')) {
      context.handle(
        _strengthsMeta,
        strengths.isAcceptableOrUnknown(data['strengths']!, _strengthsMeta),
      );
    }
    if (data.containsKey('weaknesses')) {
      context.handle(
        _weaknessesMeta,
        weaknesses.isAcceptableOrUnknown(data['weaknesses']!, _weaknessesMeta),
      );
    }
    if (data.containsKey('suggested_questions')) {
      context.handle(
        _suggestedQuestionsMeta,
        suggestedQuestions.isAcceptableOrUnknown(
          data['suggested_questions']!,
          _suggestedQuestionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResumeProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResumeProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      )!,
      analysis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis'],
      ),
      strengths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strengths'],
      ),
      weaknesses: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weaknesses'],
      ),
      suggestedQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_questions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ResumeProfilesTable createAlias(String alias) {
    return $ResumeProfilesTable(attachedDatabase, alias);
  }
}

class ResumeProfile extends DataClass implements Insertable<ResumeProfile> {
  final String id;
  final String extractedText;
  final String? analysis;
  final String? strengths;
  final String? weaknesses;
  final String? suggestedQuestions;
  final DateTime createdAt;
  const ResumeProfile({
    required this.id,
    required this.extractedText,
    this.analysis,
    this.strengths,
    this.weaknesses,
    this.suggestedQuestions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['extracted_text'] = Variable<String>(extractedText);
    if (!nullToAbsent || analysis != null) {
      map['analysis'] = Variable<String>(analysis);
    }
    if (!nullToAbsent || strengths != null) {
      map['strengths'] = Variable<String>(strengths);
    }
    if (!nullToAbsent || weaknesses != null) {
      map['weaknesses'] = Variable<String>(weaknesses);
    }
    if (!nullToAbsent || suggestedQuestions != null) {
      map['suggested_questions'] = Variable<String>(suggestedQuestions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ResumeProfilesCompanion toCompanion(bool nullToAbsent) {
    return ResumeProfilesCompanion(
      id: Value(id),
      extractedText: Value(extractedText),
      analysis: analysis == null && nullToAbsent
          ? const Value.absent()
          : Value(analysis),
      strengths: strengths == null && nullToAbsent
          ? const Value.absent()
          : Value(strengths),
      weaknesses: weaknesses == null && nullToAbsent
          ? const Value.absent()
          : Value(weaknesses),
      suggestedQuestions: suggestedQuestions == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedQuestions),
      createdAt: Value(createdAt),
    );
  }

  factory ResumeProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResumeProfile(
      id: serializer.fromJson<String>(json['id']),
      extractedText: serializer.fromJson<String>(json['extractedText']),
      analysis: serializer.fromJson<String?>(json['analysis']),
      strengths: serializer.fromJson<String?>(json['strengths']),
      weaknesses: serializer.fromJson<String?>(json['weaknesses']),
      suggestedQuestions: serializer.fromJson<String?>(
        json['suggestedQuestions'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'extractedText': serializer.toJson<String>(extractedText),
      'analysis': serializer.toJson<String?>(analysis),
      'strengths': serializer.toJson<String?>(strengths),
      'weaknesses': serializer.toJson<String?>(weaknesses),
      'suggestedQuestions': serializer.toJson<String?>(suggestedQuestions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ResumeProfile copyWith({
    String? id,
    String? extractedText,
    Value<String?> analysis = const Value.absent(),
    Value<String?> strengths = const Value.absent(),
    Value<String?> weaknesses = const Value.absent(),
    Value<String?> suggestedQuestions = const Value.absent(),
    DateTime? createdAt,
  }) => ResumeProfile(
    id: id ?? this.id,
    extractedText: extractedText ?? this.extractedText,
    analysis: analysis.present ? analysis.value : this.analysis,
    strengths: strengths.present ? strengths.value : this.strengths,
    weaknesses: weaknesses.present ? weaknesses.value : this.weaknesses,
    suggestedQuestions: suggestedQuestions.present
        ? suggestedQuestions.value
        : this.suggestedQuestions,
    createdAt: createdAt ?? this.createdAt,
  );
  ResumeProfile copyWithCompanion(ResumeProfilesCompanion data) {
    return ResumeProfile(
      id: data.id.present ? data.id.value : this.id,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      analysis: data.analysis.present ? data.analysis.value : this.analysis,
      strengths: data.strengths.present ? data.strengths.value : this.strengths,
      weaknesses: data.weaknesses.present
          ? data.weaknesses.value
          : this.weaknesses,
      suggestedQuestions: data.suggestedQuestions.present
          ? data.suggestedQuestions.value
          : this.suggestedQuestions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResumeProfile(')
          ..write('id: $id, ')
          ..write('extractedText: $extractedText, ')
          ..write('analysis: $analysis, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('suggestedQuestions: $suggestedQuestions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    extractedText,
    analysis,
    strengths,
    weaknesses,
    suggestedQuestions,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResumeProfile &&
          other.id == this.id &&
          other.extractedText == this.extractedText &&
          other.analysis == this.analysis &&
          other.strengths == this.strengths &&
          other.weaknesses == this.weaknesses &&
          other.suggestedQuestions == this.suggestedQuestions &&
          other.createdAt == this.createdAt);
}

class ResumeProfilesCompanion extends UpdateCompanion<ResumeProfile> {
  final Value<String> id;
  final Value<String> extractedText;
  final Value<String?> analysis;
  final Value<String?> strengths;
  final Value<String?> weaknesses;
  final Value<String?> suggestedQuestions;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ResumeProfilesCompanion({
    this.id = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.analysis = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.suggestedQuestions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ResumeProfilesCompanion.insert({
    required String id,
    required String extractedText,
    this.analysis = const Value.absent(),
    this.strengths = const Value.absent(),
    this.weaknesses = const Value.absent(),
    this.suggestedQuestions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       extractedText = Value(extractedText);
  static Insertable<ResumeProfile> custom({
    Expression<String>? id,
    Expression<String>? extractedText,
    Expression<String>? analysis,
    Expression<String>? strengths,
    Expression<String>? weaknesses,
    Expression<String>? suggestedQuestions,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (extractedText != null) 'extracted_text': extractedText,
      if (analysis != null) 'analysis': analysis,
      if (strengths != null) 'strengths': strengths,
      if (weaknesses != null) 'weaknesses': weaknesses,
      if (suggestedQuestions != null) 'suggested_questions': suggestedQuestions,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ResumeProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? extractedText,
    Value<String?>? analysis,
    Value<String?>? strengths,
    Value<String?>? weaknesses,
    Value<String?>? suggestedQuestions,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ResumeProfilesCompanion(
      id: id ?? this.id,
      extractedText: extractedText ?? this.extractedText,
      analysis: analysis ?? this.analysis,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      suggestedQuestions: suggestedQuestions ?? this.suggestedQuestions,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (analysis.present) {
      map['analysis'] = Variable<String>(analysis.value);
    }
    if (strengths.present) {
      map['strengths'] = Variable<String>(strengths.value);
    }
    if (weaknesses.present) {
      map['weaknesses'] = Variable<String>(weaknesses.value);
    }
    if (suggestedQuestions.present) {
      map['suggested_questions'] = Variable<String>(suggestedQuestions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResumeProfilesCompanion(')
          ..write('id: $id, ')
          ..write('extractedText: $extractedText, ')
          ..write('analysis: $analysis, ')
          ..write('strengths: $strengths, ')
          ..write('weaknesses: $weaknesses, ')
          ..write('suggestedQuestions: $suggestedQuestions, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InterviewSessionsTable interviewSessions =
      $InterviewSessionsTable(this);
  late final $InterviewQuestionsTable interviewQuestions =
      $InterviewQuestionsTable(this);
  late final $ResumeProfilesTable resumeProfiles = $ResumeProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    interviewSessions,
    interviewQuestions,
    resumeProfiles,
  ];
}

typedef $$InterviewSessionsTableCreateCompanionBuilder =
    InterviewSessionsCompanion Function({
      required String id,
      required String position,
      required String company,
      required String level,
      required String questionType,
      Value<String> language,
      required int questionCount,
      Value<int> timePerQuestion,
      Value<double?> totalScore,
      Value<String?> overallFeedback,
      Value<String?> strengths,
      Value<String?> weaknesses,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$InterviewSessionsTableUpdateCompanionBuilder =
    InterviewSessionsCompanion Function({
      Value<String> id,
      Value<String> position,
      Value<String> company,
      Value<String> level,
      Value<String> questionType,
      Value<String> language,
      Value<int> questionCount,
      Value<int> timePerQuestion,
      Value<double?> totalScore,
      Value<String?> overallFeedback,
      Value<String?> strengths,
      Value<String?> weaknesses,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$InterviewSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InterviewSessionsTable,
          InterviewSession
        > {
  $$InterviewSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$InterviewQuestionsTable, List<InterviewQuestion>>
  _interviewQuestionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.interviewQuestions,
        aliasName: $_aliasNameGenerator(
          db.interviewSessions.id,
          db.interviewQuestions.sessionId,
        ),
      );

  $$InterviewQuestionsTableProcessedTableManager get interviewQuestionsRefs {
    final manager = $$InterviewQuestionsTableTableManager(
      $_db,
      $_db.interviewQuestions,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _interviewQuestionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InterviewSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $InterviewSessionsTable> {
  $$InterviewSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionType => $composableBuilder(
    column: $table.questionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overallFeedback => $composableBuilder(
    column: $table.overallFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> interviewQuestionsRefs(
    Expression<bool> Function($$InterviewQuestionsTableFilterComposer f) f,
  ) {
    final $$InterviewQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interviewQuestions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.interviewQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterviewSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterviewSessionsTable> {
  $$InterviewSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionType => $composableBuilder(
    column: $table.questionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overallFeedback => $composableBuilder(
    column: $table.overallFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InterviewSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterviewSessionsTable> {
  $$InterviewSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get questionType => $composableBuilder(
    column: $table.questionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overallFeedback => $composableBuilder(
    column: $table.overallFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<String> get strengths =>
      $composableBuilder(column: $table.strengths, builder: (column) => column);

  GeneratedColumn<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> interviewQuestionsRefs<T extends Object>(
    Expression<T> Function($$InterviewQuestionsTableAnnotationComposer a) f,
  ) {
    final $$InterviewQuestionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.interviewQuestions,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InterviewQuestionsTableAnnotationComposer(
                $db: $db,
                $table: $db.interviewQuestions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InterviewSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterviewSessionsTable,
          InterviewSession,
          $$InterviewSessionsTableFilterComposer,
          $$InterviewSessionsTableOrderingComposer,
          $$InterviewSessionsTableAnnotationComposer,
          $$InterviewSessionsTableCreateCompanionBuilder,
          $$InterviewSessionsTableUpdateCompanionBuilder,
          (InterviewSession, $$InterviewSessionsTableReferences),
          InterviewSession,
          PrefetchHooks Function({bool interviewQuestionsRefs})
        > {
  $$InterviewSessionsTableTableManager(
    _$AppDatabase db,
    $InterviewSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterviewSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterviewSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterviewSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> position = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> questionType = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> questionCount = const Value.absent(),
                Value<int> timePerQuestion = const Value.absent(),
                Value<double?> totalScore = const Value.absent(),
                Value<String?> overallFeedback = const Value.absent(),
                Value<String?> strengths = const Value.absent(),
                Value<String?> weaknesses = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InterviewSessionsCompanion(
                id: id,
                position: position,
                company: company,
                level: level,
                questionType: questionType,
                language: language,
                questionCount: questionCount,
                timePerQuestion: timePerQuestion,
                totalScore: totalScore,
                overallFeedback: overallFeedback,
                strengths: strengths,
                weaknesses: weaknesses,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String position,
                required String company,
                required String level,
                required String questionType,
                Value<String> language = const Value.absent(),
                required int questionCount,
                Value<int> timePerQuestion = const Value.absent(),
                Value<double?> totalScore = const Value.absent(),
                Value<String?> overallFeedback = const Value.absent(),
                Value<String?> strengths = const Value.absent(),
                Value<String?> weaknesses = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InterviewSessionsCompanion.insert(
                id: id,
                position: position,
                company: company,
                level: level,
                questionType: questionType,
                language: language,
                questionCount: questionCount,
                timePerQuestion: timePerQuestion,
                totalScore: totalScore,
                overallFeedback: overallFeedback,
                strengths: strengths,
                weaknesses: weaknesses,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InterviewSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({interviewQuestionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (interviewQuestionsRefs) db.interviewQuestions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (interviewQuestionsRefs)
                    await $_getPrefetchedData<
                      InterviewSession,
                      $InterviewSessionsTable,
                      InterviewQuestion
                    >(
                      currentTable: table,
                      referencedTable: $$InterviewSessionsTableReferences
                          ._interviewQuestionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$InterviewSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).interviewQuestionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$InterviewSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterviewSessionsTable,
      InterviewSession,
      $$InterviewSessionsTableFilterComposer,
      $$InterviewSessionsTableOrderingComposer,
      $$InterviewSessionsTableAnnotationComposer,
      $$InterviewSessionsTableCreateCompanionBuilder,
      $$InterviewSessionsTableUpdateCompanionBuilder,
      (InterviewSession, $$InterviewSessionsTableReferences),
      InterviewSession,
      PrefetchHooks Function({bool interviewQuestionsRefs})
    >;
typedef $$InterviewQuestionsTableCreateCompanionBuilder =
    InterviewQuestionsCompanion Function({
      required String id,
      required String sessionId,
      required int questionNumber,
      required String questionText,
      required String category,
      Value<String?> answerText,
      Value<double?> score,
      Value<String?> feedback,
      Value<String?> idealAnswer,
      Value<String?> starAnalysis,
      Value<String?> suggestedKeywords,
      Value<int> rowid,
    });
typedef $$InterviewQuestionsTableUpdateCompanionBuilder =
    InterviewQuestionsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> questionNumber,
      Value<String> questionText,
      Value<String> category,
      Value<String?> answerText,
      Value<double?> score,
      Value<String?> feedback,
      Value<String?> idealAnswer,
      Value<String?> starAnalysis,
      Value<String?> suggestedKeywords,
      Value<int> rowid,
    });

final class $$InterviewQuestionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InterviewQuestionsTable,
          InterviewQuestion
        > {
  $$InterviewQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InterviewSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.interviewSessions.createAlias(
        $_aliasNameGenerator(
          db.interviewQuestions.sessionId,
          db.interviewSessions.id,
        ),
      );

  $$InterviewSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$InterviewSessionsTableTableManager(
      $_db,
      $_db.interviewSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InterviewQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $InterviewQuestionsTable> {
  $$InterviewQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idealAnswer => $composableBuilder(
    column: $table.idealAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get starAnalysis => $composableBuilder(
    column: $table.starAnalysis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedKeywords => $composableBuilder(
    column: $table.suggestedKeywords,
    builder: (column) => ColumnFilters(column),
  );

  $$InterviewSessionsTableFilterComposer get sessionId {
    final $$InterviewSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.interviewSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewSessionsTableFilterComposer(
            $db: $db,
            $table: $db.interviewSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InterviewQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterviewQuestionsTable> {
  $$InterviewQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedback => $composableBuilder(
    column: $table.feedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idealAnswer => $composableBuilder(
    column: $table.idealAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get starAnalysis => $composableBuilder(
    column: $table.starAnalysis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedKeywords => $composableBuilder(
    column: $table.suggestedKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  $$InterviewSessionsTableOrderingComposer get sessionId {
    final $$InterviewSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.interviewSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.interviewSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InterviewQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterviewQuestionsTable> {
  $$InterviewQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionNumber => $composableBuilder(
    column: $table.questionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get feedback =>
      $composableBuilder(column: $table.feedback, builder: (column) => column);

  GeneratedColumn<String> get idealAnswer => $composableBuilder(
    column: $table.idealAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get starAnalysis => $composableBuilder(
    column: $table.starAnalysis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedKeywords => $composableBuilder(
    column: $table.suggestedKeywords,
    builder: (column) => column,
  );

  $$InterviewSessionsTableAnnotationComposer get sessionId {
    final $$InterviewSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.interviewSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$InterviewSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.interviewSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$InterviewQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterviewQuestionsTable,
          InterviewQuestion,
          $$InterviewQuestionsTableFilterComposer,
          $$InterviewQuestionsTableOrderingComposer,
          $$InterviewQuestionsTableAnnotationComposer,
          $$InterviewQuestionsTableCreateCompanionBuilder,
          $$InterviewQuestionsTableUpdateCompanionBuilder,
          (InterviewQuestion, $$InterviewQuestionsTableReferences),
          InterviewQuestion,
          PrefetchHooks Function({bool sessionId})
        > {
  $$InterviewQuestionsTableTableManager(
    _$AppDatabase db,
    $InterviewQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterviewQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterviewQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterviewQuestionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> questionNumber = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> answerText = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<String?> feedback = const Value.absent(),
                Value<String?> idealAnswer = const Value.absent(),
                Value<String?> starAnalysis = const Value.absent(),
                Value<String?> suggestedKeywords = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InterviewQuestionsCompanion(
                id: id,
                sessionId: sessionId,
                questionNumber: questionNumber,
                questionText: questionText,
                category: category,
                answerText: answerText,
                score: score,
                feedback: feedback,
                idealAnswer: idealAnswer,
                starAnalysis: starAnalysis,
                suggestedKeywords: suggestedKeywords,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int questionNumber,
                required String questionText,
                required String category,
                Value<String?> answerText = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<String?> feedback = const Value.absent(),
                Value<String?> idealAnswer = const Value.absent(),
                Value<String?> starAnalysis = const Value.absent(),
                Value<String?> suggestedKeywords = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InterviewQuestionsCompanion.insert(
                id: id,
                sessionId: sessionId,
                questionNumber: questionNumber,
                questionText: questionText,
                category: category,
                answerText: answerText,
                score: score,
                feedback: feedback,
                idealAnswer: idealAnswer,
                starAnalysis: starAnalysis,
                suggestedKeywords: suggestedKeywords,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InterviewQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$InterviewQuestionsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$InterviewQuestionsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InterviewQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterviewQuestionsTable,
      InterviewQuestion,
      $$InterviewQuestionsTableFilterComposer,
      $$InterviewQuestionsTableOrderingComposer,
      $$InterviewQuestionsTableAnnotationComposer,
      $$InterviewQuestionsTableCreateCompanionBuilder,
      $$InterviewQuestionsTableUpdateCompanionBuilder,
      (InterviewQuestion, $$InterviewQuestionsTableReferences),
      InterviewQuestion,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ResumeProfilesTableCreateCompanionBuilder =
    ResumeProfilesCompanion Function({
      required String id,
      required String extractedText,
      Value<String?> analysis,
      Value<String?> strengths,
      Value<String?> weaknesses,
      Value<String?> suggestedQuestions,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ResumeProfilesTableUpdateCompanionBuilder =
    ResumeProfilesCompanion Function({
      Value<String> id,
      Value<String> extractedText,
      Value<String?> analysis,
      Value<String?> strengths,
      Value<String?> weaknesses,
      Value<String?> suggestedQuestions,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ResumeProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ResumeProfilesTable> {
  $$ResumeProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get analysis => $composableBuilder(
    column: $table.analysis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedQuestions => $composableBuilder(
    column: $table.suggestedQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ResumeProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ResumeProfilesTable> {
  $$ResumeProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get analysis => $composableBuilder(
    column: $table.analysis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strengths => $composableBuilder(
    column: $table.strengths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedQuestions => $composableBuilder(
    column: $table.suggestedQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ResumeProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResumeProfilesTable> {
  $$ResumeProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get analysis =>
      $composableBuilder(column: $table.analysis, builder: (column) => column);

  GeneratedColumn<String> get strengths =>
      $composableBuilder(column: $table.strengths, builder: (column) => column);

  GeneratedColumn<String> get weaknesses => $composableBuilder(
    column: $table.weaknesses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedQuestions => $composableBuilder(
    column: $table.suggestedQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ResumeProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResumeProfilesTable,
          ResumeProfile,
          $$ResumeProfilesTableFilterComposer,
          $$ResumeProfilesTableOrderingComposer,
          $$ResumeProfilesTableAnnotationComposer,
          $$ResumeProfilesTableCreateCompanionBuilder,
          $$ResumeProfilesTableUpdateCompanionBuilder,
          (
            ResumeProfile,
            BaseReferences<_$AppDatabase, $ResumeProfilesTable, ResumeProfile>,
          ),
          ResumeProfile,
          PrefetchHooks Function()
        > {
  $$ResumeProfilesTableTableManager(
    _$AppDatabase db,
    $ResumeProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResumeProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResumeProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResumeProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> extractedText = const Value.absent(),
                Value<String?> analysis = const Value.absent(),
                Value<String?> strengths = const Value.absent(),
                Value<String?> weaknesses = const Value.absent(),
                Value<String?> suggestedQuestions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResumeProfilesCompanion(
                id: id,
                extractedText: extractedText,
                analysis: analysis,
                strengths: strengths,
                weaknesses: weaknesses,
                suggestedQuestions: suggestedQuestions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String extractedText,
                Value<String?> analysis = const Value.absent(),
                Value<String?> strengths = const Value.absent(),
                Value<String?> weaknesses = const Value.absent(),
                Value<String?> suggestedQuestions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ResumeProfilesCompanion.insert(
                id: id,
                extractedText: extractedText,
                analysis: analysis,
                strengths: strengths,
                weaknesses: weaknesses,
                suggestedQuestions: suggestedQuestions,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResumeProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResumeProfilesTable,
      ResumeProfile,
      $$ResumeProfilesTableFilterComposer,
      $$ResumeProfilesTableOrderingComposer,
      $$ResumeProfilesTableAnnotationComposer,
      $$ResumeProfilesTableCreateCompanionBuilder,
      $$ResumeProfilesTableUpdateCompanionBuilder,
      (
        ResumeProfile,
        BaseReferences<_$AppDatabase, $ResumeProfilesTable, ResumeProfile>,
      ),
      ResumeProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InterviewSessionsTableTableManager get interviewSessions =>
      $$InterviewSessionsTableTableManager(_db, _db.interviewSessions);
  $$InterviewQuestionsTableTableManager get interviewQuestions =>
      $$InterviewQuestionsTableTableManager(_db, _db.interviewQuestions);
  $$ResumeProfilesTableTableManager get resumeProfiles =>
      $$ResumeProfilesTableTableManager(_db, _db.resumeProfiles);
}
