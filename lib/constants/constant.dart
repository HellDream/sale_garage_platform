import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sale_garage_platform/services/auth_service.dart';
import 'package:sale_garage_platform/services/chat_service.dart';
import 'package:sale_garage_platform/services/image_service.dart';
import 'package:sale_garage_platform/services/messaging_service.dart';
import 'package:sale_garage_platform/services/post_service.dart';
import 'package:sale_garage_platform/services/user_service.dart';
import 'package:intl/intl.dart';

final AuthService authService = AuthService();
final PostService postService = PostService();
final ImageService imageService = ImageService();
final NumberFormat formatter = NumberFormat.simpleCurrency();
final ChatService chatService = ChatService();
final UserService userService = UserService();
final dateFormatJm = DateFormat().add_jm();
final dateFormatHm = new DateFormat.Hm();
final MessagingService messagingService = MessagingService();
