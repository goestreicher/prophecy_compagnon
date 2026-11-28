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
          inflicted: widget.manager.inflicted(level.type),
          circlesDiameter: widget.circlesDiameter,
          increase: !widget.allowChanges ? null : () {
            setState(() {
              widget.manager.dealInjuries(
                injury: level.type,
                count: 1
              );
            });
          },
          decrease: !widget.allowChanges ? null : () {
            setState(() {
              widget.manager.heal(level.type);
            });
          },
          heal: !widget.allowChanges ? null : (InflictedInjury i) {
            setState(() {
              widget.manager.heal(level.type, injury: i);
            });
          }
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

class _InflictedInjuryOverlay extends StatelessWidget {
  const _InflictedInjuryOverlay({
    required this.injury,
    this.onHeal,
  });

  final InflictedInjury injury;
  final void Function()? onHeal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              injury.remainingHealingDays > 0
                ? "Guérie dans ${injury.remainingHealingDays} jours"
                : "Impossible à guérir",
            ),
            if(onHeal != null)
              TextButton.icon(
                onPressed: () {
                  onHeal!();
                },
                label: const Text('Soigner'),
                icon: Icon(Icons.healing),
              ),
          ],
        ),
      ),
    );
  }
}

class _InjuryLevelInputWidget extends StatefulWidget {
  const _InjuryLevelInputWidget({
    required this.level,
    required this.inflicted,
    this.increase,
    this.decrease,
    this.heal,
    required this.circlesDiameter,
  });

  final InjuryLevel level;
  final List<InflictedInjury> inflicted;
  final void Function()? increase;
  final void Function()? decrease;
  final void Function(InflictedInjury)? heal;
  final double circlesDiameter;

  @override
  State<_InjuryLevelInputWidget> createState() => _InjuryLevelInputWidgetState();
}

class _InjuryLevelInputWidgetState extends State<_InjuryLevelInputWidget> {
  OverlayEntry? infoOverlay;

  void dismissOverlay() {
    infoOverlay?.remove();
    infoOverlay?.dispose();
    infoOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> circles = <Widget>[];

    for(var i in widget.inflicted) {
      circles.add(
        GestureDetector(
          onTapUp: (TapUpDetails details) {
            var overlayState = Overlay.of(context);
            infoOverlay = OverlayEntry(
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    ModalBarrier(
                      dismissible: true,
                      onDismiss: () {
                        dismissOverlay();
                      },
                    ),
                    Positioned(
                      top: details.globalPosition.dy,
                      left: details.globalPosition.dx,
                      child: _InflictedInjuryOverlay(
                        injury: i,
                        onHeal: widget.heal == null ? null : () {
                          widget.heal!(i);
                          dismissOverlay();
                        },
                      ),
                    ),
                  ],
                );
              },
            );
            overlayState.insert(infoOverlay!);
          },
          child: UnconstrainedBox(
            child: Container(
              width: widget.circlesDiameter,
              height: widget.circlesDiameter,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black),
              ),
            ),
          ),
        )
      );
    }

    for(var i = 0; i < widget.level.capacity - widget.inflicted.length; ++i) {
      circles.add(
        UnconstrainedBox(
          child: Container(
            width: widget.circlesDiameter,
            height: widget.circlesDiameter,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceBright,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
          ),
        )
      );
    }

    var minWidth = widget.circlesDiameter * 2 + 2.0;

    return Row(
      spacing: 4.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if(widget.decrease != null)
          IconButton(
            icon: const Icon(Icons.remove),
            style: IconButton.styleFrom(
              minimumSize: Size.square(28.0),
              maximumSize: Size.square(28.0),
              iconSize: 12.0,
            ),
            onPressed: () => widget.decrease!(),
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
        if(widget.increase != null)
          IconButton(
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              minimumSize: Size.square(28.0),
              maximumSize: Size.square(28.0),
              iconSize: 12.0,
            ),
            onPressed: () => widget.increase!(),
        ),
      ],
    );
  }
}