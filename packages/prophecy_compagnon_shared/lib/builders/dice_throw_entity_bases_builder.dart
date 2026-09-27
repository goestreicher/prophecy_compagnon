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

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:prophecy_compagnon_shared/builders/dice_throw_entity_bases_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder registerDiceThrowEntityBasesBuilder(BuilderOptions options) {
  var defaults = BuilderOptions({
    'output': 'lib/classes/dice/register_dice_throw_entity_bases.dart'
  });

  var opts = options.overrideWith(defaults);

  return RegisterDiceThrowEntityBasesBuilder(options: opts);
}

class RegisterDiceThrowEntityBasesBuilder implements Builder {
  RegisterDiceThrowEntityBasesBuilder({ required this.options })
      : generator = RegisterDiceThrowEntityBaseGenerator();

  final BuilderOptions options;
  final RegisterDiceThrowEntityBaseGenerator generator;

  @override
  Map<String, List<String>> get buildExtensions => {
    r'lib/$lib$': [options.config['output']],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    var buffer = StringBuffer(
      '// GENERATED CODE - DO NOT EDIT\n\n'
      'import "package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart";\n'
    );
    var functionBuffer = StringBuffer(
      'void registerDiceThrowEntityBases() {\n'
    );

    await for(var input in buildStep.findAssets(Glob('lib/**.dart'))) {
      if(!(await buildStep.resolver.isLibrary(input))) continue;
      var generated = generator.generate(
        LibraryReader(await buildStep.resolver.libraryFor(input)),
        buildStep,
      );
      if(generated.isNotEmpty) {
        buffer.write('import "${input.uri}";\n');
        functionBuffer.write(generated);
        functionBuffer.write('\n');
      }
    }

    functionBuffer.write('}\n');
    buffer.write('\n');
    buffer.write(functionBuffer.toString());

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, options.config['output']), buffer.toString());
  }
}