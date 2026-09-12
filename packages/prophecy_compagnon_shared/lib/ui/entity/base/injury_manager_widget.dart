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
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';

class EntityInjuryManagerWidget extends StatefulWidget {
  const EntityInjuryManagerWidget({
    super.key,
    required this.manager,
    this.allowChanges = true,
    this.circlesDiameter = 12.0,
  });
  
  final InjuryManager manager;
  final bool allowChanges;
  final double circlesDiameter;

  @override
  State<EntityInjuryManagerWidget> createState() => _EntityInjuryManagerWidgetState();
}

class _EntityInjuryManagerWidgetState extends State<EntityInjuryManagerWidget> {
  @override
  Widget build(BuildContext context) {
    var levelNames = <Widget>[];
    var levelInputs = <Widget>[];
    for(var level in widget.manager.levels()) {
      levelNames.add(
        Text(
          '${level.type.title} (${level.start + 1}${level.end == -1 ? "+" : "-${level.end}"})',
        )
      );

      levelInputs.add(
        _InjuryLevelInputWidget(
          level: level,
          count: widget.manager.count(level),
          circlesDiameter: widget.circlesDiameter,
          increase: !widget.allowChanges ? null : () {
            setState(() {
              widget.manager.dealInjuries(level.type, 1);
            });
          },
          decrease: !widget.allowChanges ? null : () {
            setState(() {
              widget.manager.heal(level);
            });
          },
        )
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.0,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: levelNames,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: levelInputs,
            ),
          )
        ],
      ),
    );
  }
}

class _InjuryLevelInputWidget extends StatelessWidget {
  const _InjuryLevelInputWidget({
    required this.level,
    required this.count,
    this.increase,
    this.decrease,
    required this.circlesDiameter,
  });

  final InjuryLevel level;
  final int count;
  final void Function()? increase;
  final void Function()? decrease;
  final double circlesDiameter;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> circles = <Widget>[];
    var colored = 0;

    for(var i = 0; i < level.capacity; ++i) {
      if(colored < count) {
        circles.add(
          UnconstrainedBox(
            child: Container(
              width: circlesDiameter,
              height: circlesDiameter,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
          )
        );
        ++colored;
      }
      else {
        circles.add(
          UnconstrainedBox(
            child: Container(
              width: circlesDiameter,
              height: circlesDiameter,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
          )
        );
      }
    }

    var minWidth = circlesDiameter * 2 + 2.0;

    return Row(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(decrease != null)
          IconButton(
            icon: const Icon(Icons.remove),
            style: IconButton.styleFrom(
              minimumSize: Size.square(28.0),
              maximumSize: Size.square(28.0),
              iconSize: 12.0,
            ),
            onPressed: () => decrease!(),
          ),
        Flexible(
          child: ConstraintsTransformBox(
            clipBehavior: Clip.hardEdge,
            constraintsTransform: (BoxConstraints constraints) {
              if(constraints.maxWidth < minWidth) {
                return BoxConstraints(
                  minWidth: minWidth,
                  maxWidth: minWidth,
                  minHeight: constraints.minHeight,
                  maxHeight: constraints.maxHeight,
                );
              }
              else {
                return constraints;
              }
            },
            child: Wrap(
              spacing: 2.0,
              runSpacing: 2.0,
              children: circles,
            ),
          ),
        ),
        if(increase != null)
          IconButton(
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              minimumSize: Size.square(28.0),
              maximumSize: Size.square(28.0),
              iconSize: 12.0,
            ),
            onPressed: () => increase!(),
        ),
      ],
    );
  }
}