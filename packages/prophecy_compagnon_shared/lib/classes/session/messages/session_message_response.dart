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
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';

part 'session_message_response.g.dart';

typedef SessionMessageResponseCallback = void Function(SessionMessageResponse);

enum SessionMessageResponseStatus {
  accepted,
  cancelled,
  rejected,
  error,
  timeout,
}

@JsonSerializable()
class SessionMessageResponse extends SessionMessage {
  SessionMessageResponse({
    required super.source,
    required super.destination,
    super.hasResponse = false,
    required this.ack,
    required this.status,
    this.statusMessage,
    this.data,
  }) {
    if(destination == SessionMessage.broadcast) {
      throw ArgumentError("A message response cannot be broadcast");
    }
  }

  final String ack;
  final SessionMessageResponseStatus status;
  final String? statusMessage;
  final dynamic data;

  @override
  Map<String, dynamic> sessionMessageToJson() =>
      _$SessionMessageResponseToJson(this);

  factory SessionMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionMessageResponseFromJson(json);
}