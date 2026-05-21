
class GetUserModel {
  final String? id;
  final dynamic deletedAt;
  final String? email;
  final String? phoneNumber;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? employment;
  final String? education;
  final String? university;
  final String? linkedinUrl;
  final int? totalScore;
  final bool? isEmailVerified;
  final bool? isTcPpAccepted;
  final DateTime? emailVerifiedAt;
  final String? activePlanId;
  final String? subscriptionStatus;
  final DateTime? accessExpiresAt;
  final String? role;
  final dynamic lastLoginAt;
  final int? v;

  GetUserModel({
    this.id,
    this.deletedAt,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.employment,
    this.education,
    this.university,
    this.linkedinUrl,
    this.totalScore,
    this.isEmailVerified,
    this.isTcPpAccepted,
    this.emailVerifiedAt,
    this.activePlanId,
    this.subscriptionStatus,
    this.accessExpiresAt,
    this.role,
    this.lastLoginAt,
    this.v,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) => GetUserModel(
    id: json["_id"],
    deletedAt: json["deletedAt"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    fullName: json["fullName"],
    avatarUrl: json["avatarUrl"],
    dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
    gender: json["gender"],
    employment: json["employment"],
    education: json["education"],
    university: json["university"],
    linkedinUrl: json["linkedinUrl"],
    totalScore: json["totalScore"],
    isEmailVerified: json["isEmailVerified"],
    isTcPpAccepted: json["isTcPpAccepted"],
    emailVerifiedAt: json["emailVerifiedAt"] == null ? null : DateTime.parse(json["emailVerifiedAt"]),
    activePlanId: json["activePlanId"],
    subscriptionStatus: json["subscriptionStatus"],
    accessExpiresAt: json["accessExpiresAt"] == null ? null : DateTime.parse(json["accessExpiresAt"]),
    role: json["role"],
    lastLoginAt: json["lastLoginAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "deletedAt": deletedAt,
    "email": email,
    "phoneNumber": phoneNumber,
    "fullName": fullName,
    "avatarUrl": avatarUrl,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "gender": gender,
    "employment": employment,
    "education": education,
    "university": university,
    "linkedinUrl": linkedinUrl,
    "totalScore": totalScore,
    "isEmailVerified": isEmailVerified,
    "isTcPpAccepted": isTcPpAccepted,
    "emailVerifiedAt": emailVerifiedAt?.toIso8601String(),
    "activePlanId": activePlanId,
    "subscriptionStatus": subscriptionStatus,
    "accessExpiresAt": accessExpiresAt?.toIso8601String(),
    "role": role,
    "lastLoginAt": lastLoginAt,
    "__v": v,
  };
}
