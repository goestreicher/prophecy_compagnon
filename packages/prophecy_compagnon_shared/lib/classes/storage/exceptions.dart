/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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

class StorageException implements Exception {
  StorageException(this.message);

  String message;

  @override
  String toString() => 'Storage exception: $message';
}

class KeyNotFoundException implements Exception {
  KeyNotFoundException(this.category, this.key);

  String category;
  String key;

  @override
  String toString() => 'Key "$key" not found in category "$category"';
}