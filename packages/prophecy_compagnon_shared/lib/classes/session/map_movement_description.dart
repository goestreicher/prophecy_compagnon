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

import 'dart:math';
import 'dart:ui';

class MovementDescription {
  MovementDescription({
    required this.startX, required this.startY,
    double? currentX, double? currentY,
  })
      : currentX = currentX ?? startX,
        currentY = currentY ?? startY,
        lastValidX = currentX ?? startX,
        lastValidY = currentY ?? startY;

  double startX;
  double startY;
  double currentX;
  double currentY;
  double lastValidX;
  double lastValidY;

  Offset get offset => Offset(startX - currentX, startY - currentY);

  double get distance {
    var d = offset;
    return sqrt(d.dx * d.dx + d.dy * d.dy);
  }
}