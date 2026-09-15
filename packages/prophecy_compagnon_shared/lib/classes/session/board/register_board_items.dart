// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/board/item.dart";
import "package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart";
import "package:prophecy_compagnon_shared/classes/session/board/item_image.dart";
import "package:prophecy_compagnon_shared/classes/session/board/item_map.dart";

void registerSessionBoardItems() {
  SessionBoardItem.registerSessionBoardItemJsonFactory(
    "SessionBoardItemImage",
    (
        Map<String, dynamic> json,
        SessionContextRetriever context
    ) => SessionBoardItemImage.fromJson(json, context),
  );

  SessionBoardItem.registerSessionBoardItemJsonFactory(
    "SessionBoardItemMap",
    (
        Map<String, dynamic> json,
        SessionContextRetriever context
    ) => SessionBoardItemMap.fromJson(json, context),
  );

}
