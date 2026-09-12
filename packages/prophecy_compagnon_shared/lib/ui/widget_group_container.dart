/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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

import 'package:material_ui/material_ui.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:prophecy_compagnon_shared/ui/measure_widget_offscreen.dart';

class WidgetGroupContainer extends StatelessWidget {
  const WidgetGroupContainer({
    super.key,
    this.title,
    required this.child,
  });

  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleWidgetSize = Size.zero;

    if(title != null) {
      titleWidgetSize = measureWidgetOffscreen(title!);
    }

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0 + (titleWidgetSize.height / 2), 8.0, 8.0),
            decoration: BoxDecoration(
              border: const GradientBoxBorder(
                width: 1.5,
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.8]
                )
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: child,
          ),
          if(title != null)
            Positioned(
              top: -(titleWidgetSize.height / 2),
              left: 12,
              child: Container(
                color: theme.colorScheme.surfaceBright,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: title,
              )
            ),
        ],
      ),
    );
  }
}