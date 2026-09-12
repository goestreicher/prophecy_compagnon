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
import 'package:prophecy_compagnon_shared/classes/resource_link/assets_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link_edit_widget.dart';

class ResourceLinkPickerDialog extends StatefulWidget {
  const ResourceLinkPickerDialog({
    super.key,
    this.localProvider,
    this.restrictToTypes,
  });

  final ResourceLinkProvider? localProvider;
  final List<ResourceLinkType>? restrictToTypes;

  @override
  State<ResourceLinkPickerDialog> createState() => _ResourceLinkPickerDialogState();
}

class _ResourceLinkPickerDialogState extends State<ResourceLinkPickerDialog> {
  late ResourceLinkProvider selectedProvider;
  ResourceLink? selected;

  @override
  void initState() {
    super.initState();

    selectedProvider = widget.localProvider ?? const AssetsResourceLinkProvider();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Sélection de la ressource'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12.0,
          children: [
            if(widget.localProvider != null)
              Row(
                spacing: 16.0,
                children: [
                  Switch(
                    value: widget.localProvider == selectedProvider,
                    onChanged: (bool value) {
                      setState(() {
                        selectedProvider = value
                            ? widget.localProvider!
                            : const AssetsResourceLinkProvider();
                        selected = null;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                        widget.localProvider == selectedProvider
                            ? 'Utiliser les ressources locales (${widget.localProvider!.sourceNames()[0]}'
                            : 'Utiliser les ressources de base'
                    ),
                  ),
                ],
              ),
            ResourceLinkEditWidget(
                provider: selectedProvider,
                restrictToTypes: widget.restrictToTypes,
                onChanged: (ResourceLink? l) {
                  setState(() {
                    selected = l;
                  });
                }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: selected == null ? null : () {
                      Navigator.of(context, rootNavigator: true).pop(selected);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}