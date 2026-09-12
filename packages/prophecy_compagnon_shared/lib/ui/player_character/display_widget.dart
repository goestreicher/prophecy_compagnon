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
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/error_feedback.dart';
import 'package:prophecy_compagnon_shared/ui/full_page_loading.dart';

class PCDisplayWidget extends StatefulWidget {
  const PCDisplayWidget({
    super.key,
    required this.id
  });

  final String id;

  @override
  State<PCDisplayWidget> createState() => _PCDisplayWidgetState();
}

class _PCDisplayWidgetState extends State<PCDisplayWidget> {
  late Future<PlayerCharacter?> pcFuture;

  @override
  void initState() {
    super.initState();
    pcFuture = PlayerCharacterStore().get(widget.id);
  }

  @override
  void didUpdateWidget(PCDisplayWidget old) {
    super.didUpdateWidget(old);
    pcFuture = PlayerCharacterStore().get(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pcFuture,
      builder: (BuildContext context, AsyncSnapshot<PlayerCharacter?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if(snapshot.hasError) {
          return FullPageErrorWidget(message: snapshot.error!.toString(), canPop: false);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(message: 'PJ ${widget.id} non trouvé', canPop: false);
        }

        PlayerCharacter pc = snapshot.data!;
        return CharacterDisplayWidget(
          character: pc,
        );
      },
    );
  }
}