// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openai_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OpenAIRequest _$OpenAIRequestFromJson(Map<String, dynamic> json) {
  return _OpenAIRequest.fromJson(json);
}

/// @nodoc
mixin _$OpenAIRequest {
  String get model => throw _privateConstructorUsedError;
  List<OpenAIMessage> get messages => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_tokens')
  int get maxTokens => throw _privateConstructorUsedError;

  /// Serializes this OpenAIRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIRequestCopyWith<OpenAIRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIRequestCopyWith<$Res> {
  factory $OpenAIRequestCopyWith(
    OpenAIRequest value,
    $Res Function(OpenAIRequest) then,
  ) = _$OpenAIRequestCopyWithImpl<$Res, OpenAIRequest>;
  @useResult
  $Res call({
    String model,
    List<OpenAIMessage> messages,
    double temperature,
    @JsonKey(name: 'max_tokens') int maxTokens,
  });
}

/// @nodoc
class _$OpenAIRequestCopyWithImpl<$Res, $Val extends OpenAIRequest>
    implements $OpenAIRequestCopyWith<$Res> {
  _$OpenAIRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? messages = null,
    Object? temperature = null,
    Object? maxTokens = null,
  }) {
    return _then(
      _value.copyWith(
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<OpenAIMessage>,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            maxTokens: null == maxTokens
                ? _value.maxTokens
                : maxTokens // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpenAIRequestImplCopyWith<$Res>
    implements $OpenAIRequestCopyWith<$Res> {
  factory _$$OpenAIRequestImplCopyWith(
    _$OpenAIRequestImpl value,
    $Res Function(_$OpenAIRequestImpl) then,
  ) = __$$OpenAIRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String model,
    List<OpenAIMessage> messages,
    double temperature,
    @JsonKey(name: 'max_tokens') int maxTokens,
  });
}

/// @nodoc
class __$$OpenAIRequestImplCopyWithImpl<$Res>
    extends _$OpenAIRequestCopyWithImpl<$Res, _$OpenAIRequestImpl>
    implements _$$OpenAIRequestImplCopyWith<$Res> {
  __$$OpenAIRequestImplCopyWithImpl(
    _$OpenAIRequestImpl _value,
    $Res Function(_$OpenAIRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAIRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? messages = null,
    Object? temperature = null,
    Object? maxTokens = null,
  }) {
    return _then(
      _$OpenAIRequestImpl(
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<OpenAIMessage>,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        maxTokens: null == maxTokens
            ? _value.maxTokens
            : maxTokens // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIRequestImpl implements _OpenAIRequest {
  const _$OpenAIRequestImpl({
    required this.model,
    required final List<OpenAIMessage> messages,
    this.temperature = 0.7,
    @JsonKey(name: 'max_tokens') this.maxTokens = 2000,
  }) : _messages = messages;

  factory _$OpenAIRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIRequestImplFromJson(json);

  @override
  final String model;
  final List<OpenAIMessage> _messages;
  @override
  List<OpenAIMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey(name: 'max_tokens')
  final int maxTokens;

  @override
  String toString() {
    return 'OpenAIRequest(model: $model, messages: $messages, temperature: $temperature, maxTokens: $maxTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIRequestImpl &&
            (identical(other.model, model) || other.model == model) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    model,
    const DeepCollectionEquality().hash(_messages),
    temperature,
    maxTokens,
  );

  /// Create a copy of OpenAIRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIRequestImplCopyWith<_$OpenAIRequestImpl> get copyWith =>
      __$$OpenAIRequestImplCopyWithImpl<_$OpenAIRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIRequestImplToJson(this);
  }
}

abstract class _OpenAIRequest implements OpenAIRequest {
  const factory _OpenAIRequest({
    required final String model,
    required final List<OpenAIMessage> messages,
    final double temperature,
    @JsonKey(name: 'max_tokens') final int maxTokens,
  }) = _$OpenAIRequestImpl;

  factory _OpenAIRequest.fromJson(Map<String, dynamic> json) =
      _$OpenAIRequestImpl.fromJson;

  @override
  String get model;
  @override
  List<OpenAIMessage> get messages;
  @override
  double get temperature;
  @override
  @JsonKey(name: 'max_tokens')
  int get maxTokens;

  /// Create a copy of OpenAIRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIRequestImplCopyWith<_$OpenAIRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenAIMessage _$OpenAIMessageFromJson(Map<String, dynamic> json) {
  return _OpenAIMessage.fromJson(json);
}

/// @nodoc
mixin _$OpenAIMessage {
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this OpenAIMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIMessageCopyWith<OpenAIMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIMessageCopyWith<$Res> {
  factory $OpenAIMessageCopyWith(
    OpenAIMessage value,
    $Res Function(OpenAIMessage) then,
  ) = _$OpenAIMessageCopyWithImpl<$Res, OpenAIMessage>;
  @useResult
  $Res call({String role, String content});
}

/// @nodoc
class _$OpenAIMessageCopyWithImpl<$Res, $Val extends OpenAIMessage>
    implements $OpenAIMessageCopyWith<$Res> {
  _$OpenAIMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpenAIMessageImplCopyWith<$Res>
    implements $OpenAIMessageCopyWith<$Res> {
  factory _$$OpenAIMessageImplCopyWith(
    _$OpenAIMessageImpl value,
    $Res Function(_$OpenAIMessageImpl) then,
  ) = __$$OpenAIMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String role, String content});
}

/// @nodoc
class __$$OpenAIMessageImplCopyWithImpl<$Res>
    extends _$OpenAIMessageCopyWithImpl<$Res, _$OpenAIMessageImpl>
    implements _$$OpenAIMessageImplCopyWith<$Res> {
  __$$OpenAIMessageImplCopyWithImpl(
    _$OpenAIMessageImpl _value,
    $Res Function(_$OpenAIMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAIMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = null, Object? content = null}) {
    return _then(
      _$OpenAIMessageImpl(
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIMessageImpl implements _OpenAIMessage {
  const _$OpenAIMessageImpl({required this.role, required this.content});

  factory _$OpenAIMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIMessageImplFromJson(json);

  @override
  final String role;
  @override
  final String content;

  @override
  String toString() {
    return 'OpenAIMessage(role: $role, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIMessageImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, content);

  /// Create a copy of OpenAIMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIMessageImplCopyWith<_$OpenAIMessageImpl> get copyWith =>
      __$$OpenAIMessageImplCopyWithImpl<_$OpenAIMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIMessageImplToJson(this);
  }
}

abstract class _OpenAIMessage implements OpenAIMessage {
  const factory _OpenAIMessage({
    required final String role,
    required final String content,
  }) = _$OpenAIMessageImpl;

  factory _OpenAIMessage.fromJson(Map<String, dynamic> json) =
      _$OpenAIMessageImpl.fromJson;

  @override
  String get role;
  @override
  String get content;

  /// Create a copy of OpenAIMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIMessageImplCopyWith<_$OpenAIMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenAIResponse _$OpenAIResponseFromJson(Map<String, dynamic> json) {
  return _OpenAIResponse.fromJson(json);
}

/// @nodoc
mixin _$OpenAIResponse {
  String get id => throw _privateConstructorUsedError;
  String get object => throw _privateConstructorUsedError;
  int get created => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  List<OpenAIChoice> get choices => throw _privateConstructorUsedError;
  OpenAIUsage get usage => throw _privateConstructorUsedError;

  /// Serializes this OpenAIResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIResponseCopyWith<OpenAIResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIResponseCopyWith<$Res> {
  factory $OpenAIResponseCopyWith(
    OpenAIResponse value,
    $Res Function(OpenAIResponse) then,
  ) = _$OpenAIResponseCopyWithImpl<$Res, OpenAIResponse>;
  @useResult
  $Res call({
    String id,
    String object,
    int created,
    String model,
    List<OpenAIChoice> choices,
    OpenAIUsage usage,
  });

  $OpenAIUsageCopyWith<$Res> get usage;
}

/// @nodoc
class _$OpenAIResponseCopyWithImpl<$Res, $Val extends OpenAIResponse>
    implements $OpenAIResponseCopyWith<$Res> {
  _$OpenAIResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? object = null,
    Object? created = null,
    Object? model = null,
    Object? choices = null,
    Object? usage = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            object: null == object
                ? _value.object
                : object // ignore: cast_nullable_to_non_nullable
                      as String,
            created: null == created
                ? _value.created
                : created // ignore: cast_nullable_to_non_nullable
                      as int,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            choices: null == choices
                ? _value.choices
                : choices // ignore: cast_nullable_to_non_nullable
                      as List<OpenAIChoice>,
            usage: null == usage
                ? _value.usage
                : usage // ignore: cast_nullable_to_non_nullable
                      as OpenAIUsage,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenAIUsageCopyWith<$Res> get usage {
    return $OpenAIUsageCopyWith<$Res>(_value.usage, (value) {
      return _then(_value.copyWith(usage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenAIResponseImplCopyWith<$Res>
    implements $OpenAIResponseCopyWith<$Res> {
  factory _$$OpenAIResponseImplCopyWith(
    _$OpenAIResponseImpl value,
    $Res Function(_$OpenAIResponseImpl) then,
  ) = __$$OpenAIResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String object,
    int created,
    String model,
    List<OpenAIChoice> choices,
    OpenAIUsage usage,
  });

  @override
  $OpenAIUsageCopyWith<$Res> get usage;
}

/// @nodoc
class __$$OpenAIResponseImplCopyWithImpl<$Res>
    extends _$OpenAIResponseCopyWithImpl<$Res, _$OpenAIResponseImpl>
    implements _$$OpenAIResponseImplCopyWith<$Res> {
  __$$OpenAIResponseImplCopyWithImpl(
    _$OpenAIResponseImpl _value,
    $Res Function(_$OpenAIResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? object = null,
    Object? created = null,
    Object? model = null,
    Object? choices = null,
    Object? usage = null,
  }) {
    return _then(
      _$OpenAIResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        object: null == object
            ? _value.object
            : object // ignore: cast_nullable_to_non_nullable
                  as String,
        created: null == created
            ? _value.created
            : created // ignore: cast_nullable_to_non_nullable
                  as int,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<OpenAIChoice>,
        usage: null == usage
            ? _value.usage
            : usage // ignore: cast_nullable_to_non_nullable
                  as OpenAIUsage,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIResponseImpl implements _OpenAIResponse {
  const _$OpenAIResponseImpl({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required final List<OpenAIChoice> choices,
    required this.usage,
  }) : _choices = choices;

  factory _$OpenAIResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String object;
  @override
  final int created;
  @override
  final String model;
  final List<OpenAIChoice> _choices;
  @override
  List<OpenAIChoice> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @override
  final OpenAIUsage usage;

  @override
  String toString() {
    return 'OpenAIResponse(id: $id, object: $object, created: $created, model: $model, choices: $choices, usage: $usage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.object, object) || other.object == object) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.model, model) || other.model == model) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            (identical(other.usage, usage) || other.usage == usage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    object,
    created,
    model,
    const DeepCollectionEquality().hash(_choices),
    usage,
  );

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIResponseImplCopyWith<_$OpenAIResponseImpl> get copyWith =>
      __$$OpenAIResponseImplCopyWithImpl<_$OpenAIResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIResponseImplToJson(this);
  }
}

abstract class _OpenAIResponse implements OpenAIResponse {
  const factory _OpenAIResponse({
    required final String id,
    required final String object,
    required final int created,
    required final String model,
    required final List<OpenAIChoice> choices,
    required final OpenAIUsage usage,
  }) = _$OpenAIResponseImpl;

  factory _OpenAIResponse.fromJson(Map<String, dynamic> json) =
      _$OpenAIResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get object;
  @override
  int get created;
  @override
  String get model;
  @override
  List<OpenAIChoice> get choices;
  @override
  OpenAIUsage get usage;

  /// Create a copy of OpenAIResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIResponseImplCopyWith<_$OpenAIResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenAIChoice _$OpenAIChoiceFromJson(Map<String, dynamic> json) {
  return _OpenAIChoice.fromJson(json);
}

/// @nodoc
mixin _$OpenAIChoice {
  int get index => throw _privateConstructorUsedError;
  OpenAIMessage get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'finish_reason')
  String? get finishReason => throw _privateConstructorUsedError;

  /// Serializes this OpenAIChoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIChoiceCopyWith<OpenAIChoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIChoiceCopyWith<$Res> {
  factory $OpenAIChoiceCopyWith(
    OpenAIChoice value,
    $Res Function(OpenAIChoice) then,
  ) = _$OpenAIChoiceCopyWithImpl<$Res, OpenAIChoice>;
  @useResult
  $Res call({
    int index,
    OpenAIMessage message,
    @JsonKey(name: 'finish_reason') String? finishReason,
  });

  $OpenAIMessageCopyWith<$Res> get message;
}

/// @nodoc
class _$OpenAIChoiceCopyWithImpl<$Res, $Val extends OpenAIChoice>
    implements $OpenAIChoiceCopyWith<$Res> {
  _$OpenAIChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? message = null,
    Object? finishReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            index: null == index
                ? _value.index
                : index // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as OpenAIMessage,
            finishReason: freezed == finishReason
                ? _value.finishReason
                : finishReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OpenAIMessageCopyWith<$Res> get message {
    return $OpenAIMessageCopyWith<$Res>(_value.message, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenAIChoiceImplCopyWith<$Res>
    implements $OpenAIChoiceCopyWith<$Res> {
  factory _$$OpenAIChoiceImplCopyWith(
    _$OpenAIChoiceImpl value,
    $Res Function(_$OpenAIChoiceImpl) then,
  ) = __$$OpenAIChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int index,
    OpenAIMessage message,
    @JsonKey(name: 'finish_reason') String? finishReason,
  });

  @override
  $OpenAIMessageCopyWith<$Res> get message;
}

/// @nodoc
class __$$OpenAIChoiceImplCopyWithImpl<$Res>
    extends _$OpenAIChoiceCopyWithImpl<$Res, _$OpenAIChoiceImpl>
    implements _$$OpenAIChoiceImplCopyWith<$Res> {
  __$$OpenAIChoiceImplCopyWithImpl(
    _$OpenAIChoiceImpl _value,
    $Res Function(_$OpenAIChoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? message = null,
    Object? finishReason = freezed,
  }) {
    return _then(
      _$OpenAIChoiceImpl(
        index: null == index
            ? _value.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as OpenAIMessage,
        finishReason: freezed == finishReason
            ? _value.finishReason
            : finishReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIChoiceImpl implements _OpenAIChoice {
  const _$OpenAIChoiceImpl({
    required this.index,
    required this.message,
    @JsonKey(name: 'finish_reason') this.finishReason,
  });

  factory _$OpenAIChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIChoiceImplFromJson(json);

  @override
  final int index;
  @override
  final OpenAIMessage message;
  @override
  @JsonKey(name: 'finish_reason')
  final String? finishReason;

  @override
  String toString() {
    return 'OpenAIChoice(index: $index, message: $message, finishReason: $finishReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIChoiceImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.finishReason, finishReason) ||
                other.finishReason == finishReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, message, finishReason);

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIChoiceImplCopyWith<_$OpenAIChoiceImpl> get copyWith =>
      __$$OpenAIChoiceImplCopyWithImpl<_$OpenAIChoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIChoiceImplToJson(this);
  }
}

abstract class _OpenAIChoice implements OpenAIChoice {
  const factory _OpenAIChoice({
    required final int index,
    required final OpenAIMessage message,
    @JsonKey(name: 'finish_reason') final String? finishReason,
  }) = _$OpenAIChoiceImpl;

  factory _OpenAIChoice.fromJson(Map<String, dynamic> json) =
      _$OpenAIChoiceImpl.fromJson;

  @override
  int get index;
  @override
  OpenAIMessage get message;
  @override
  @JsonKey(name: 'finish_reason')
  String? get finishReason;

  /// Create a copy of OpenAIChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIChoiceImplCopyWith<_$OpenAIChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenAIUsage _$OpenAIUsageFromJson(Map<String, dynamic> json) {
  return _OpenAIUsage.fromJson(json);
}

/// @nodoc
mixin _$OpenAIUsage {
  @JsonKey(name: 'prompt_tokens')
  int get promptTokens => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_tokens')
  int get completionTokens => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_tokens')
  int get totalTokens => throw _privateConstructorUsedError;

  /// Serializes this OpenAIUsage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenAIUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAIUsageCopyWith<OpenAIUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAIUsageCopyWith<$Res> {
  factory $OpenAIUsageCopyWith(
    OpenAIUsage value,
    $Res Function(OpenAIUsage) then,
  ) = _$OpenAIUsageCopyWithImpl<$Res, OpenAIUsage>;
  @useResult
  $Res call({
    @JsonKey(name: 'prompt_tokens') int promptTokens,
    @JsonKey(name: 'completion_tokens') int completionTokens,
    @JsonKey(name: 'total_tokens') int totalTokens,
  });
}

/// @nodoc
class _$OpenAIUsageCopyWithImpl<$Res, $Val extends OpenAIUsage>
    implements $OpenAIUsageCopyWith<$Res> {
  _$OpenAIUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAIUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promptTokens = null,
    Object? completionTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(
      _value.copyWith(
            promptTokens: null == promptTokens
                ? _value.promptTokens
                : promptTokens // ignore: cast_nullable_to_non_nullable
                      as int,
            completionTokens: null == completionTokens
                ? _value.completionTokens
                : completionTokens // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTokens: null == totalTokens
                ? _value.totalTokens
                : totalTokens // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OpenAIUsageImplCopyWith<$Res>
    implements $OpenAIUsageCopyWith<$Res> {
  factory _$$OpenAIUsageImplCopyWith(
    _$OpenAIUsageImpl value,
    $Res Function(_$OpenAIUsageImpl) then,
  ) = __$$OpenAIUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'prompt_tokens') int promptTokens,
    @JsonKey(name: 'completion_tokens') int completionTokens,
    @JsonKey(name: 'total_tokens') int totalTokens,
  });
}

/// @nodoc
class __$$OpenAIUsageImplCopyWithImpl<$Res>
    extends _$OpenAIUsageCopyWithImpl<$Res, _$OpenAIUsageImpl>
    implements _$$OpenAIUsageImplCopyWith<$Res> {
  __$$OpenAIUsageImplCopyWithImpl(
    _$OpenAIUsageImpl _value,
    $Res Function(_$OpenAIUsageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAIUsage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promptTokens = null,
    Object? completionTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(
      _$OpenAIUsageImpl(
        promptTokens: null == promptTokens
            ? _value.promptTokens
            : promptTokens // ignore: cast_nullable_to_non_nullable
                  as int,
        completionTokens: null == completionTokens
            ? _value.completionTokens
            : completionTokens // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTokens: null == totalTokens
            ? _value.totalTokens
            : totalTokens // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenAIUsageImpl implements _OpenAIUsage {
  const _$OpenAIUsageImpl({
    @JsonKey(name: 'prompt_tokens') required this.promptTokens,
    @JsonKey(name: 'completion_tokens') required this.completionTokens,
    @JsonKey(name: 'total_tokens') required this.totalTokens,
  });

  factory _$OpenAIUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenAIUsageImplFromJson(json);

  @override
  @JsonKey(name: 'prompt_tokens')
  final int promptTokens;
  @override
  @JsonKey(name: 'completion_tokens')
  final int completionTokens;
  @override
  @JsonKey(name: 'total_tokens')
  final int totalTokens;

  @override
  String toString() {
    return 'OpenAIUsage(promptTokens: $promptTokens, completionTokens: $completionTokens, totalTokens: $totalTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAIUsageImpl &&
            (identical(other.promptTokens, promptTokens) ||
                other.promptTokens == promptTokens) &&
            (identical(other.completionTokens, completionTokens) ||
                other.completionTokens == completionTokens) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, promptTokens, completionTokens, totalTokens);

  /// Create a copy of OpenAIUsage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAIUsageImplCopyWith<_$OpenAIUsageImpl> get copyWith =>
      __$$OpenAIUsageImplCopyWithImpl<_$OpenAIUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenAIUsageImplToJson(this);
  }
}

abstract class _OpenAIUsage implements OpenAIUsage {
  const factory _OpenAIUsage({
    @JsonKey(name: 'prompt_tokens') required final int promptTokens,
    @JsonKey(name: 'completion_tokens') required final int completionTokens,
    @JsonKey(name: 'total_tokens') required final int totalTokens,
  }) = _$OpenAIUsageImpl;

  factory _OpenAIUsage.fromJson(Map<String, dynamic> json) =
      _$OpenAIUsageImpl.fromJson;

  @override
  @JsonKey(name: 'prompt_tokens')
  int get promptTokens;
  @override
  @JsonKey(name: 'completion_tokens')
  int get completionTokens;
  @override
  @JsonKey(name: 'total_tokens')
  int get totalTokens;

  /// Create a copy of OpenAIUsage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAIUsageImplCopyWith<_$OpenAIUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
