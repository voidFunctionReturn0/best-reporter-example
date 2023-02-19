class Member {
  String name;
  String? profileImage;

  Member(this.name);
  Member.withProfileImage(this.name, this.profileImage);
}