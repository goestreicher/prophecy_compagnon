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

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_event.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/board.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect_manager.dart';
import 'package:prophecy_compagnon_shared/classes/session/event.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storable.dart';
import 'package:prophecy_compagnon_shared/classes/table.dart';
import 'package:uuid/uuid.dart';

part 'game_session.g.dart';

class GameSessionStore extends JsonStoreAdapter<GameSession> {
  GameSessionStore();

  @override
  String storeCategory() => 'gameSessions';

  @override
  String key(GameSession object) => object.uuid;

  @override
  Future<GameSession> fromJsonRepresentation(Map<String, dynamic> j) async {
    var jsonFull = j;

    // TODO: manage when scenario or table were removed or when get() fails
    jsonFull['scenario'] = (await ScenarioStore().get(j['scenario']))!.toJson();
    jsonFull['table'] = (await GameTableStore().getWithPlayers(j['table']))!.toJson();

    return GameSession.fromJson(jsonFull);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(GameSession object) async {
    var j = object.toJson();

    j['table'] = object.table.uuid;
    j['scenario'] = object.scenario.uuid;

    return j;
  }
}

@ScenarioDaysJsonConverter()
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameSession extends ChangeNotifier {
  GameSession({
    String? uuid,
    required this.table,
    required this.scenario,
    required this.startDate,
    int? scenarioDay,
    KorTime? time,
    SessionDays? sessionDays,
    SessionEncounter? encounter,
    SessionGameBoard? board,
    EntityEffectManager? effectManager,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      time = time ?? KorTime(hour: 0, minute: 0),
      encounter = ValueNotifier<SessionEncounter?>(encounter),
      board = board ?? SessionGameBoard(),
      effectManager = effectManager ?? EntityEffectManager()
  {
    if(sessionDays == null) {
      this.sessionDays = SessionDays.fromJson(
        sessionDays: <String, dynamic>{},
        remapped: <String, dynamic>{},
        scenarioDays: scenario.events,
      );
    }

    this.sessionDays.updateWithScenarioDays(scenario.events);

    // If scenarioDay is null, assume this is a new session, and mark all
    // events before the start as realized, for the world category
    if(scenarioDay == null) {
      for(var range in this.sessionDays.daysBefore(0)) {
        for(var event in (this.sessionDays[range]!.events[ScenarioEventCategory.world] ?? <SessionEvent>[])) {
          event.realized = range;
        }
      }
    }
    this.scenarioDay = scenarioDay ?? 0;
  }

  final String uuid;
  final GameTable table;
  final Scenario scenario;

  KorDate startDate;
  late int scenarioDay;
  KorTime time;

  @JsonKey(includeFromJson: false, includeToJson: false)
    late SessionDays sessionDays;

  @JsonKey(includeFromJson: false, includeToJson: false)
    ValueNotifier<SessionEncounter?> encounter;

  @JsonKey(includeFromJson: false, includeToJson: false)
    SessionGameBoard board;

  EntityEffectManager effectManager;

  EntityBase? entity(String id) {
    print('$id - ${table.players.length}');
    for(var e in table.players) {
      print('  * ${e.id} <> $id');
      if(e.id == id) return e;
    }
    for(var e in (encounter.value?.npcs ?? <EntityBase>[])) {
      if(e.id == id) return e;
    }
    return null;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
    int get day => scenarioDay;

  set day(int d) {
    scenarioDay = d;
    time = KorTime(hour: 0, minute: 0);
    notifyListeners();
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
    int get hour => time.hour;

  set hour(int h) {
    time.hour = h;
    time.minute = 0;
    notifyListeners();
  }

  void nextHour() {
    if(time.hour == 23) {
      scenarioDay += 1;
      time.hour = 0;
      time.minute = 0;
    }
    else {
      time.hour += 1;
      time.minute = 0;
    }
    notifyListeners();
  }

  KorDate get currentDate =>
      startDate.clone()..addDays(day);

  KorDate relativeSessionDate(int dayOffset) =>
      startDate.clone()..addDays(dayOffset);

  String relativeSessionDateDescription(int dayOffset) {
    if(dayOffset == 0) {
      return "Aujourd'hui";
    }
    else {
      var plural = dayOffset < -1 || dayOffset > 1
          ? 's'
          : '';
      var relative = dayOffset < 0
          ? 'Il y a'
          : 'Dans';
      return '$relative ${dayOffset.abs()} jour$plural';
    }
  }

  factory GameSession.fromJson(Map<String, dynamic> json) {
    var ret = _$GameSessionFromJson(json);

    if(
        json.containsKey('session_days')
        && json['session_days'] is Map
        && json['session_days']!.containsKey('days')
    ) {
      var entry = json['session_days'] as Map<String, dynamic>;

      ret.sessionDays = SessionDays.fromJson(
        sessionDays: entry['days'] as Map<String, dynamic>,
        remapped: (entry['remapped'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        scenarioDays: ret.scenario.events,
      );
    }

    ret.table.loadPlayers().then((_) {
      if(json['encounter'] != null) {
        ret.encounter.value = SessionEncounter.fromJson(
          json['encounter'],
              (String id) => ret.entity(id),
        );
      }

      var context = SessionContextRetriever(
        entity: (String id) => ret.entity(id),
        encounter: ret.encounter.value,
      );

      ret.board = SessionGameBoard.fromJson(json['board'], context);
    });

    return ret;
  }

  Map<String, dynamic> toJson() {
    var ret = _$GameSessionToJson(this);

    ret['session_days'] = sessionDays.toJson();
    ret['encounter'] = encounter.value?.toJson();
    ret['board'] = board.toJson();

    return ret;
  }
}