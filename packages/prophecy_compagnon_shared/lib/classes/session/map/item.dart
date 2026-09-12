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

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

abstract class SessionMapItem extends ChangeNotifier {
  SessionMapItem({
    double? x,
    double? y,
  })
    : _x = x ?? 0.0, _y = y ?? 0.0;

  String get id;
  String? get label;
  Size get size;
  Future<GenericImage?> get image;

  double get x => _x;
  set x(double v) {
    _x = v;
    notifyListeners();
  }
  double _x;

  double get y => _y;
  set y(double v) {
    _y = v;
    notifyListeners();
  }
  double _y;

  bool get movable => false;
  double get movementDistance => 0.0;
}