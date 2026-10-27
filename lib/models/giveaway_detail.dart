// To parse this JSON data, do
//
//     final giweawayDetail = giweawayDetailFromJson(jsonString);

import 'dart:convert';

GiweawayDetail giweawayDetailFromJson(String str) => GiweawayDetail.fromJson(json.decode(str));

String giweawayDetailToJson(GiweawayDetail data) => json.encode(data.toJson());

class GiweawayDetail {
    final int id;
    final String title;
    final String worth;
    final String thumbnail;
    final String image;
    final String description;
    final String instructions;
    final String openGiveawayUrl;
    final String publishedDate;
    final String type;
    final String platforms;
    final String endDate;
    final int users;
    final String status;
    final String gamerpowerUrl;

    GiweawayDetail({
        required this.id,
        required this.title,
        required this.worth,
        required this.thumbnail,
        required this.image,
        required this.description,
        required this.instructions,
        required this.openGiveawayUrl,
        required this.publishedDate,
        required this.type,
        required this.platforms,
        required this.endDate,
        required this.users,
        required this.status,
        required this.gamerpowerUrl,
    });

    factory GiweawayDetail.fromJson(Map<String, dynamic> json) => GiweawayDetail(
        id: json["id"],
        title: json["title"],
        worth: json["worth"],
        thumbnail: json["thumbnail"],
        image: json["image"],
        description: json["description"],
        instructions: json["instructions"],
        openGiveawayUrl: json["open_giveaway_url"],
        publishedDate: json["published_date"],
        type: json["type"],
        platforms: json["platforms"],
        endDate: json["end_date"],
        users: json["users"],
        status: json["status"],
        gamerpowerUrl: json["gamerpower_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "worth": worth,
        "thumbnail": thumbnail,
        "image": image,
        "description": description,
        "instructions": instructions,
        "open_giveaway_url": openGiveawayUrl,
        "published_date": publishedDate,
        "type": type,
        "platforms": platforms,
        "end_date": endDate,
        "users": users,
        "status": status,
        "gamerpower_url": gamerpowerUrl,
    };
}
