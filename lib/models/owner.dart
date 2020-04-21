class Owner {
  String uid;
  String displayName;
  String email;
  String photoURL;

  Owner({this.uid, this.displayName, this.email, this.photoURL});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoURL': photoURL
      };

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      photoURL: json['photoURL'],
    );
  }
}
