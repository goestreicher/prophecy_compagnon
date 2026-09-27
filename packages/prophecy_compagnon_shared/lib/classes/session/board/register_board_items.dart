// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/board/item.dart";
import "package:prophecy_compagnon_shared/classes/session/board/item_image.dart";
import "package:prophecy_compagnon_shared/classes/session/board/item_map.dart";

void registerSessionBoardItems() {
  SessionBoardItem.registerSessionBoardItemJsonFactory(
    "SessionBoardItemImage",
    (Map<String, dynamic> json) => SessionBoardItemImage.fromJson(json),
  );

  SessionBoardItem.registerSessionBoardItemJsonFactory(
    "SessionBoardItemMap",
    (Map<String, dynamic> json) => SessionBoardItemMap.fromJson(json),
  );

}
