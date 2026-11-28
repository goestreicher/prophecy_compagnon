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

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class SessionChatMessage {
  SessionChatMessage({
    this.title,
    required this.text,
    required this.time,
  });

  final String? title;
  final String text;
  final DateTime time;

  factory SessionChatMessage.fromJson(Map<String, dynamic> json) =>
      _$SessionChatMessageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SessionChatMessageToJson(this);
}

class SessionChat with IterableMixin<SessionChatMessage>, ChangeNotifier {
  SessionChat({
    List<SessionChatMessage>? messages,
  })
    : _messages = messages ?? <SessionChatMessage>[];

  @override
  Iterator<SessionChatMessage> get iterator => _messages.iterator;

  void post({ String? title, required String text }) => add(
      SessionChatMessage(
        title: title,
        text: text,
        time: DateTime.timestamp()
      )
  );

  void add(SessionChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  final List<SessionChatMessage> _messages;

  factory SessionChat.fromJson(Map<String, dynamic> json) =>
      SessionChat(
        messages:
          (json['messages'] as List<dynamic>?)
            ?.map(
              (e) =>
                SessionChatMessage.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
            const <SessionChatMessage>[],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'messages': _messages.map((e) => e.toJson()).toList(),
      };
}