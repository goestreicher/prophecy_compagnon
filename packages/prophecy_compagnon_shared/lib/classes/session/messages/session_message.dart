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

import 'package:uuid/uuid.dart';

typedef SessionMessageJsonFactory = SessionMessage Function(Map<String, dynamic>);

abstract class SessionMessage {
  static const String busIdentifier = 'BUS';
  static const String broadcast = 'ALL';
  static const String masterIdentifier = 'MASTER';

  SessionMessage({
    this.source,
    required this.destination,
    this.hasResponse = true,
    this.waitResponseTimeout,
    this.broadcastIncludesSelf = false,
  })
    : uuid = Uuid().v4().toString();

  final String uuid;
  String? source;
  String destination;
  bool hasResponse;
  int? waitResponseTimeout;
  bool broadcastIncludesSelf;

  Map<String, dynamic> sessionMessageToJson();

  factory SessionMessage.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('_type')) {
      throw(ArgumentError('Missing "_type" key in JSON'));
    }
    return _sessionMessageFactories[json['_type']]!(json);
  }

  Map<String, dynamic> toJson() {
    var ret = sessionMessageToJson();
    ret['_type'] = runtimeType.toString();
    return ret;
  }

  static void registerSessionMessageJsonFactory(String name, SessionMessageJsonFactory factory) =>
      _sessionMessageFactories[name] = factory;

  static final Map<String, SessionMessageJsonFactory> _sessionMessageFactories =
      <String, SessionMessageJsonFactory>{};
}