class Patient {
  String name;
  int age;
  double temperature;
  double heartRate;
  double pulseRate;
  double oxygenSaturation;
  String condition;

  Patient(this.name, this.age, this.condition, this.temperature, this.heartRate,
      this.pulseRate, this.oxygenSaturation);
  //Patient.empty() : this('none', 0, 'none', 0.0, 0.0, 0.0, 0.0);
  Patient.fromJson(Map<String, dynamic> json)
      : temperature = json['temperature'],
        heartRate = json['heart rate'],
        pulseRate = json['pulse rate'],
        oxygenSaturation = json['oxygen saturation'],
        name = json['name'],
        age = json['age'],
        condition = json['condition'];

  // Map<String, dynamic> toJson() => {
  //   'name': name,
  //   'age': age,
  //   'condition': condition
  // };

  @override
  String toString() {
    // TODO: implement toString
    return '{name:$name, age:$age,condition:$condition, temperature:$temperature, heartRate:$heartRate, pulseRate:$pulseRate,oxySat:$oxygenSaturation}';
  }
}
