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

import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';

class MultiResourceLinkProvider extends ResourceLinkProvider {
  const MultiResourceLinkProvider({ required this.providers });

  final List<ResourceLinkProvider> providers;

  @override
  List<String> sourceNames() => [
      for(var p in providers)
        ...(p.sourceNames())
    ];

  @override
  List<ResourceLinkType> availableTypes() => {
      for(var p in providers)
        ...(p.availableTypes())
    }.toList();

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    for(var p in providers) {
      if(sourceName == null || p.sourceNames().contains(sourceName)) {
        ret.addAll(await p.linksForType(type));
      }
    }

    return ret;
  }
}