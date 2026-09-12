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
import 'package:prophecy_compagnon_shared/classes/npc_category.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/non_player_character/list_filter.dart';

class NPCListFilterWidget extends StatefulWidget {
  const NPCListFilterWidget({
    super.key,
    required this.onFilterChanged,
    this.filter,
  });

  final void Function(NPCListFilter) onFilterChanged;
  final NPCListFilter? filter;

  @override
  State<NPCListFilterWidget> createState() => _NPCListFilterWidgetState();
}

class _NPCListFilterWidgetState extends State<NPCListFilterWidget> {
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late NPCListFilter currentFilter;

  @override
  void initState() {
    super.initState();

    currentFilter = widget.filter ?? NPCListFilter();
    sourceTypeController.text = currentFilter.sourceType?.title ?? '';
    sourceController.text = currentFilter.source?.name ?? '';
    categoryController.text = currentFilter.category?.title ?? '';
    subCategoryController.text = currentFilter.subCategory?.title ?? '';
    searchController.text = currentFilter.search ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16.0,
      runSpacing: 8.0,
      children: [
        DropdownMenu(
          controller: sourceTypeController,
          label: Text(
            'Type de source',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.sourceType,
          leadingIcon: currentFilter.sourceType == null
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      sourceTypeController.clear();
                      currentFilter.sourceType = null;
                      sourceController.clear();
                      currentFilter.source = null;
                    });
                    widget.onFilterChanged(currentFilter);
                  },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (ObjectSourceType? sourceType) {
            setState(() {
              currentFilter.sourceType = sourceType;
              sourceController.clear();
              currentFilter.source = null;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: ObjectSourceType.values
            .map(
                (ObjectSourceType s) => DropdownMenuEntry(
                    value: s,
                    label: s.title
                )
            )
            .toList(),
        ),
        DropdownMenu(
          controller: sourceController,
          enabled: currentFilter.sourceType != null,
          label: Text(
            'Source',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.source,
          leadingIcon: currentFilter.source == null
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      sourceController.clear();
                      currentFilter.source = null;
                    });
                    widget.onFilterChanged(currentFilter);
                  },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (ObjectSource? source) {
            setState(() {
              currentFilter.source = source;
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: currentFilter.sourceType == null
            ? <DropdownMenuEntry<ObjectSource>>[]
            : ObjectSource.forType(currentFilter.sourceType!)
                .map(
                    (ObjectSource s) => DropdownMenuEntry(
                        value: s, label: s.name)
                )
                .toList(),
        ),
        DropdownMenu(
          controller: categoryController,
          label: Text(
            'Catégorie',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          initialSelection: currentFilter.category,
          leadingIcon: currentFilter.category == null
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryController.clear();
                      currentFilter.category = null;
                    });
                    widget.onFilterChanged(currentFilter);
                  },
              child: Icon(Icons.cancel, size: 16.0,)
          ),
          onSelected: (NPCCategory? category) {
            setState(() {
              currentFilter.category = category;
              currentFilter.subCategory = null;
              subCategoryController.clear();
            });
            widget.onFilterChanged(currentFilter);
          },
          dropdownMenuEntries: NPCCategory.values
              .map(
                  (NPCCategory c) => DropdownMenuEntry(
                      value: c,
                      label: c.title
                  )
              )
              .toList(),
        ),
        if(currentFilter.category != null)
          DropdownMenu(
            controller: subCategoryController,
            label: Text(
              'Sous-catégorie',
              style: theme.textTheme.bodySmall,
            ),
            requestFocusOnTap: true,
            textStyle: theme.textTheme.bodySmall,
            initialSelection: currentFilter.subCategory,
            leadingIcon: currentFilter.subCategory == null
                ? null
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        subCategoryController.clear();
                        currentFilter.subCategory = null;
                      });
                      widget.onFilterChanged(currentFilter);
                },
                child: Icon(Icons.cancel, size: 16.0,)
            ),
            onSelected: (NPCSubCategory? subCategory) {
              setState(() {
                currentFilter.subCategory = subCategory;
              });
              widget.onFilterChanged(currentFilter);
            },
            dropdownMenuEntries: currentFilter.category == null
              ? <DropdownMenuEntry<NPCSubCategory>>[]
              : NPCSubCategory.subCategoriesForCategory(currentFilter.category!)
                  .map(
                      (NPCSubCategory s) => DropdownMenuEntry(
                          value: s, label: s.title
                      )
                  )
                  .toList(),
          ),
        SizedBox(
          width: 200.0,
          child: TextField(
            controller: searchController,
            style: theme.textTheme.bodySmall,
            decoration: InputDecoration(
              labelText: 'Recherche',
              labelStyle: theme.textTheme.bodySmall,
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
              prefixIcon: currentFilter.search == null
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.clear();
                          currentFilter.search = null;
                        });
                        widget.onFilterChanged(currentFilter);
                        FocusScope.of(context).unfocus();
                      },
                  child: Icon(Icons.cancel, size: 16.0,)
              ),
            ),
            onSubmitted: (String? value) {
              if(value == null || value.length >= 3) {
                setState(() {
                  currentFilter.search = value;
                });
                widget.onFilterChanged(currentFilter);
              }
            },
          ),
        ),
      ],
    );
  }
}