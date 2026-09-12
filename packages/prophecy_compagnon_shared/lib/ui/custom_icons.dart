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

import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const String _kFontPkg = 'prophecy_compagnon_shared';

  static const IconData archery = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData creature = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData d10 = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
