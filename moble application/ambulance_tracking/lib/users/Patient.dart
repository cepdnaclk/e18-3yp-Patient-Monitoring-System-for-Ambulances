class Patient {
  late String name;
  late int age;
  final double temperature;
  final double heartRate;
  final double pulseRate;
  final double oxygenSaturation;
  late String condition;

  Patient(this.name, this.age, this.condition, this.temperature, this.heartRate,
      this.pulseRate, this.oxygenSaturation);
  Patient.empty() : this('none', 0, 'none', 0.0, 0.0, 0.0, 0.0);
  Patient.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        heartRate = json['heart rate'],
        pulseRate = json['pulse rate'],
        oxygenSaturation = json['oxygen saturation'];

  @override
  String toString() {
    // TODO: implement toString
    return '{name:$name, age:$age,condition:$condition, temperature:$temperature, heartRate:$heartRate, pulseRate:$pulseRate,oxySat:$oxygenSaturation}';
  }
}
