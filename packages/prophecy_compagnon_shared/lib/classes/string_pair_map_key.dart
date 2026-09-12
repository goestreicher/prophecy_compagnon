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

class StringPairMapKey {
  StringPairMapKey(String n1, String n2)
    : pair = n1.compareTo(n2) < 0 ? (n1, n2) : (n2, n1)
  {
    if(n1 == n2) {
      throw(
        ArgumentError.value(
          pair,
          null,
          'Both strings in a StringPairMapKey must be different'
        )
      );
    }
  }

  (String, String) pair;

  @override
  bool operator ==(Object other) =>
      other is StringPairMapKey
      && pair.$1 == other.pair.$1
      && pair.$2 == other.pair.$2;

  @override
  int get hashCode => Object.hash(pair.$1, pair.$2);
}