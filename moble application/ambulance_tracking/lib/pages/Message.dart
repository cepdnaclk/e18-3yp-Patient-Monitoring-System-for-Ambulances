class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message(this.text, this.date, this.isSentByMe);
  Message.fromJson(Map<String, dynamic> json, this.date, this.isSentByMe)
      : text = json['message'];

  Map<String, dynamic> toJson() =>
      {'message': text, 'date': date, 'isSentByMe': isSentByMe};
}
