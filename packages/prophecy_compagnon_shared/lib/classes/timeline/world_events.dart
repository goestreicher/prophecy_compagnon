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

import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/storage/default_assets_store.dart';
import 'package:prophecy_compagnon_shared/classes/timeline/event.dart';

class WorldEvents {
  WorldEvents();

  static Iterable<TimelineEvent> forAge(KorAge age) {
    var filter = WorldEventFilter(
      age: age,
    );

    return _events
        .where((TimelineEvent e) => filter.match(e));
  }

  static Iterable<TimelineEvent> matching(WorldEventFilter filter) =>
    _events
      .where((TimelineEvent e) => filter.match(e));

  static Future<void> loadAll() async {
    if(_events.isNotEmpty) return;

    var assetFiles = [
      'events-avant-le-temps.json',
      'events-age-des-fondations.json',
      'events-age-des-conquetes.json',
      'events-age-des-empires.json',
    ];

    for(var f in assetFiles) {
      for(var e in await loadJSONAssetObjectList(f)) {
        var evt = TimelineEvent.fromJson(e);
        _events.add(evt);
      }
    }
  }

  static final List<TimelineEvent> _events = <TimelineEvent>[];
}

abstract class WorldEventFilterComparator {
  bool match<ComparableType>(ComparableType reference, ComparableType value);
}

class WorldEventFilterComparatorEquals implements WorldEventFilterComparator {
  @override
  bool match<ComparableType>(ComparableType reference, ComparableType value) =>
      reference == value;
}

class WorldEventFilter {
  WorldEventFilter({
    this.sourceType,
    this.source,
    this.age,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  KorAge? age;

  bool match(TimelineEvent event) =>
      (sourceType == null || sourceType == event.source.type)
      && (source == null || source == event.source)
      && (age == null || age == event.range.start.age);
}