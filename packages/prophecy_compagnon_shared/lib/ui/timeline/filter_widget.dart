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
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/timeline/world_events.dart';

class TimelineEventFilterWidget extends StatefulWidget {
  const TimelineEventFilterWidget({
    super.key,
    this.filter,
    required this.onFilterChanged,
  });

  final WorldEventFilter? filter;
  final void Function(WorldEventFilter) onFilterChanged;

  @override
  State<TimelineEventFilterWidget> createState() => _TimelineEventFilterWidgetState();
}

class _TimelineEventFilterWidgetState extends State<TimelineEventFilterWidget> {
  final TextEditingController sourceTypeController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  late WorldEventFilter currentFilter;

  @override
  void initState() {
    super.initState();

    currentFilter = widget.filter ?? WorldEventFilter();
    sourceTypeController.text = currentFilter.sourceType?.title ?? '';
    sourceController.text = currentFilter.source?.name ?? '';
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
          initialSelection: currentFilter.age,
          label: Text(
            'Âge',
            style: theme.textTheme.bodySmall,
          ),
          textStyle: theme.textTheme.bodySmall,
          dropdownMenuEntries: KorAge.values
            .map((KorAge a) => DropdownMenuEntry(value: a, label: a.title))
            .toList(),
          onSelected: (KorAge? a) {
            if(a == null) return;
            currentFilter.age = a;
            widget.onFilterChanged(currentFilter);
          },
        ),
        // DropdownMenu(
        //   controller: sourceTypeController,
        //   label: Text(
        //     'Type de source',
        //     style: theme.textTheme.bodySmall,
        //   ),
        //   textStyle: theme.textTheme.bodySmall,
        //   initialSelection: currentFilter.sourceType,
        //   leadingIcon: currentFilter.sourceType == null
        //       ? null
        //       : GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           sourceTypeController.clear();
        //           currentFilter.sourceType = null;
        //           sourceController.clear();
        //           currentFilter.source = null;
        //         });
        //         widget.onFilterChanged(currentFilter);
        //       },
        //       child: Icon(Icons.cancel, size: 16.0,)
        //   ),
        //   onSelected: (ObjectSourceType? sourceType) {
        //     setState(() {
        //       currentFilter.sourceType = sourceType;
        //       sourceController.clear();
        //       currentFilter.source = null;
        //     });
        //     widget.onFilterChanged(currentFilter);
        //   },
        //   dropdownMenuEntries: ObjectSourceType.values
        //     .map(
        //       (ObjectSourceType s) => DropdownMenuEntry(
        //         value: s,
        //         label: s.title
        //       )
        //     )
        //     .toList(),
        // ),
        // DropdownMenu(
        //   controller: sourceController,
        //   enabled: currentFilter.sourceType != null,
        //   label: Text(
        //     'Source',
        //     style: theme.textTheme.bodySmall,
        //   ),
        //   textStyle: theme.textTheme.bodySmall,
        //   initialSelection: currentFilter.source,
        //   leadingIcon: currentFilter.source == null
        //     ? null
        //     : GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           sourceController.clear();
        //           currentFilter.source = null;
        //         });
        //         widget.onFilterChanged(currentFilter);
        //       },
        //       child: Icon(Icons.cancel, size: 16.0,)
        //   ),
        //   onSelected: (ObjectSource? source) {
        //     setState(() {
        //       currentFilter.source = source;
        //     });
        //     widget.onFilterChanged(currentFilter);
        //   },
        //   dropdownMenuEntries: currentFilter.sourceType == null
        //     ? <DropdownMenuEntry<ObjectSource>>[]
        //     : ObjectSource.forType(currentFilter.sourceType!)
        //         .map(
        //           (ObjectSource s) => DropdownMenuEntry(value: s, label: s.name)
        //         )
        //         .toList(),
        // ),
      ],
    );
  }
}