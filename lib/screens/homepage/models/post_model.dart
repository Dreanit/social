// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  EventLocation? eventLocation;
  String? id;
  String? userId;
  String? description;
  String? title;
  List<String>? image;
  List<dynamic>? tags;
  String? eventCategory;
  String? eventStartAt;
  String? eventEndAt;
  String? eventId;
  String? eventDescription;
  int? likes;
  int? noOfComments;
  List<String>? likedUsers;
  List<dynamic>? comments;
  DateTime? createdAt;
  int? v;
  bool? registrationRequired;
  List<dynamic>? registration;
bool liked=false;
  PostModel({
    this.eventLocation,
    this.id,
    this.userId,
    this.description,
    this.title,
    this.image,
    this.tags,
    this.eventCategory,
    this.eventStartAt,
    this.eventEndAt,
    this.eventId,
    this.eventDescription,
    this.likes,
    this.noOfComments,
    this.likedUsers,
    this.comments,
    this.createdAt,
    this.v,
    this.registrationRequired,
    this.registration,
  });
  void likePost() {
    liked=!liked;
    if(liked) {
      likes = (likes ?? 0) + 1; // Increment the like count
    }else{
      likes=(likes ?? 0) - 1;
    }
  }
  void addComment(String comment) {
    if (comments == null) {
      comments = [];
    }
    comments!.add({
      "user": "local",
      "isEdited": false,
      "text": comment,
      "likes": [],
      "_id": "63a4b8874a8d3389893d924a",
      "image": [],
      "createdAt": "2022-12-22T20:05:27.243Z",
      "replies": []
    }); // Add the comment to the list
  }
  factory PostModel.fromJson(Map<String, dynamic> json) {
    var data = json['image'].runtimeType == String
        ? jsonDecode(json["image"])
        : json["image"];
    var tag = json['tag'].runtimeType == String
        ? jsonDecode(json["tag"])
        : json["tag"];
    var likedusers = json['likedUsers'].runtimeType == String
        ? jsonDecode(json["likedUsers"])
        : json["likedUsers"];
    var comments = json['comments'].runtimeType == String
        ? jsonDecode(json["comments"])
        : json["comments"];
    return PostModel(
      id: json["_id"],
      userId: json["userId"],
      description: json["description"],
      title: json["title"],
      image: json["image"] == null ? [] : List<String>.from(data.map((x) => x)),
      tags:
          tag == "" || tag == null ? [] : List<dynamic>.from(tag.map((x) => x)),
      eventCategory: json["eventCategory"],
      eventStartAt: json["eventStartAt"],
      eventEndAt: json["eventEndAt"],
      eventId: json["eventId"],
      eventDescription: json["eventDescription"],
      likes: json["likes"],
      noOfComments: json["noOfComments"],
      likedUsers: likedusers == null || likedusers == ""
          ? []
          : List<String>.from(likedusers.map((x) => x)),
      comments: comments == null || comments == ""
          ? []
          : List<dynamic>.from(comments.map((x) => x)),
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      v: json["__v"],
      registrationRequired: json["registrationRequired"],
    );
  }

  Map<String, dynamic> toJson() => {
        "eventLocation": eventLocation?.toJson(),
        "_id": id,
        "userId": userId,
        "description": description,
        "title": title,
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "eventCategory": eventCategory,
        "eventStartAt": eventStartAt,
        "eventEndAt": eventEndAt,
        "eventId": eventId,
        "eventDescription": eventDescription,
        "likes": likes,
        "noOfComments": noOfComments,
        "likedUsers": likedUsers == null
            ? []
            : List<dynamic>.from(likedUsers!.map((x) => x)),
        "comments":
            comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
        "registrationRequired": registrationRequired,
        "registration": registration == null
            ? []
            : List<dynamic>.from(registration!.map((x) => x)),
      };
}

class EventLocation {
  String? type;
  List<double>? coordinates;

  EventLocation({
    this.type,
    this.coordinates,
  });

  factory EventLocation.fromJson(Map<String, dynamic> json) => EventLocation(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
