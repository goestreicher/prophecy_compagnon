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

import 'package:fleather/fleather.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parchment/codecs.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/sourced_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/ui/markdown_fleather_field.dart';
import 'package:prophecy_compagnon_shared/ui/markdown_fleather_toolbar.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditDescriptionWidget extends StatefulWidget {
  const EntityEditDescriptionWidget({
    super.key,
    required this.entity,
  });

  final EntityBase entity;

  @override
  State<EntityEditDescriptionWidget> createState() => _EntityEditDescriptionWidgetState();
}

class _EntityEditDescriptionWidgetState extends State<EntityEditDescriptionWidget> {
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();

    descriptionFocusNode = FocusNode();
    ParchmentDocument document = ParchmentMarkdownCodec().decode(widget.entity.description);
    descriptionController = FleatherController(document: document);
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Description',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 8.0,
        children: [
          MarkdownFleatherToolbarFormField(
            controller: descriptionController,
            showResourcePicker: true,
            localResourceLinkProvider: SourcedResourceLinkProvider(source: widget.entity.source),
            onSaved: (String value) {
              widget.entity.description = value;
            },
          ),
          SizedBox(
            height: 300,
            child: MarkdownFleatherField(
              controller: descriptionController,
              focusNode: descriptionFocusNode,
              expands: true,
            ),
          ),
        ],
      ),
    );
  }
}