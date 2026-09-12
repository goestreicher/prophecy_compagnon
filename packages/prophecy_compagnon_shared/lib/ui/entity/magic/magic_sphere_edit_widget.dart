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
import 'package:prophecy_compagnon_shared/classes/magic.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';

class MagicSphereEditWidget extends StatefulWidget {
  const MagicSphereEditWidget({
    super.key,
    required this.sphere,
    required this.value,
    required this.pool,
    required this.onValueChanged,
    required this.onPoolChanged,
  });

  final MagicSphere sphere;
  final int value;
  final int pool;
  final void Function(int) onValueChanged;
  final void Function(int) onPoolChanged;

  @override
  State<MagicSphereEditWidget> createState() => _MagicSphereEditWidgetState();
}

class _MagicSphereEditWidgetState extends State<MagicSphereEditWidget> {
  int _value = 0;
  int _pool = 0;
  final _poolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _pool = widget.pool;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 12.0,
        children: [
          Column(
            spacing: 8.0,
            children: [
              SizedBox(
                width: 32,
                height: 48,
                child: Image.asset(
                  'packages/prophecy_compagnon_shared/assets/images/magic/sphere-${widget.sphere.name}-icon.png',
                ),
              ),
              Text(
                widget.sphere.title,
                style: theme.textTheme.bodySmall,
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: 96,
                child: NumIntInputWidget(
                    label: 'Niveau',
                    initialValue: _value,
                    minValue: 0,
                    maxValue: 30,
                    onChanged: (int value) {
                      var old = _value;
                      var delta = value - old;
                      if(_pool + delta < 0) {
                        delta = _pool;
                      }

                      setState(() {
                        _value = value;
                        _pool = _pool + delta;
                        _poolController.text = _pool.toString();
                      });

                      widget.onValueChanged(_value);
                      widget.onPoolChanged(_pool);
                    }
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: 96,
                child: NumIntInputWidget(
                    label: 'Réserve',
                    initialValue: _pool,
                    minValue: 0,
                    maxValue: _value,
                    controller: _poolController,
                    onChanged: (int value) {
                      setState(() {
                        _pool = value;
                      });

                      widget.onPoolChanged(_pool);
                    }
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}