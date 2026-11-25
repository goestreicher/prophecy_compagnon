// GENERATED CODE - DO NOT EDIT

import "package:prophecy_compagnon_shared/classes/dice/throw_matcher.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/ability.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/attribute.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/boolean.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/magic_skill.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/request_context.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/skill.dart";
import "package:prophecy_compagnon_shared/classes/dice/throw_matchers/skill_family.dart";

void registerDiceThrowMatchers() {
  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "AbilityDiceThrowMatcher",
    (Map<String, dynamic> json) => AbilityDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "AttributeDiceThrowMatcher",
    (Map<String, dynamic> json) => AttributeDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "BooleanOrDiceThrowMatcher",
    (Map<String, dynamic> json) => BooleanOrDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "BooleanAndDiceThrowMatcher",
    (Map<String, dynamic> json) => BooleanAndDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "MagicSkillDiceThrowMatcher",
    (Map<String, dynamic> json) => MagicSkillDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "ThrowRequestContextDiceThrowMatcher",
    (Map<String, dynamic> json) => ThrowRequestContextDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "SkillDiceThrowMatcher",
    (Map<String, dynamic> json) => SkillDiceThrowMatcher.fromJson(json),
  );

  DiceThrowMatcher.registerDiceThrowMatcherJsonFactory(
    "SkillFamilyDiceThrowMatcher",
    (Map<String, dynamic> json) => SkillFamilyDiceThrowMatcher.fromJson(json),
  );

}
