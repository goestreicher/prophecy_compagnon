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

import 'package:prophecy_compagnon_shared/classes/dice/throw_matcher.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';

class BooleanOrDiceThrowMatcher extends DiceThrowMatcher {
  const BooleanOrDiceThrowMatcher({ required this.children });

  final List<DiceThrowMatcher> children;

  @override
  bool matches(DiceThrowRequest request) =>
      children.any((DiceThrowMatcher m) => m.matches(request));
}

class BooleanAndDiceThrowMatcher extends DiceThrowMatcher {
  const BooleanAndDiceThrowMatcher({ required this.children });

  final List<DiceThrowMatcher> children;

  @override
  bool matches(DiceThrowRequest request) =>
      children.every((DiceThrowMatcher m) => m.matches(request));
}