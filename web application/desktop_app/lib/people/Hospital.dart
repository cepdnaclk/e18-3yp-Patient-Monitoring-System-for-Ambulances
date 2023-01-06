class Hospital {
  late String name;
  late String id;
  late String lat;
  late String long;
  late String contactNumber;

  Hospital(this.name, this.id, this.lat, this.long, this.contactNumber);
  Hospital.empty() : this('none', 'none', '0.0', '0.0', 'none');
  Hospital.fromJson(Map<String, dynamic> json)
      : name = json['HospitalName'],
        id = json['HospitalID'],
        lat = json['Lattitude'],
        long = json['Longitude'],
        contactNumber = json['ContactNo'];

  // Map<String, dynamic> toJson() => {
  //   'name': name,
  //   'age': age,
  //   'condition': condition
  // };

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return '{name:$name, age:$age,condition:$condition, temperature:$temperature, heartRate:$heartRate, pulseRate:$pulseRate,oxySat:$oxygenSaturation}';
  // }
}
