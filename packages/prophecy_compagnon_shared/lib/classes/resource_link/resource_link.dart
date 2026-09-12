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

import 'package:json_annotation/json_annotation.dart';

part 'resource_link.g.dart';

enum ResourceLinkType {
  creature(title: 'Créature'),
  encounter(title: 'Rencontre'),
  faction(title: 'Faction'),
  map(title: 'Carte'),
  npc(title: 'PNJ'),
  pc(title: 'PJ'),
  place(title: 'Lieu'),
  star(title: 'Étoile'),
  ;

  const ResourceLinkType({ required this.title });

  final String title;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ResourceLink {
  ResourceLink({
    required this.name,
    required this.link,
    this.label,
    this.clickable = true,
  }) {
    if(!ResourceLink.isValidLink(link)) {
      throw(FormatException('Invalid link URI $link'));
    }

    uri = Uri.parse(link);
    type = ResourceLinkType.values.asNameMap()[uri.pathSegments[0]]!;
    id = uri.pathSegments.last;
  }

  String name;
  String link;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? label;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool clickable;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late ResourceLinkType type;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late String id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late Uri uri;

  static bool isValidLink(String link) {
    var uri = Uri.tryParse(link);
    return uri != null
        && uri.scheme == 'resource'
        && ResourceLinkType.values.asNameMap().containsKey(uri.pathSegments[0]);
  }

  static ResourceLink createLinkForResource(ResourceLinkType type, bool local, String display, String id, {String? label}) {
    return ResourceLink(
      name: display,
      link: 'resource://${local ? "store" : "assets"}/${type.name}/$id',
      label: label,
    );
  }

  factory ResourceLink.fromJson(Map<String, dynamic> json) =>
      _$ResourceLinkFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResourceLinkToJson(this);
}

abstract class ResourceLinkProvider {
  const ResourceLinkProvider();

  List<String> sourceNames();
  List<ResourceLinkType> availableTypes();
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName });
}