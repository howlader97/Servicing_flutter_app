class FaqModel {
  final bool success;
  final String message;
  final FaqData data;

  FaqModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: FaqData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FaqData {
  final List<Faq> faqs;

  FaqData({
    required this.faqs,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      faqs: (json['faqs'] as List? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'faqs': faqs.map((e) => e.toJson()).toList(),
    };
  }
}

class Faq {
  final String id;
  final String question;
  final String answer;
  final int order;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
    required this.order,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'order': order,
    };
  }
}