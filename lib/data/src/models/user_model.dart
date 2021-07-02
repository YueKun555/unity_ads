class UserModel {
  String uuid;

  int energy;

  int money;

  String weight;

  UserModel({
    this.uuid,
    this.energy,
    this.money,
    this.weight,
  });

  static UserModel formJson({Map<String, dynamic> json}) {
    return UserModel(
      uuid: json['uuid'],
      energy: json['energy'],
      money: json['money'],
      weight: json['weight'],
    );
  }
}
