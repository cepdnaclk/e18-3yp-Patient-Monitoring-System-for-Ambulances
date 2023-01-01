class Patient {
  late String name;
  late int age;
  late String condition;
  late double temperature;
  late double heartRate;
  late double pulseRate;
  late double oxygenSaturation;
  late double lat;
  late double long;

  Patient(this.name, this.age, this.condition, this.temperature, this.heartRate,
      this.pulseRate, this.oxygenSaturation, this.lat, this.long);
  Patient.empty()
      : this('none', 0, 'none', 0.0, 0.0, 0.0, 0.0, 6.927079, 79.861244);
  Patient.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        heartRate = json['heart rate'],
        pulseRate = json['pulse rate'],
        oxygenSaturation = json['oxygen saturation'];

  healthData(Map<String, dynamic> json) {
    temperature = json['temperature'];
    heartRate = json['heart rate'];
    pulseRate = json['pulse rate'];
    oxygenSaturation = json['oxygen saturation'];
    lat = json['lat'];
    long = json['long'];
  }

  personalData(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    condition = json['condition'];
  }

  @override
  String toString() {
    return '{name:$name, age:$age,condition:$condition, temperature:$temperature, heartRate:$heartRate, pulseRate:$pulseRate,oxySat:$oxygenSaturation}';
  }
}
