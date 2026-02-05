class NotificationModel{
  final int id;
  final String title;
  final String message;
  bool isRead;
  final DateTime createdAt;

 NotificationModel({
  required this.id,
  required this.title,
  required this.message,
  required this.isRead,
  required this.createdAt,

 });
factory NotificationModel.fromJson(Map<String,dynamic>json){
  return NotificationModel(
    id:json['id'],
    title: json['title'],
    message: json['message'],
    isRead: json['is_read'],
    createdAt: DateTime.parse(json['created_at'])

  );
 }
}