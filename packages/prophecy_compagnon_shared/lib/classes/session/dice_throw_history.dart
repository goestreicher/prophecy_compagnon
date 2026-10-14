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

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:prophecy_compagnon_shared/classes/session/dice_throw_history_entry.dart';

typedef DiceThrowHistoryAddListener = void Function(DiceThrowHistoryEntry);

class DiceThrowHistory with IterableMixin<DiceThrowHistoryEntry>, ChangeNotifier {
  DiceThrowHistory({
    List<DiceThrowHistoryEntry>? entries,
  })
    : _entries = entries ?? <DiceThrowHistoryEntry>[];

  @override
  Iterator<DiceThrowHistoryEntry> get iterator => _entries.iterator;

  void add(DiceThrowHistoryEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  final List<DiceThrowHistoryEntry> _entries;

  factory DiceThrowHistory.fromJson(Map<String, dynamic> json) =>
      DiceThrowHistory(
        entries:
          (json['entries'] as List<dynamic>?)
            ?.map(
              (e) =>
                DiceThrowHistoryEntry.fromJson(e as Map<String, dynamic>),
            )
            .toList() ??
          const <DiceThrowHistoryEntry>[],
      );

  Map<String, dynamic> toJson() =>
    <String, dynamic>{
      'entries': _entries.map((e) => e.toJson()).toList(),
    };
}