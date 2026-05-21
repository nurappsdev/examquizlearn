class NotificationModel {
  final String? id;
  final bool? isActive;
  final String? status;
  final String? recipientId;
  final String? recipientType;
  final String? deliveryMethod;
  final String? category;
  final String? title;
  final String? body;
  final NotificationMetadata? metadata;
  final bool? isRead;
  final DateTime? readAt;
  final DateTime? deliveredAt;

  NotificationModel({
    this.id,
    this.isActive,
    this.status,
    this.recipientId,
    this.recipientType,
    this.deliveryMethod,
    this.category,
    this.title,
    this.body,
    this.metadata,
    this.isRead,
    this.readAt,
    this.deliveredAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["_id"],
    isActive: json["isActive"],
    status: json["status"],
    recipientId: json["recipientId"],
    recipientType: json["recipientType"],
    deliveryMethod: json["deliveryMethod"],
    category: json["category"],
    title: json["title"],
    body: json["body"],
    metadata: json["metadata"] == null ? null : NotificationMetadata.fromJson(json["metadata"]),
    isRead: json["isRead"],
    readAt: json["readAt"] == null ? null : DateTime.parse(json["readAt"]),
    deliveredAt: json["deliveredAt"] == null ? null : DateTime.parse(json["deliveredAt"]),
  );
}

class NotificationMetadata {
  final String? deepLink;
  final String? screen;
  final String? page;
  final String? relatedType;
  final String? relatedId;

  NotificationMetadata({
    this.deepLink,
    this.screen,
    this.page,
    this.relatedType,
    this.relatedId,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) => NotificationMetadata(
    deepLink: json["deepLink"],
    screen: json["screen"],
    page: json["page"],
    relatedType: json["relatedType"],
    relatedId: json["relatedId"],
  );
}
