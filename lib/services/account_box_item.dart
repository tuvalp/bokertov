import 'package:hive/hive.dart';

part 'account_box_item.g.dart'; // Generated file

@HiveType(typeId: 2)
class GoogleSignInAccountitem {
  GoogleSignInAccountitem({
    required this.displayName,
    required this.email,
    required this.id,
    this.photoUrl,
  });

  @HiveField(0)
  String displayName;
  @HiveField(1)
  String email;
  @HiveField(2)
  String id;
  @HiveField(3)
  String? photoUrl;
}
