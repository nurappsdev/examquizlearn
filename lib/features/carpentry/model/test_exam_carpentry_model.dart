
class TestExamCarpentryModel {
  final String? id;
  final bool? isActive;
  final dynamic deletedAt;
  final String? quizCode;
  final int? v;
  final dynamic createdBy;
  final int? instanceNumber;
  final int? passThresholdPct;
  final DateTime? publishedAt;
  final int? questionCount;
  final String? status;
  final TemplateId? templateId;
  final int? timeLimitSec;
  final String? title;
  final String? topicId;
  final dynamic updatedBy;

  TestExamCarpentryModel({
    this.id,
    this.isActive,
    this.deletedAt,
    this.quizCode,
    this.v,
    this.createdBy,
    this.instanceNumber,
    this.passThresholdPct,
    this.publishedAt,
    this.questionCount,
    this.status,
    this.templateId,
    this.timeLimitSec,
    this.title,
    this.topicId,
    this.updatedBy,
  });

  factory TestExamCarpentryModel.fromJson(Map<String, dynamic> json) => TestExamCarpentryModel(
    id: json["_id"],
    isActive: json["isActive"],
    deletedAt: json["deletedAt"],
    quizCode: json["quizCode"],
    v: json["__v"],
    createdBy: json["createdBy"],
    instanceNumber: json["instanceNumber"],
    passThresholdPct: json["passThresholdPct"],
    publishedAt: json["publishedAt"] == null ? null : DateTime.parse(json["publishedAt"]),
    questionCount: json["questionCount"],
    status: json["status"],
    templateId: json["templateId"] == null ? null : TemplateId.fromJson(json["templateId"]),
    timeLimitSec: json["timeLimitSec"],
    title: json["title"],
    topicId: json["topicId"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive,
    "deletedAt": deletedAt,
    "quizCode": quizCode,
    "__v": v,
    "createdBy": createdBy,
    "instanceNumber": instanceNumber,
    "passThresholdPct": passThresholdPct,
    "publishedAt": publishedAt?.toIso8601String(),
    "questionCount": questionCount,
    "status": status,
    "templateId": templateId?.toJson(),
    "timeLimitSec": timeLimitSec,
    "title": title,
    "topicId": topicId,
    "updatedBy": updatedBy,
  };
}

class TemplateId {
  final String? id;
  final String? codePrefix;
  final bool? allowRepeats;
  final DifficultyCounts? difficultyCounts;
  final int? questionCount;
  final String? questionType;
  final String? selectionLogic;

  TemplateId({
    this.id,
    this.codePrefix,
    this.allowRepeats,
    this.difficultyCounts,
    this.questionCount,
    this.questionType,
    this.selectionLogic,
  });

  factory TemplateId.fromJson(Map<String, dynamic> json) => TemplateId(
    id: json["_id"],
    codePrefix: json["codePrefix"],
    allowRepeats: json["allowRepeats"],
    difficultyCounts: json["difficultyCounts"] == null ? null : DifficultyCounts.fromJson(json["difficultyCounts"]),
    questionCount: json["questionCount"],
    questionType: json["questionType"],
    selectionLogic: json["selectionLogic"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "codePrefix": codePrefix,
    "allowRepeats": allowRepeats,
    "difficultyCounts": difficultyCounts?.toJson(),
    "questionCount": questionCount,
    "questionType": questionType,
    "selectionLogic": selectionLogic,
  };
}

class DifficultyCounts {
  final int? easy;
  final int? moderate;
  final int? hard;

  DifficultyCounts({
    this.easy,
    this.moderate,
    this.hard,
  });

  factory DifficultyCounts.fromJson(Map<String, dynamic> json) => DifficultyCounts(
    easy: json["easy"],
    moderate: json["moderate"],
    hard: json["hard"],
  );

  Map<String, dynamic> toJson() => {
    "easy": easy,
    "moderate": moderate,
    "hard": hard,
  };
}
