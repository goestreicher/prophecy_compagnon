/*
 * Copyright (C) 2024-2026 Grégory Oestreicher
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
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_mj/ui/app_routes.dart';
import 'package:prophecy_compagnon_mj/ui/main_page.dart';
import 'package:prophecy_compagnon_shared/classes/storage/storage.dart';
import 'package:prophecy_compagnon_shared/register_store_adapters.dart';

final _goRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainPage(pageWidget: child);
      },
      routes: buildRouteList(),
    )
  ]
);

void main() async {
  usePathUrlStrategy();
  await DataStorage.instance.init();
  registerStoreAdapters();
  runApp(const ProphecyCompanionApp());
}

class ProphecyCompanionApp extends StatelessWidget {
  const ProphecyCompanionApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prophecy Compagnon',
      routerConfig: _goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
        useMaterial3: true,
        tooltipTheme: TooltipTheme.of(context).copyWith(
          waitDuration: Durations.medium1,
        ),
      ),
    );
  }
}