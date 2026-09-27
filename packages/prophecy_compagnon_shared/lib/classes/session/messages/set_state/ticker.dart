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

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_set_state.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'ticker.g.dart';

@JsonSerializable()
class SessionTickerEventMessage extends SessionSetStateMessage {
  SessionTickerEventMessage({
    required this.event,
  })
    : super(destination: SessionMessage.broadcast);

  final TickerEvent event;

  @override
  void apply(GameSession session) {
    session.tick(event);
  }

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionTickerEventMessageToJson(this);

  factory SessionTickerEventMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionTickerEventMessageFromJson(json);
}