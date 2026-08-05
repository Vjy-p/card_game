import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? displayName;
  String? email;
  String? photoUrl;
  int? coins;
  int? level;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? notificationTopic;
  int? gamesPlayed;
  int? gamesWon;
  int? totalScore;
  int? totalPoints;
  int? firstPlace;
  int? secondPlace;
  int? thirdPlace;
  int? longestWinStreak;
  int? currentWinStreak;

  UserModel({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.coins,
    this.level,
    this.createdAt,
    this.updatedAt,
    this.notificationTopic,
    this.gamesPlayed,
    this.gamesWon,
    this.totalScore,
    this.totalPoints,
    this.firstPlace,
    this.secondPlace,
    this.thirdPlace,
    this.longestWinStreak,
    this.currentWinStreak,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    displayName: json['display_name'],
    email: json['email'],
    photoUrl: json['photo_url'],
    coins: json['coins'],
    level: json['level'],
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at']),
    notificationTopic: json['notification_topic'],
    gamesPlayed: json['games_played'],
    gamesWon: json['games_won'],
    totalScore: json['total_score'],
    totalPoints: json['total_points'],
    firstPlace: json['first_place'],
    secondPlace: json['second_place'],
    thirdPlace: json['third_place'],
    longestWinStreak: json['longest_win_streak'],
    currentWinStreak: json['current_win_streak'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'email': email,
    'photo_url': photoUrl,
    'coins': coins,
    'level': level,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'notification_topic': notificationTopic,
    'games_played': gamesPlayed,
    'games_won': gamesWon,
    'total_score': totalScore,
    'total_points': totalPoints,
    'first_place': firstPlace,
    'second_place': secondPlace,
    'third_place': thirdPlace,
    'longest_win_streak': longestWinStreak,
    'current_win_streak': currentWinStreak,
  };
}
