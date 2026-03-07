import 'package:freezed_annotation/freezed_annotation.dart';

part 'openai_models.freezed.dart';
part 'openai_models.g.dart';

/// OpenAI Chat Completion Request
@freezed
class OpenAIRequest with _$OpenAIRequest {
  const factory OpenAIRequest({
    required String model,
    required List<OpenAIMessage> messages,
    @Default(0.7) double temperature,
    @JsonKey(name: 'max_tokens') @Default(2000) int maxTokens,
  }) = _OpenAIRequest;

  factory OpenAIRequest.fromJson(Map<String, dynamic> json) =>
      _$OpenAIRequestFromJson(json);
}

/// OpenAI Chat Message
@freezed
class OpenAIMessage with _$OpenAIMessage {
  const factory OpenAIMessage({
    required String role,
    required String content,
  }) = _OpenAIMessage;

  factory OpenAIMessage.fromJson(Map<String, dynamic> json) =>
      _$OpenAIMessageFromJson(json);
}

/// OpenAI Chat Completion Response
@freezed
class OpenAIResponse with _$OpenAIResponse {
  const factory OpenAIResponse({
    required String id,
    required String object,
    required int created,
    required String model,
    required List<OpenAIChoice> choices,
    required OpenAIUsage usage,
  }) = _OpenAIResponse;

  factory OpenAIResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenAIResponseFromJson(json);
}

/// OpenAI Choice
@freezed
class OpenAIChoice with _$OpenAIChoice {
  const factory OpenAIChoice({
    required int index,
    required OpenAIMessage message,
    @JsonKey(name: 'finish_reason') String? finishReason,
  }) = _OpenAIChoice;

  factory OpenAIChoice.fromJson(Map<String, dynamic> json) =>
      _$OpenAIChoiceFromJson(json);
}

/// OpenAI Token Usage
@freezed
class OpenAIUsage with _$OpenAIUsage {
  const factory OpenAIUsage({
    @JsonKey(name: 'prompt_tokens') required int promptTokens,
    @JsonKey(name: 'completion_tokens') required int completionTokens,
    @JsonKey(name: 'total_tokens') required int totalTokens,
  }) = _OpenAIUsage;

  factory OpenAIUsage.fromJson(Map<String, dynamic> json) =>
      _$OpenAIUsageFromJson(json);
}
