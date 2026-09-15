/*
 * Copyright (C) 2026 Grégory Oestreicher
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/place_map.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';
import 'package:prophecy_compagnon_shared/classes/string_pair_map_key.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class SessionBoardItemMap extends SessionBoardItem {
  SessionBoardItemMap({
    required super.title,
    required this.background,
    SessionBoardItemMapItems? items,
    this.encounter,
  })
    : _bgImage = GenericImage.memory(binary: background.exportableBinaryData!),
      items = items ?? SessionBoardItemMapItems(),
      freeMovementEnabled = true
  {
    distances = MapDistances(this.items);
  }

  @override
  Future<GenericImage> thumbnail(double maxDimension) async =>
      _bgImage.thumbnail(maxDimension);

  @override
  GenericImage image() =>
      _bgImage;

  final PlaceMap background;
  final GenericImage _bgImage;
  vm.Matrix4? transformation;
  final SessionBoardItemMapItems items;
  late final MapDistances distances;
  SessionEncounter? encounter;
  bool freeMovementEnabled;

  @override get removable =>
    (encounter == null || encounter!.status == SessionEncounterStatus.finished);

  factory SessionBoardItemMap.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context
  ) =>
      SessionBoardItemMap(
        title: json['title'] as String,
        background: PlaceMap.fromJson(
          json['background'] as Map<String, dynamic>,
        ),
        items: SessionBoardItemMapItems.fromJson(
          ((json['items'] as Map<String, dynamic>?) ?? <String, dynamic>{}),
          context,
        ),
        encounter: context.encounter,
      )
      ..transformation = _matrix4FromJson(
        json['transformation'] as List<double>?,
      )
      ..freeMovementEnabled = json['free_movement_enabled'] as bool;

  @override
  Map<String, dynamic> boardItemToJson() =>
      <String, dynamic>{
        'title': title,
        'background': background.toJson(),
        'items': items.toJson(),
        'transformation': _matrix4ToJson(transformation),
        'free_movement_enabled': freeMovementEnabled,
      };
}

vm.Matrix4? _matrix4FromJson(List<double>? l) =>
    l == null ? null : vm.Matrix4.fromList(l);

List<double> _matrix4ToJson(vm.Matrix4? m) {
  var ret = List<double>.generate(16, (int i) => 0.0);
  m?.copyIntoArray(ret);
  return ret;
}

class MapDistances {
  MapDistances(SessionBoardItemMapItems items)
    : _distances = <StringPairMapKey, double>{}, _items = items
  {
    rebuild();
  }

  double? between(SessionMapItem first, SessionMapItem second) {
    var search = StringPairMapKey(first.id, second.id);
    return _distances[search];
  }

  Map<String, double> from(SessionMapItem item) {
    var ret = <String, double>{};
    for(var k in _distances.keys) {
      if(k.pair.$1 == item.id) {
        ret[k.pair.$2] = _distances[k]!;
      }
      else if(k.pair.$2 == item.id) {
        ret[k.pair.$1] = _distances[k]!;
      }
    }
    return ret;
  }

  void updateFrom(SessionMapItem item) {
    for(var other in _items.values) {
      if(other == item) continue;

      var key = StringPairMapKey(item.id, other.id);
      var dx = item.x - other.x;
      var dy = item.y - other.y;
      var distance = sqrt(dx*dx + dy*dy);

      // This assumes that all objects are circles
      // TODO: manage different shapes some day
      distance -= max(item.size.width, item.size.height);
      distance -= max(other.size.width, other.size.height);

      _distances[key] = distance;
    }
  }

  void remove(SessionMapItem item) => _distances.removeWhere(
      (StringPairMapKey k, double v) =>
          k.pair.$1 == item.id || k.pair.$2 == item.id
  );

  void rebuild() {
    for(var item in _items.values) {
      updateFrom(item);
    }
  }

  final Map<StringPairMapKey, double> _distances;
  final SessionBoardItemMapItems _items;
}

class SessionBoardItemMapItems with IterableMixin<MapEntry<String, SessionMapItem>>, ChangeNotifier {
  SessionBoardItemMapItems({
    Map<String, SessionMapItem>? items
  })
    : _items = items ?? <String, SessionMapItem>{};

  @override
  Iterator<MapEntry<String, SessionMapItem>> get iterator => _items.entries.iterator;

  Iterable<SessionMapItem> get values => _items.values;

  SessionMapItem? remove(String k) {
    var ret = _items.remove(k);
    notifyListeners();
    return ret;
  }

  SessionMapItem? operator [](String k) => _items[k];

  void operator []=(String k, SessionMapItem v) {
    _items[k] = v;
    notifyListeners();
  }

  factory SessionBoardItemMapItems.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context,
  ) {
    return SessionBoardItemMapItems(
      items: Map.fromEntries(
        json.entries
          .map(
            (MapEntry<String, dynamic> e) =>
              MapEntry<String, SessionMapItem>(
                e.key,
                SessionMapItem.fromJson(e.value as Map<String, dynamic>, context)
              )
          )
      )
    );
  }

  Map<String, dynamic> toJson() {
    return Map.fromEntries(
      _items.entries
        .map(
          (MapEntry<String, SessionMapItem> e) =>
            MapEntry<String, dynamic>(e.key, e.value.toJson())
        )
    );
  }

  final Map<String, SessionMapItem> _items;
}