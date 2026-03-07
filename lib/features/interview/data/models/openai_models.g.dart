// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenAIRequestImpl _$$OpenAIRequestImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIRequestImpl(
      model: json['model'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => OpenAIMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['max_tokens'] as num?)?.toInt() ?? 2000,
    );

Map<String, dynamic> _$$OpenAIRequestImplToJson(_$OpenAIRequestImpl instance) =>
    <String, dynamic>{
      'model': instance.model,
      'messages': instance.messages,
      'temperature': instance.temperature,
      'max_tokens': instance.maxTokens,
    };

_$OpenAIMessageImpl _$$OpenAIMessageImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIMessageImpl(
      role: json['role'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$OpenAIMessageImplToJson(_$OpenAIMessageImpl instance) =>
    <String, dynamic>{'role': instance.role, 'content': instance.content};

_$OpenAIResponseImpl _$$OpenAIResponseImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIResponseImpl(
      id: json['id'] as String,
      object: json['object'] as String,
      created: (json['created'] as num).toInt(),
      model: json['model'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => OpenAIChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      usage: OpenAIUsage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpenAIResponseImplToJson(
  _$OpenAIResponseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'object': instance.object,
  'created': instance.created,
  'model': instance.model,
  'choices': instance.choices,
  'usage': instance.usage,
};

_$OpenAIChoiceImpl _$$OpenAIChoiceImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIChoiceImpl(
      index: (json['index'] as num).toInt(),
      message: OpenAIMessage.fromJson(json['message'] as Map<String, dynamic>),
      finishReason: json['finish_reason'] as String?,
    );

Map<String, dynamic> _$$OpenAIChoiceImplToJson(_$OpenAIChoiceImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'message': instance.message,
      'finish_reason': instance.finishReason,
    };

_$OpenAIUsageImpl _$$OpenAIUsageImplFromJson(Map<String, dynamic> json) =>
    _$OpenAIUsageImpl(
      promptTokens: (json['prompt_tokens'] as num).toInt(),
      completionTokens: (json['completion_tokens'] as num).toInt(),
      totalTokens: (json['total_tokens'] as num).toInt(),
    );

Map<String, dynamic> _$$OpenAIUsageImplToJson(_$OpenAIUsageImpl instance) =>
    <String, dynamic>{
      'prompt_tokens': instance.promptTokens,
      'completion_tokens': instance.completionTokens,
      'total_tokens': instance.totalTokens,
    };
