// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/session/map/item.dart";
import "package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart";
import "package:prophecy_compagnon_shared/classes/session/map/item_entity.dart";

void registerSessionMapItems() {
  SessionMapItem.registerSessionMapItemJsonFactory(
    "SessionMapEntityItem",
    (
        Map<String, dynamic> json,
        SessionContextRetriever context
    ) => SessionMapEntityItem.fromJson(json, context),
  );

}
