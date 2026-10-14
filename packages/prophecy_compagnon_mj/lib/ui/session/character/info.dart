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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/info/view_actions.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/info/view_attributes.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/info/view_injuries.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/status_widget.dart';

class SessionCharacterInfoWidget extends StatefulWidget {
  const SessionCharacterInfoWidget({
    super.key,
    required this.character,
  });

  final EntityBase character;

  @override
  State<SessionCharacterInfoWidget> createState() => _SessionCharacterInfoWidgetState();
}

class _SessionCharacterInfoWidgetState extends State<SessionCharacterInfoWidget> {
  _SessionCharacterInfoSelectedView selectedView = _SessionCharacterInfoSelectedView.actions;

  @override
  Widget build(BuildContext context) {
    Widget? viewWidget;
    switch(selectedView) {
      case _SessionCharacterInfoSelectedView.actions:
        viewWidget = SessionCharacterInfoViewActions(
          character: widget.character
        );
      case _SessionCharacterInfoSelectedView.injuries:
        viewWidget = SessionCharacterInfoViewInjuries(
          character: widget.character
        );
      case _SessionCharacterInfoSelectedView.attributes:
        viewWidget = SessionCharacterInfoViewAttributes(
          character: widget.character
        );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Column(
                spacing: 16.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: EntityStatusWidget(
                      entity: widget.character,
                      iconWidth: 50.0,
                      iconHeight: 50.0,
                    ),
                  ),
                  ListBody(
                    children: [
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.actions,
                        selected: selectedView == _SessionCharacterInfoSelectedView.actions,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.actions;
                          });
                        },
                      ),
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.injuries,
                        selected: selectedView == _SessionCharacterInfoSelectedView.injuries,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.injuries;
                          });
                        },
                      ),
                      _SessionCharacterInfoSelectViewWidget(
                        view: _SessionCharacterInfoSelectedView.attributes,
                        selected: selectedView == _SessionCharacterInfoSelectedView.attributes,
                        onSelected: () {
                          setState(() {
                            selectedView = _SessionCharacterInfoSelectedView.attributes;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: viewWidget),
          ],
        )
      ),
    );
  }
}

enum _SessionCharacterInfoSelectedView {
  actions(title: 'Actions'),
  injuries(title: 'Blessures'),
  attributes(title: 'Attributs'),
  ;

  final String title;

  const _SessionCharacterInfoSelectedView({ required this.title });
}

class _SessionCharacterInfoSelectViewWidget extends StatelessWidget {
  const _SessionCharacterInfoSelectViewWidget({
    required this.view,
    required this.selected,
    required this.onSelected,
  });

  final _SessionCharacterInfoSelectedView view;
  final bool selected;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: selected ? null : onSelected,
      child: Container(
        color: selected
            ? theme.colorScheme.surfaceContainerHighest
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            view.title,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}