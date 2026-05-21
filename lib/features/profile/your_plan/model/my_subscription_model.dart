class MySubscription {
  final String? id;
  final String? status;
  final bool? isActive;
  final double? amountPaid;
  final String? currency;
  final DateTime? startedAt;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? expiresAt;
  final DateTime? cancellationRequestedAt;
  final DateTime? cancelledAt;
  final String? paymentProvider;
  final String? paymentRef;
  final SubscriptionPlanInfo? plan;

  MySubscription({
    this.id,
    this.status,
    this.isActive,
    this.amountPaid,
    this.currency,
    this.startedAt,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.expiresAt,
    this.cancellationRequestedAt,
    this.cancelledAt,
    this.paymentProvider,
    this.paymentRef,
    this.plan,
  });

  bool get isTrialing => (status ?? '').toLowerCase() == 'trialing';
  bool get isCancellationRequested => cancellationRequestedAt != null;

  int get daysRemaining {
    final end = expiresAt ?? currentPeriodEnd;
    if (end == null) return 0;
    final diff = end.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  factory MySubscription.fromJson(Map<String, dynamic> json) {
    final planField = json['planId'];
    SubscriptionPlanInfo? plan;
    if (planField is Map) {
      plan =
          SubscriptionPlanInfo.fromJson(Map<String, dynamic>.from(planField));
    }

    return MySubscription(
      id: json['_id']?.toString(),
      status: json['status']?.toString(),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : null,
      amountPaid: _toDouble(json['amountPaid']),
      currency: json['currency']?.toString(),
      startedAt: _toDate(json['startedAt']),
      currentPeriodStart: _toDate(json['currentPeriodStart']),
      currentPeriodEnd: _toDate(json['currentPeriodEnd']),
      expiresAt: _toDate(json['expiresAt']),
      cancellationRequestedAt: _toDate(json['cancellationRequestedAt']),
      cancelledAt: _toDate(json['cancelledAt']),
      paymentProvider: json['paymentProvider']?.toString(),
      paymentRef: json['paymentRef']?.toString(),
      plan: plan,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }
}

class SubscriptionPlanInfo {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final String? planType;
  final String? billingInterval;
  final int? billingIntervalCount;
  final int? durationDays;
  final int? trialPeriodDays;
  final double? price;
  final String? currency;
  final bool? hasAllAccess;

  SubscriptionPlanInfo({
    this.id,
    this.code,
    this.name,
    this.description,
    this.planType,
    this.billingInterval,
    this.billingIntervalCount,
    this.durationDays,
    this.trialPeriodDays,
    this.price,
    this.currency,
    this.hasAllAccess,
  });

  factory SubscriptionPlanInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanInfo(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      planType: json['planType']?.toString(),
      billingInterval: json['billingInterval']?.toString(),
      billingIntervalCount: _toInt(json['billingIntervalCount']),
      durationDays: _toInt(json['durationDays']),
      trialPeriodDays: _toInt(json['trialPeriodDays']),
      price: MySubscription._toDouble(json['price']),
      currency: json['currency']?.toString(),
      hasAllAccess: json['hasAllAccess'] is bool
          ? json['hasAllAccess'] as bool
          : null,
    );
  }

  String get displayName {
    final n = name?.trim();
    if (n != null && n.isNotEmpty) return n;
    final c = code?.trim();
    if (c != null && c.isNotEmpty) return c;
    return 'Subscription';
  }

  String get billingLabel {
    final p = price ?? 0;
    if (p <= 0) {
      final trial = trialPeriodDays ?? 0;
      return trial > 0 ? '$trial day trial' : 'Free';
    }
    final interval = billingInterval ?? 'month';
    final count = billingIntervalCount ?? 1;
    return count > 1 ? '/ $count ${interval}s' : '/ $interval';
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
