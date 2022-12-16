class Message{
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message(this.text, this.date, this.isSentByMe);
  Message.fromJson(Map<String, dynamic> json, this.date, this.isSentByMe)
      :text = json['message'];

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['message'] = this.text;
  //   data['date'] = this.date;
  //   data['isSentByMe'] = this.isSentByMe;
  //   return data;
  // }

  Map<String, dynamic> toJson() => {
    'message': text,
    'date': date,
    'isSentByMe': isSentByMe
  };

}