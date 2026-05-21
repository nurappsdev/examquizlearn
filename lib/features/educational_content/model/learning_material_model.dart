import 'dart:convert';

class LearningMaterialModel {
  final String? id;
  final bool? isActive;
  final String? status;
  final dynamic createdBy;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final String? topicId;
  final String? contentType;
  final ContentData? contentData;
  final int? orderIndex;
  final String? processingStatus;
  final int? durationSec;
  final int? v;

  LearningMaterialModel({
    this.id,
    this.isActive,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.topicId,
    this.contentType,
    this.contentData,
    this.orderIndex,
    this.processingStatus,
    this.durationSec,
    this.v,
  });

  factory LearningMaterialModel.fromRawJson(String str) =>
      LearningMaterialModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LearningMaterialModel.fromJson(Map<String, dynamic> json) =>
      LearningMaterialModel(
        id: json["_id"],
        isActive: json["isActive"],
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"],
        topicId: json["topicId"],
        contentType: json["contentType"],
        contentData: json["contentData"] == null
            ? null
            : ContentData.fromJson(json["contentData"]),
        orderIndex: json["orderIndex"],
        processingStatus: json["processingStatus"],
        durationSec: json["durationSec"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isActive": isActive,
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "deletedAt": deletedAt,
        "topicId": topicId,
        "contentType": contentType,
        "contentData": contentData?.toJson(),
        "orderIndex": orderIndex,
        "processingStatus": processingStatus,
        "durationSec": durationSec,
        "__v": v,
      };
}

class ContentData {
  final String? text;
  final String? title;
  final String? url;
  final String? s3Key;
  final String? originalS3Key;
  final String? hls;
  final String? thumbnail;
  final List<String>? variants;
  final Metadata? metadata;

  ContentData({
    this.text,
    this.title,
    this.url,
    this.s3Key,
    this.originalS3Key,
    this.hls,
    this.thumbnail,
    this.variants,
    this.metadata,
  });

  factory ContentData.fromRawJson(String str) =>
      ContentData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContentData.fromJson(Map<String, dynamic> json) => ContentData(
        text: json["text"],
        title: json["title"],
        url: json["url"],
        s3Key: json["s3Key"],
        originalS3Key: json["originalS3Key"],
        hls: json["hls"],
        thumbnail: json["thumbnail"],
        variants: json["variants"] == null
            ? []
            : List<String>.from(json["variants"]!.map((x) => x)),
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "title": title,
        "url": url,
        "s3Key": s3Key,
        "originalS3Key": originalS3Key,
        "hls": hls,
        "thumbnail": thumbnail,
        "variants":
            variants == null ? [] : List<dynamic>.from(variants!.map((x) => x)),
        "metadata": metadata?.toJson(),
      };
}

class Metadata {
  final double? duration;
  final int? width;
  final int? height;
  final String? codec;
  final int? bitrate;
  final double? fps;

  Metadata({
    this.duration,
    this.width,
    this.height,
    this.codec,
    this.bitrate,
    this.fps,
  });

  factory Metadata.fromRawJson(String str) =>
      Metadata.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        duration: json["duration"]?.toDouble(),
        width: json["width"],
        height: json["height"],
        codec: json["codec"],
        bitrate: json["bitrate"],
        fps: json["fps"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "width": width,
        "height": height,
        "codec": codec,
        "bitrate": bitrate,
        "fps": fps,
      };
}
