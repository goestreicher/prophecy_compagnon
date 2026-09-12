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

import 'package:fleather/fleather.dart';
import 'package:material_ui/material_ui.dart';

class MarkdownFleatherField extends StatelessWidget {
  const MarkdownFleatherField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.expands = false,
    this.decoration,
  });

  final FleatherController controller;
  final FocusNode focusNode;
  final bool expands;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FleatherTheme(
      data: FleatherThemeData.fallback(context).copyWith(
          link: FleatherThemeData.fallback(context).link.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
      ),
      child: FleatherField(
        controller: controller,
        focusNode: focusNode,
        decoration: decoration ?? const InputDecoration(
          border: OutlineInputBorder(),
        ),
        expands: expands,
      ),
    );
  }
}