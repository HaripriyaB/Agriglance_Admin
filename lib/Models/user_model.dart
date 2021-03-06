class UserModel {
  final String id;
  final String fullName;
  final String email;
  final bool isAdmin;
  final bool isBanned;
  final String dob;
  final String qualification;
  final String university;
  final int points;

  UserModel(this.id, this.fullName, this.email, this.isAdmin, this.dob,
      this.points, this.qualification, this.university,this.isBanned);

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        isAdmin = data['isAdmin'],
        isBanned = data['isBanned'],
        dob = data['dob'],
        qualification = data['qualification'],
        university = data['university'],
        points = data['points'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'isAdmin': isAdmin,
      'isBanned': isBanned,
      'dob': dob,
      'qualification': qualification,
      'university': university,
      'points': points
    };
  }
}
