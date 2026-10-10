import 'package:ahlachat/models/emoji.dart';

class EmojiCategory {
  int? id;
  String? name;
  String? status;

  List<emojimodel>? emoji;

  EmojiCategory({
    this.id,
    this.name,
    this.status,
    this.emoji,
  });

  EmojiCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');

    name = json['name']?.toString();

    // API returns status as int, e.g. 1
    status = json['status']?.toString();

    if (json['emoji'] is List) {
      emoji = <emojimodel>[];

      for (final item in json['emoji']) {
        if (item is Map<String, dynamic>) {
          try {
            emoji!.add(
              emojimodel.fromJson(item),
            );
          } catch (e, stackTrace) {
            print(
              'EMOJI CATEGORY ITEM PARSE ERROR: $e',
            );
            print(
              'EMOJI CATEGORY ITEM DATA: $item',
            );
            print(
              'EMOJI CATEGORY ITEM STACK: $stackTrace',
            );
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['status'] = status;

    if (emoji != null) {
      data['emoji'] = emoji!
          .map((v) => v.toJson())
          .toList();
    }

    return data;
  }
}