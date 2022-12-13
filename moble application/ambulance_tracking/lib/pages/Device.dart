class Device {
  final int ID;


  Device(this.ID);
  Device.empty() : this(0);
  Device.fromJson(Map<String, dynamic> json)
      :temperature = json['temperature'],
        heartRate = json['heart rate'],
        pulseRate = json['pulse rate'],
        oxygenSaturation = json['oxygen saturation'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'condition': condition
  };

  @override
  String toString() {
    // TODO: implement toString
    return '{userID:$name, password:$age}';
  }


}