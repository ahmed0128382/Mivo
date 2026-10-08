
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
  print('');
  print('========== MESSAGE FROM JSON ==========');
  print('RAW MESSAGE JSON: $json');

  id = int.tryParse(json['id']?.toString() ?? '');
  message = json['message']?.toString();
  deletestate = int.tryParse(json['deletestate']?.toString() ?? '');
  userId = int.tryParse(json['user_id']?.toString() ?? '');
  inboxroomId = int.tryParse(json['Inboxroom_id']?.toString() ?? '');
  senderId = int.tryParse(json['sender_id']?.toString() ?? '');
  status = int.tryParse(json['status']?.toString() ?? '');
  createdAt = json['created_at']?.toString();
  updatedAt = json['updated_at']?.toString();

  print('PARSED ID: $id');
  print('PARSED USER ID: $userId');
  print('PARSED SENDER ID: $senderId');
  print('PARSED INBOX ID: $inboxroomId');
  print('PARSED MESSAGE: $message');
  print('PARSED STATUS: $status');
  print('=======================================');
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