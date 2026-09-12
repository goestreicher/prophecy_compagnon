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
import 'package:prophecy_compagnon_shared/classes/faction.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/faction/faction_edit_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/generic_tree_widget.dart';

class FactionTreeWidgetAdapter implements GenericTreeWidgetAdapter<FactionSummary, Faction> {
  const FactionTreeWidgetAdapter({
    this.itemSelectionCallback,
    this.itemCreationCallback,
    this.newFactionSource,
    this.resourceLinkProvider,
  });

  final void Function(FactionSummary)? itemSelectionCallback;
  final void Function(Faction)? itemCreationCallback;
  final ObjectSource? newFactionSource;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  FactionSummary toTreeDataType(Faction f) => f.summary;

  @override
  void onItemSelected(FactionSummary item) {
    itemSelectionCallback?.call(item);
  }

  @override
  void onItemCreated(Faction item) {
    itemCreationCallback?.call(item);
  }

  @override
  Widget getItemCreationWidget(BuildContext context, FactionSummary? parent) {
    return FactionEditDialog(
      parentId: parent?.id,
      source: newFactionSource,
      resourceLinkProvider: resourceLinkProvider,
    );
  }
}