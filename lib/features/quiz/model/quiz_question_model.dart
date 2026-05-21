// To parse this JSON data, do
//
//     final testExamQuizModel = testExamQuizModelFromJson(jsonString);

import 'dart:convert';

TestExamQuizModel testExamQuizModelFromJson(String str) =>
    TestExamQuizModel.fromJson(json.decode(str));

String testExamQuizModelToJson(TestExamQuizModel data) =>
    json.encode(data.toJson());

class TestExamQuizResponseModel {
  final List<TestExamQuizModel>? data;
  final QuizQuestionPaginationModel? pagination;

  TestExamQuizResponseModel({this.data, this.pagination});

  factory TestExamQuizResponseModel.fromJson(dynamic json) {
    if (json is List) {
      return TestExamQuizResponseModel(
        data: List<TestExamQuizModel>.from(
          json.map((x) => TestExamQuizModel.fromJson(x)),
        ),
      );
    }

    if (json is Map<String, dynamic>) {
      if (json.containsKey("_id") && json.containsKey("question")) {
        return TestExamQuizResponseModel(
          data: [TestExamQuizModel.fromJson(json)],
        );
      }

      final dynamic dataJson = _extractQuestionListJson(json);
      return TestExamQuizResponseModel(
        data: dataJson is List
            ? List<TestExamQuizModel>.from(
                dataJson.map((x) => TestExamQuizModel.fromJson(x)),
              )
            : null,
        pagination: json["pagination"] == null
            ? null
            : QuizQuestionPaginationModel.fromJson(json["pagination"]),
      );
    }

    return TestExamQuizResponseModel(data: const []);
  }

  static dynamic _extractQuestionListJson(Map<String, dynamic> json) {
    for (final key in const ["data", "questions", "results", "items", "docs"]) {
      final value = json[key];
      if (value is List) {
        return value;
      }

      if (value is Map<String, dynamic>) {
        if (value.containsKey("_id") && value.containsKey("question")) {
          return [value];
        }

        final nestedValue = _extractQuestionListJson(value);
        if (nestedValue is List) {
          return nestedValue;
        }
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class QuizQuestionPaginationModel {
  final int? currentPage;
  final int? totalItems;
  final int? totalPages;
  final int? nextPage;
  final dynamic previousPage;
  final int? itemsPerPage;

  QuizQuestionPaginationModel({
    this.currentPage,
    this.totalItems,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.itemsPerPage,
  });

  factory QuizQuestionPaginationModel.fromJson(Map<String, dynamic> json) =>
      QuizQuestionPaginationModel(
        currentPage: json["currentPage"],
        totalItems: json["totalItems"],
        totalPages: json["totalPages"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        itemsPerPage: json["itemsPerPage"],
      );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalItems": totalItems,
    "totalPages": totalPages,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "itemsPerPage": itemsPerPage,
  };
}

class TestExamQuizModel {
  final String? id;
  final bool? isActive;
  final String? status;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final String? quizId;
  final String? questionId;
  final int? orderIndex;
  final int? points;
  final String? difficultySnapshot;
  final String? questionTypeSnapshot;
  final int? v;
  final Question? question;

  TestExamQuizModel({
    this.id,
    this.isActive,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.quizId,
    this.questionId,
    this.orderIndex,
    this.points,
    this.difficultySnapshot,
    this.questionTypeSnapshot,
    this.v,
    this.question,
  });

  factory TestExamQuizModel.fromJson(Map<String, dynamic> json) =>
      TestExamQuizModel(
        id: json["_id"],
        isActive: json["isActive"],
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"],
        quizId: json["quizId"],
        questionId: json["questionId"],
        orderIndex: json["orderIndex"],
        points: json["points"],
        difficultySnapshot: json["difficultySnapshot"],
        questionTypeSnapshot: json["questionTypeSnapshot"],
        v: json["__v"],
        question: json["question"] == null
            ? null
            : Question.fromJson(json["question"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive,
    "status": status,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deletedAt": deletedAt,
    "quizId": quizId,
    "questionId": questionId,
    "orderIndex": orderIndex,
    "points": points,
    "difficultySnapshot": difficultySnapshot,
    "questionTypeSnapshot": questionTypeSnapshot,
    "__v": v,
    "question": question?.toJson(),
  };
}

class Question {
  final String? id;
  final String? externalId;
  final dynamic deletedAt;
  final bool? isActive;
  final String? sourceFile;
  final int? v;
  final String? content;
  final String? contentHash;
  final dynamic createdBy;
  final String? difficulty;
  final String? rationale;
  final String? sourceHash;
  final String? status;
  final String? subtopic;
  final String? topicId;
  final String? trapExplanation;
  final String? type;
  final dynamic updatedBy;
  final List<Option>? options;

  Question({
    this.id,
    this.externalId,
    this.deletedAt,
    this.isActive,
    this.sourceFile,
    this.v,
    this.content,
    this.contentHash,
    this.createdBy,
    this.difficulty,
    this.rationale,
    this.sourceHash,
    this.status,
    this.subtopic,
    this.topicId,
    this.trapExplanation,
    this.type,
    this.updatedBy,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["_id"],
    externalId: json["externalId"],
    deletedAt: json["deletedAt"],
    isActive: json["isActive"],
    sourceFile: json["sourceFile"],
    v: json["__v"],
    content: json["content"],
    contentHash: json["contentHash"],
    createdBy: json["createdBy"],
    difficulty: json["difficulty"],
    rationale: json["rationale"],
    sourceHash: json["sourceHash"],
    status: json["status"],
    subtopic: json["subtopic"],
    topicId: json["topicId"],
    trapExplanation: json["trapExplanation"],
    type: json["type"],
    updatedBy: json["updatedBy"],
    options: json["options"] == null
        ? []
        : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "externalId": externalId,
    "deletedAt": deletedAt,
    "isActive": isActive,
    "sourceFile": sourceFile,
    "__v": v,
    "content": content,
    "contentHash": contentHash,
    "createdBy": createdBy,
    "difficulty": difficulty,
    "rationale": rationale,
    "sourceHash": sourceHash,
    "status": status,
    "subtopic": subtopic,
    "topicId": topicId,
    "trapExplanation": trapExplanation,
    "type": type,
    "updatedBy": updatedBy,
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  final String? id;
  final bool? isActive;
  final String? status;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final String? questionId;
  final String? optionLabel;
  final String? content;
  final bool? isCorrect;
  final int? orderIndex;
  final int? v;

  Option({
    this.id,
    this.isActive,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.questionId,
    this.optionLabel,
    this.content,
    this.isCorrect,
    this.orderIndex,
    this.v,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["_id"],
    isActive: json["isActive"],
    status: json["status"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deletedAt: json["deletedAt"],
    questionId: json["questionId"],
    optionLabel: json["optionLabel"],
    content: json["content"],
    isCorrect: json["isCorrect"],
    orderIndex: json["orderIndex"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive,
    "status": status,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deletedAt": deletedAt,
    "questionId": questionId,
    "optionLabel": optionLabel,
    "content": content,
    "isCorrect": isCorrect,
    "orderIndex": orderIndex,
    "__v": v,
  };
}
