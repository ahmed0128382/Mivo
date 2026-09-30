
class Message {
  int? id;
  String? message;
  int? deletestate;
  int? userId;
  int? inboxroomId;
  int? senderId;

  int?status;
  String? createdAt;
  String? updatedAt;

  Message(
      {this.id,
        this.message,
        this.deletestate,
        this.userId,
        this.inboxroomId,
        this.senderId,
        this.status,
        this.createdAt,
        this.updatedAt});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    deletestate = json['deletestate'];
    userId =int.parse(json['user_id'].toString()) ;
    inboxroomId = json['Inboxroom_id'];
    senderId =int.parse(json['sender_id'].toString()) ;
    status =int.parse(json['status'].toString()) ;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['deletestate'] = this.deletestate;
    data['user_id'] = this.userId;
    data['Inboxroom_id'] = this.inboxroomId;
    data['sender_id'] = this.senderId;
    data['created_at'] = this.createdAt;
    data['status']=this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}