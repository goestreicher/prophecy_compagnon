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
import 'package:prophecy_compagnon_shared/classes/timeline/timeline.dart';
import 'package:prophecy_compagnon_shared/classes/timeline/world_events.dart';
import 'package:prophecy_compagnon_shared/ui/full_page_loading.dart';
import 'package:prophecy_compagnon_shared/ui/timeline/filter_widget.dart';
import 'package:prophecy_compagnon_shared/ui/timeline/timeline_widget.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({ super.key });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  WorldEventFilter filter = WorldEventFilter(age: KorAge.empires);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: TimelineEventFilterWidget(
            filter: filter,
            onFilterChanged: (WorldEventFilter f) {
              setState(() {
                filter = f;
              });
            }
          )
        ),
        FutureBuilder(
          future: WorldEvents.loadAll(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return FullPageLoadingWidget();
            }

            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
                child: Center(
                  child: TimelineWidget(
                    main: Timeline(
                      resolution: TimelineResolution.year,
                      events: WorldEvents.matching(filter).toList(),
                    ),
                    mainColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}