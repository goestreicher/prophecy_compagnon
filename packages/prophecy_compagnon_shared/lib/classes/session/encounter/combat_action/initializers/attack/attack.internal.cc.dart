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

part of 'attack.dart';

Future<void> _manageGeneralCritical(BuildContext context, int result, ActionInitializerAttackContext attackContext) async {
  if(result == 1) {
    _ccChoc(attackContext: attackContext);
  }
  else if(result == 2) {
    _ccDouleur(attackContext: attackContext);
  }
  else if(result == 3) {
    _ccSonne(attackContext: attackContext);
  }
  else if(result == 4) {
    Injury injury = Injury.light;
    try {
      attackContext.target.injuries.manager.capacity(injury);
    }
    on ArgumentError {
      injury = Injury.injured;
    }

    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Hémorragie mineure',
          trigger: EntityEffectTrigger.tickerEvent,
          triggerTickerEvent: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.turn,
          ),
          removeOnUnapply: true,
          statusMessageText:
            "La plaie saigne abondamment. À la fin de ce tour, "
            "${attackContext.target.name} subit une blessure légère "
            "supplémentaire.",
          injury: injury,
          count: 1,
        ),
      )
    );
  }
  else if(result == 5) {
    _ccCicatrice(attackContext: attackContext);
  }
  else if(result == 6) {
    attackContext.inflictedInjuryProperties = InflictedInjuryProperties(
      canUseHealingMethod: false,
    );
    attackContext.damageEffectMessageTitle = 'Coup critique - Fracture';
    attackContext.damageEffectMessageText =
      "Le coup a brisé un os de l'épaule, de la hanche ou de l'avant-bras."
      "${attackContext.target.name} ne pourra pas réduire le temps de "
      "rétablissement de cette blessure quels que soient les jets de soins ou "
      "les potions consommées (mais la magie reste utilisable).";
  }
  else if(result == 7) {
    _ccMainDArme(attackContext: attackContext);
  }
  else if(result == 8) {
    _ccArmure(attackContext: attackContext);
  }
  else if(result == 9) {
    attackContext.ignoreArmor = true;
    attackContext.damage += 20;
    attackContext.damageEffectMessageTitle = 'Coup critique - Défaut';
    attackContext.damageEffectMessageText =
      "L'armure de ${attackContext.target.name} est touchée dans une zone "
      "fragile et ne compte pas. Les dommages de l'attaque sont augmentés de 20 "
      "mais l'armure ne réduit pas son Indice de protection";
  }
  else if(result == 10) {
    var willInflict = attackContext.target.injuries.manager
        .willInflictInjuryForDamage(attackContext.damage);

    attackContext.damageEffectMessageTitle = 'Coup critique - Amputation';
    attackContext.damageEffectMessageText =
      "Un des membres de ${attackContext.target.name} a été sérieusement touché.";

    if(willInflict == Injury.grave) {
      attackContext.damageEffectMessageText =
          "${attackContext.damageEffectMessageText}\n"
          "Une articulation est détruite et rend le membre inutilisable "
          "pendant cinq jours.";
    }
    else if(willInflict == Injury.fatal) {
      attackContext.damageEffectMessageText =
          "${attackContext.damageEffectMessageText}\n"
          "Le membre est déchiqueté au niveau de l'articulation.";
    }

    attackContext.damageEffectMessageText =
        "${attackContext.damageEffectMessageText}\n"
        "L'hémorragie qui s'ensuit provoque une blessure légère supplémentaire "
        "tous les trois tours tant qu'elle n'est pas stoppée.";

    Injury injury = Injury.light;
    try {
      attackContext.target.injuries.manager.capacity(injury);
    }
    on ArgumentError {
      injury = Injury.injured;
    }

    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Amputation',
          trigger: EntityEffectTrigger.permanent,
          frequency: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.turn,
            count: 3,
          ),
          removeOnUnapply: true,
          statusMessageText: attackContext.damageEffectMessageText,
          injury: injury,
          count: 1,
        )
      )
    );
  }
}

Future<void> _manageDragonCritical(BuildContext context, int result, ActionInitializerAttackContext attackContext) async {
  if(result == 1) {
    _ccChoc(attackContext: attackContext);
  }
  else if(result == 2) {
    _ccSonne(attackContext: attackContext);
  }
  else if(result == 3) {
    attackContext.attackEffects.addAll([
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectGlobalDiceThrowModifier(
          name: 'Coup critique - Maîtrise',
          trigger: EntityEffectTrigger.permanent,
          duration: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.turn,
            count: 1,
          ),
          statusMessageText:
            "${attackContext.attacker.name} a dérouté son adversaire. Il voit "
            "la Difficulté de sa prochaine action de défense pour ce tour "
            "réduite de 5.",
          type: DiceThrowModifierType.difficulty,
          family: DiceThrowModifierFamily.attackEffect,
          modifier: -5,
          singleUse: true,
          matcher: ThrowRequestContextDiceThrowMatcher(
            context: DiceThrowRequestContext.defense,
          ),
        ),
      ),
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectGainProficiency(
          name: 'Coup critique - Maîtrise',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "${attackContext.attacker.name} a dérouté son adversaire. Il "
            "regagne 2 points de Maîtrise.",
          amount: 2,
        )
      ),
    ]);
  }
  else if(result == 4) {
    attackContext.cumulativeAttackMalus = 0;
    attackContext.damageEffectMessageTitle = 'Coup critique - Recul';
    attackContext.damageEffectMessageText =
      "La violence du coup met ${attackContext.target.name} en déséquilibre et "
      "${attackContext.attacker.name} se replace. Il pourra porter sa prochaine "
      "attaque sans Difficulté supplémentaire.";
  }
  else if(result == 5) {
    _ccArmure(attackContext: attackContext);
  }
  else if(result == 6) {
    attackContext.damageEffectMessageTitle = 'Coup critique - Débordement';
    attackContext.damageEffectMessageText =
      "${attackContext.attacker.name} réussit une manœuvre particulièrement "
      "habile. Jusqu'à la fin du prochain tour, ${attackContext.target.name} "
      " ne peut plus effectuer que des actions de défense.";
  }
  else if(result == 7) {
    int? choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
        title: Text('Coup critique - Conviction'),
        children: [
          Text("L'attaquant peut regagner tous ses points de Chance ou de Maîtrise, au choix :"),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(1);
            },
            child: Text('Regagner tous les points de Maîtrise'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(2);
            },
            child: Text('Regagner tous les points de Chance'),
          ),
        ],
      )
    );
    if(!context.mounted) return;

    EntityEffect effect;
    if(choice! == 1) {
      effect = EntityEffectGainProficiency(
        name: 'Coup critique - Conviction',
        trigger: EntityEffectTrigger.once,
        statusMessageText:
          "La précision de son coup insuffle un regain d'énergie à "
          "${attackContext.attacker.name}. Il regagne instantanément tous ses "
          "points de Maîtrise.",
        amount: 10,
      );
    }
    else {
      effect = EntityEffectGainLuck(
        name: 'Coup critique - Conviction',
        trigger: EntityEffectTrigger.once,
        statusMessageText:
          "La précision de son coup insuffle un regain d'énergie à "
          "${attackContext.attacker.name}. Il regagne instantanément tous ses "
          "points de Chance.",
        amount: 10,
      );
    }

    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: effect,
      )
    );
  }
  else if(result == 8) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectInitiativeExtraDice(
          name: 'Coup critique - Tactique',
          trigger: EntityEffectTrigger.permanent,
          duration: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.turn,
            count: 2,
          ),
          removeOnUnapply: true,
          statusMessageText:
            "${attackContext.attacker.name} réussit une manœuvre habile. Au "
            "début du prochain tour, il pourra lancer deux dés d'Initiative "
            "supplémentaires et conserver les meilleurs.",
          count: 2
        )
      )
    );
  }
  else if(result == 9) {
    _ccHemorragie(attackContext: attackContext);
  }
  else if(result == 10) {
    Armor? armor;
    for(var pp in attackContext.target.protectionProviders) {
      if(pp is! Armor) continue;
      armor = pp;
    }

    var description =
        "Le coup broie la cage thoracique de ${attackContext.target.name}. "
        "L'Indice de protection de l'armure est divisé par 2 et les dommages "
        "sont augmentés de 10. Si ${attackContext.target.name} ne porte pas "
        "d'armure, les dommages sont augmentés de 20.";

    if(armor == null) {
      attackContext.damage += 20;
      attackContext.damageEffectMessageTitle = 'Coup critique - Écrasement';
      attackContext.damageEffectMessageText = description;
    }
    else {
      attackContext.damage += 10;
      attackContext.attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackContext.target.id,
          effect: EntityEffectDamageArmor(
            name: 'Coup critique - Écrasement',
            trigger: EntityEffectTrigger.once,
            statusMessageText: description,
            armorId: armor.uuid(),
            damage: (armor.protection() / 2).ceil(),
          ),
        )
      );
    }
  }
  else if(result == 11) {
    _ccMembreTranche(attackContext: attackContext);
  }
  else if(result == 12) {
    _ccDefautCritique(attackContext: attackContext);
  }
  else if(result == 13) {
    _ccCoupMortel(attackContext: attackContext);
  }
  else if(result == 14) {
    _ccCoupMagistral(attackContext: attackContext);
  }
  else if(result == 15) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Guidé par Kroryn',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Un éclair foudroyant déchire le ciel et s'abat sur "
            "${attackContext.target.name}, qui meurt sur le coup (sauf si "
            "c'est un dragon).",
          injury: Injury.death,
        )
      )
    );
  }
}

Future<void> _manageFatalityCritical(BuildContext context, int result, ActionInitializerAttackContext attackContext) async {
  if(result == 1) {
    _ccChoc(attackContext: attackContext);
  }
  else if(result == 2) {
    _ccDouleur(attackContext: attackContext);
  }
  else if(result == 3) {
    _ccCicatrice(attackContext: attackContext);
  }
  else if(result == 4) {
    _ccArmure(attackContext: attackContext);
  }
  else if(result == 5) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectGlobalDiceThrowModifier(
          name: 'Coup critique - Doute',
          trigger: EntityEffectTrigger.permanent,
          duration: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.combat,
            count: 1,
          ),
          removeOnUnapply: true,
          statusMessageText:
            "Le coup sème la confusion dans l'esprit de "
            "${attackContext.target.name}. Jusqu'à la fin du combat, la "
            "Difficulté de toutes ses actions est augmentée de 2.",
          type: DiceThrowModifierType.difficulty,
          family: DiceThrowModifierFamily.attackEffect,
          modifier: 2,
        ),
      )
    );
  }
  else if(result == 6) {
    _ccHemorragie(attackContext: attackContext);
  }
  else if(result == 7) {
    attackContext.damageEffectMessageTitle = 'Coup critique - Terreur';
    attackContext.damageEffectMessageText =
      "${attackContext.target.name} est si ébranlé qu'il croit son heure "
      "arrivée. Jusqu'à la fin du combat, il ne peut plus porter qu'une seule "
      "attaque par tour contre ${attackContext.attacker.name}";
  }
  else if(result == 8) {
    _ccMembreTranche(attackContext: attackContext);
  }
  else if(result == 9) {
    _ccFaille(attackContext: attackContext);
  }
  else if(result == 10) {
    Injury injury = Injury.light;
    try {
      attackContext.target.injuries.manager.capacity(injury);
    }
    on ArgumentError {
      injury = Injury.injured;
    }

    var injuryCount =
        attackContext.target.injuries.manager.capacity(injury)
        - attackContext.target.injuries.manager.inflicted(injury).length;

    attackContext.attackEffects.addAll([
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Blessure incurable',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Le coup déchire profondément les chairs. "
            "${attackContext.target.name} doit noircir toutes ses cases de "
            "blessure légère.",
          injury: injury,
          count: injuryCount,
        )
      ),
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectAddDisadvantage(
          name: 'Coup critique - Blessure incurable',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Le coup déchire profondément les chairs. "
            "${attackContext.target.name} gagne instantanément le"
            "Désavantage Blessure.",
          disadvantage: CharacterDisadvantage(
            disadvantage: Disadvantage.blessure,
            cost: Disadvantage.blessure.cost[0],
            details: "Coup critique - Blessure incurable"
          )
        )
      ),
    ]);
  }
  else if(result == 11) {
    _ccDefautCritique(attackContext: attackContext);
  }
  else if(result == 12) {
    _ccCoupMortel(attackContext: attackContext);
  }
  else if(result == 13) {
    _ccCoupMagistral(attackContext: attackContext);
  }
  else if(result == 14) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: "Coup critique - L'ultime soupir",
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "${attackContext.attacker.name} perfore une zone vitale et se "
            "retrouve aspergé du sang de ${attackContext.target.name}. Ce "
            "dernier meurt sur le coup et ${attackContext.attacker.name} peut "
            "effacer trois cases de blessure de son choix.",
          injury: Injury.death,
        )
      )
    );
  }
  else if(result == 15) {
    var attribute = await showDialog<Attribute>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Coup critique - Le sang de l'Immortel"),
        children: [
          Text(
            "${attackContext.attacker.name} gagne 1 point dans l'Attribut "
            "Majeur de son choix"
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(Attribute.physique);
            },
            child: const Text('+1 en Physique'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(Attribute.manuel);
            },
            child: const Text('+1 en Manuel'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(Attribute.mental);
            },
            child: const Text('+1 en Mental'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(Attribute.social);
            },
            child: const Text('+1 en Social'),
          ),
        ],
      )
    );
    if(!context.mounted) return;

    attackContext.attackEffects.addAll([
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: "Coup critique - Le sang de l'Immortel",
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "${attackContext.target.name} meurt sur le coup.",
          injury: Injury.death,
        )
      ),
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectChangeAttribute(
          name: "Coup critique - Le sang de l'Immortel",
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "${attackContext.attacker.name} gagne instantanément 1 point dans "
            "l'Attribut Majeur de son choix.",
          attribute: attribute!,
          delta: 1
        )
      ),
    ]);
  }
}

Future<void> _manageHumanCritical(BuildContext context, int result, ActionInitializerAttackContext attackContext) async {
  if(result == 1) {
    _ccChoc(attackContext: attackContext);
  }
  else if(result == 2) {
    _ccSonne(attackContext: attackContext);
  }
  else if(result == 3) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectInitiativeExtraDice(
          name: 'Coup critique - Surpris',
          trigger: EntityEffectTrigger.permanent,
          duration: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.turn,
            count: 2,
          ),
          removeOnUnapply: true,
          statusMessageText:
            "${attackContext.target.name} est pris au dépourvu. "
            "${attackContext.attacker.name} lancera un dé supplémentaire "
            "d'Initiative au prochain tour et conservera les meilleurs.",
          count: 1
        )
      )
    );
  }
  else if(result == 4) {
    _ccArmure(attackContext: attackContext);
  }
  else if(result == 5) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectGainProficiency(
          name: 'Coup critique - Technique',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Le coup est particulièrement adroit et spectaculaire. "
            "${attackContext.attacker.name} regagne instantanément tous ses "
            "points de Maîtrise.",
          amount: 10,
        )
      )
    );
  }
  else if(result == 6) {
    _ccMainDArme(attackContext: attackContext);
  }
  else if(result == 7) {
    _ccFaille(attackContext: attackContext);
  }
  else if(result == 8) {
    attackContext.ignoreArmor = true;
    attackContext.attackEffects.addAll([
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectGainLuck(
          name: 'Coup critique - Coup de chance',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "L'armure de ${attackContext.target.name} n'est pas prise en "
            "compte. ${attackContext.attacker.name} regagne instantanément "
            "tous ses points de Chance.",
          amount: 10,
        )
      )
    ]);
  }
  else if(result == 9) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.attacker.id,
        effect: EntityEffectGlobalDiceThrowModifier(
          name: 'Coup critique - Anticipation',
          trigger: EntityEffectTrigger.permanent,
          duration: TickerEvent(
            type: TickerEventType.end,
            unit: TickerEventUnit.combat,
            count: 1,
          ),
          removeOnUnapply: true,
          statusMessageText:
            "Le coup fait perdre ses moyens à ${attackContext.target.name}. "
            "Jusqu'à la fin du combat, ${attackContext.attacker.name} voit la "
            "Difficulté de tous ses jets de défense réduite de 5 contre cet "
            "adversaire.",
          type: DiceThrowModifierType.difficulty,
          family: DiceThrowModifierFamily.attackEffect,
          modifier: -5,
          alwaysApply: false,
          matcher: ThrowRequestContextDiceThrowMatcher(
            context: DiceThrowRequestContext.defense
          ),
        ),
      )
    );
  }
  else if(result == 10) {
    _ccDefautCritique(attackContext: attackContext);
  }
  else if(result == 11) {
    _ccCoupMortel(attackContext: attackContext);
  }
  else if(result == 12) {
    _ccCoupMagistral(attackContext: attackContext);
  }
  else if(result == 13) {
    var choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Coup de maître'),
        children: [
          Text(
            "${attackContext.target.name} est totalement pris au dépourvu. "
            "${attackContext.attacker.name} parvient à le tenir en respect et "
            "peut lui infliger une blessure fatale ou lui laisser une chance "
            "de se rendre. Dans ce cas, ${attackContext.attacker.name} peut "
            "effacer tous ses cercles de Tendance Dragon et Fatalité s'il le "
            "désire."
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(0);
            },
            child: const Text('Infliger 1 blessure fatale'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(1);
            },
            child: const Text('Accepter la reddition'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(2);
            },
            child: const Text('Accepter la reddition et effacer les cercles de Tendances'),
          )
        ],
      )
    );
    if(!context.mounted) return;

    if(choice! == 0) {
      attackContext.attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackContext.target.id,
          effect: EntityEffectInjury(
            name: "Coup critique - Coup de maître",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.target.name} est totalement pris au dépourvu. "
              "${attackContext.attacker.name} parvient à le tenir en respect et "
              "lui inflige une blessure fatale.",
            injury: Injury.fatal,
          )
        )
      );
    }
    else if(choice == 2) {
      attackContext.attackEffects.addAll([
        SessionEntityAddEffectMessage(
          entityId: attackContext.attacker.id,
          effect: EntityEffectSetTendencyCircles(
            name: "Coup critique - Coup de maître",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.target.name} est totalement pris au dépourvu. "
              "${attackContext.attacker.name} parvient à le tenir en respect et "
              "choisit de l'épargner. Il efface tous ses cercles de Tendance "
              "Dragon.",
            tendency: Tendency.dragon,
            value: 0,
          )
        ),
        SessionEntityAddEffectMessage(
          entityId: attackContext.attacker.id,
          effect: EntityEffectSetTendencyCircles(
            name: "Coup critique - Coup de maître",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.target.name} est totalement pris au dépourvu. "
              "${attackContext.attacker.name} parvient à le tenir en respect et "
              "choisit de l'épargner. Il efface tous ses cercles de Tendance "
              "Fatalité.",
            tendency: Tendency.fatality,
            value: 0,
          )
        ),
      ]);
    }
  }
  else if(result == 14) {
    var choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Suprématie'),
        children: [
          Text(
            "${attackContext.target.name} tombe à terre et perd son arme, "
            "qui arrive automatiquement dans la main de "
            "${attackContext.attacker.name}. Celui-ci peut lui laisser une "
            "chance de se rendre ou l'achever sans effort. Si le défenseur "
            "est épargné, l'attaquant gagne 3 Point d'Expérience et peut "
            "effacer tous ses cercles de Tendance Dragon et Fatalité."
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(0);
            },
            child: Text('Achever ${attackContext.target.name}'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(1);
            },
            child: const Text('Accepter la reddition, +3 XP'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(2);
            },
            child: const Text('Accepter la reddition, +3 XP et effacer les cercles de Tendances'),
          )
        ],
      )
    );
    if(!context.mounted) return;

    if(choice! == 0) {
      attackContext.attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackContext.target.id,
          effect: EntityEffectInjury(
            name: "Coup critique - Suprématie",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.target.name} tombe à terre et perd son arme, "
              "qui arrive automatiquement dans la main de "
              "${attackContext.attacker.name}. Celui-ci décide de  l'achever "
              "sans effort.",
            injury: Injury.death,
          )
        )
      );
    }
    else {
      attackContext.attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackContext.attacker.id,
          effect: EntityEffectGainExperience(
            name: "Coup critique - Suprématie",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.target.name} tombe à terre et perd son arme, "
              "qui arrive automatiquement dans la main de "
              "${attackContext.attacker.name}. Celui-ci lui laisse une "
              "chance de se rendre et il gagne 3 Point d'Expérience.",
            amount: 3,
          )
        )
      );

      if(choice == 2) {
        attackContext.attackEffects.addAll([
          SessionEntityAddEffectMessage(
            entityId: attackContext.attacker.id,
            effect: EntityEffectSetTendencyCircles(
              name: "Coup critique - Suprématie",
              trigger: EntityEffectTrigger.once,
              statusMessageText:
                "${attackContext.target.name} tombe à terre et perd son arme, "
                "qui arrive automatiquement dans la main de "
                "${attackContext.attacker.name}. Celui-ci lui laisse une "
                "chance de se rendre et il efface tous ses cercles de Tendance "
                "Dragon.",
              tendency: Tendency.dragon,
              value: 0,
            )
          ),
          SessionEntityAddEffectMessage(
            entityId: attackContext.attacker.id,
            effect: EntityEffectSetTendencyCircles(
              name: "Coup critique - Suprématie",
              trigger: EntityEffectTrigger.once,
              statusMessageText:
                "${attackContext.target.name} tombe à terre et perd son arme, "
                "qui arrive automatiquement dans la main de "
                "${attackContext.attacker.name}. Celui-ci lui laisse une "
                "chance de se rendre et il efface tous ses cercles de Tendance "
                "Fatalité.",
              tendency: Tendency.fatality,
              value: 0,
            )
          ),
        ]);
      }
    }
  }
  else if(result == 15) {
    var choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Le dénouement'),
        children: [
          Text(
            "${attackContext.attacker.name} peut achever son adversaire s'il "
            "le désire. S'il choisit de l'épargner, ${attackContext.target.name} "
            "cesse instantanément le combat et devient redevable à vie d'une "
            "dette envers ${attackContext.attacker.name}. Sa philosophie est "
            "ébranlée et ses convictions remises en jeu."
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(0);
            },
            child: Text('Achever ${attackContext.target.name}'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop(1);
            },
            child: Text('Épargner ${attackContext.target.name}'),
          ),
        ],
      )
    );
    if(!context.mounted) return;

    if(choice! == 0) {
      attackContext.attackEffects.add(
        SessionEntityAddEffectMessage(
          entityId: attackContext.target.id,
          effect: EntityEffectInjury(
            name: "Coup critique - Suprématie",
            trigger: EntityEffectTrigger.once,
            statusMessageText:
              "${attackContext.attacker.name} décide d'achever "
              "${attackContext.target.name}.",
            injury: Injury.death,
          )
        )
      );
    }
  }
}

void _ccChoc({
  required ActionInitializerAttackContext attackContext,
}) {
  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectGlobalDiceThrowModifier(
        name: 'Coup critique - Choc',
        trigger: EntityEffectTrigger.permanent,
        duration: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.action,
          count: attackContext.defenseCombatAction == null ? 1 : 2,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "${attackContext.target.name} oscille sous la violence du choc. "
          "La Difficulté de sa prochaine action est augmentée de 5.",
        type: DiceThrowModifierType.difficulty,
        family: DiceThrowModifierFamily.attackEffect,
        modifier: 5,
      ),
    )
  );
}

void _ccDouleur({
  required ActionInitializerAttackContext attackContext,
}) {
  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectDamageMalusModifier(
        name: 'Coup critique - Douleur',
        trigger: EntityEffectTrigger.permanent,
        duration: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.combat,
          count: 1,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "Le coup a atteint une zone particulièrement douloureuse. "
          "Tous les malus liés aux blessures de ${attackContext.target.name} "
          "sont augmentés de 1 jusqu'à la fin du combat.",
        value: 1,
      ),
    )
  );
}

void _ccSonne({
  required ActionInitializerAttackContext attackContext,
}) {
  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectGlobalDiceThrowModifier(
        name: 'Coup critique - Sonné',
        trigger: EntityEffectTrigger.permanent,
        duration: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.turn,
          count: 2,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "${attackContext.target.name} accuse violemment le coup. La "
          "Difficulté de toutes ses actions est augmentée de 5 jusqu'à la fin "
          "du tour suivant.",
        type: DiceThrowModifierType.difficulty,
        family: DiceThrowModifierFamily.attackEffect,
        modifier: 5,
      ),
    )
  );
}

void _ccCicatrice({
  required ActionInitializerAttackContext attackContext,
}) {
  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectChangeAbility(
        name: 'Coup critique - Cicatrice',
        trigger: EntityEffectTrigger.once,
        statusMessageText:
          "Une fois refermée, la blessure laissera une marque disgracieuse. "
          "${attackContext.target.name} perd définitivement 1 point de Présence.",
        ability: Ability.presence,
        delta: -1,
      ),
    )
  );
}

void _ccMainDArme({
  required ActionInitializerAttackContext attackContext,
}) {
  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectGlobalDiceThrowModifier(
        name: "Coup critique - Main d'arme",
        trigger: EntityEffectTrigger.permanent,
        duration: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.hour,
          count: 24,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "Le coup a atteint la main d'arme de ${attackContext.target.name}. "
          "La Difficulté de toutes ses actions de combat est augmentée de 5 "
          "pour les 24 heures à venir.",
        type: DiceThrowModifierType.difficulty,
        family: DiceThrowModifierFamily.attackEffect,
        modifier: 5,
      ),
    )
  );
}

void _ccArmure({
  required ActionInitializerAttackContext attackContext,
}) {
  Armor? armor;
  for(var pp in attackContext.target.protectionProviders) {
    if(pp is! Armor) continue;
    armor = pp;
  }

  var description =
      "Le coup a sérieusement endommagé l'armure de ${attackContext.target.name}. "
      "Son Indice de protection est divisé par 2 et la Difficulté des jets de "
      "réparation est doublée. S'il ne porte pas d'armure, il subit une "
      "blessure grave de plus.";

  if(armor == null) {
    Injury injury = Injury.grave;
    try {
      attackContext.target.injuries.manager.capacity(injury);
    }
    on ArgumentError {
      injury = Injury.injured;
    }

    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Armure',
          trigger: EntityEffectTrigger.once,
          statusMessageText: description,
          injury: injury,
          count: 1,
        ),
      )
    );
  }
  else {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectDamageArmor(
          name: 'Coup critique - Armure',
          trigger: EntityEffectTrigger.once,
          statusMessageText: description,
          armorId: armor.uuid(),
          damage: (armor.protection() / 2).ceil(),
          repairDifficultyMultiplier: 2,
        ),
      )
    );
  }
}

void _ccHemorragie({
  required ActionInitializerAttackContext attackContext,
}) {
  Injury injury = Injury.scratch;
  try {
    attackContext.target.injuries.manager.capacity(injury);
  }
  on ArgumentError {
    injury = Injury.injured;
  }

  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectInjury(
        name: 'Coup critique - Hémorragie',
        trigger: EntityEffectTrigger.permanent,
        frequency: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.turn,
          count: 1,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "La plaie saigne abondamment. À la fin de chaque tour, "
          "${attackContext.target.name} subit automatiquement une nouvelle "
          "blessure, en commençant par les égratignures.",
        injury: injury,
        count: 1,
      )
    )
  );
}

void _ccMembreTranche({
    required ActionInitializerAttackContext attackContext,
}) {
  attackContext.damageEffectMessageTitle = 'Coup critique - Membre tranché';
  attackContext.damageEffectMessageText =
      "Le coup est si violent qu'il tranche ou déchiquète instantanément un "
      "membre de ${attackContext.target.name}, provoquant une hémorragie";

  Injury injury = Injury.scratch;
  try {
    attackContext.target.injuries.manager.capacity(injury);
  }
  on ArgumentError {
    injury = Injury.injured;
  }

  attackContext.attackEffects.add(
    SessionEntityAddEffectMessage(
      entityId: attackContext.target.id,
      effect: EntityEffectInjury(
        name: 'Coup critique - Hémorragie',
        trigger: EntityEffectTrigger.permanent,
        frequency: TickerEvent(
          type: TickerEventType.end,
          unit: TickerEventUnit.turn,
          count: 1,
        ),
        removeOnUnapply: true,
        statusMessageText:
          "La plaie saigne abondamment. À la fin de chaque tour, "
          "${attackContext.target.name} subit automatiquement une nouvelle "
          "blessure, en commençant par les égratignures.",
        injury: injury,
        count: 1,
      )
    )
  );
}

void _ccFaille({
    required ActionInitializerAttackContext attackContext
}) {
  attackContext.ignoreArmor = true;
  attackContext.damageEffectMessageTitle = "Coup critique - Faille";
  attackContext.damageEffectMessageText =
      "${attackContext.attacker.name} parvient à frapper une zone malheureusement "
      "dépourvue de protection à cet instant du combat. L'armure de "
      "${attackContext.target.name} n'est pas prise en compte.";
}

void _ccDefautCritique({
  required ActionInitializerAttackContext attackContext,
}) {
  bool hasOneGrave = false;
  try {
    var capacity = attackContext.target.injuries.manager.capacity(Injury.grave);
    hasOneGrave = capacity < 2;
  }
  on ArgumentError {
    hasOneGrave = true;
  }

  if(hasOneGrave) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Défaut critique',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Comme ${attackContext.target.name} ne dispose que d'une seule "
            "case de blessure grave, il meurt sur le coup.",
          injury: Injury.death,
        )
      )
    );
  }
  else {
    attackContext.damage += 10;
    attackContext.ignoreArmor = true;
    attackContext.damageEffectMessageTitle = 'Coup critique - Défaut critique';
    attackContext.damageEffectMessageText =
      "L'armure de ${attackContext.target.name} n'est pas prise en compte et "
      "les dommages sont augmentés de 10.";
  }
}

void _ccCoupMortel({
  required ActionInitializerAttackContext attackContext,
}) {
  bool hasOneFatal = false;
  try {
    var capacity = attackContext.target.injuries.manager.capacity(Injury.fatal);
    hasOneFatal = capacity < 2;
  }
  on ArgumentError {
    hasOneFatal = true;
  }

  if(hasOneFatal) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Coup mortel',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Comme ${attackContext.target.name} ne dispose que d'une seule case "
            "de blessure fatale, il meurt sur le coup.",
          injury: Injury.death,
        )
      )
    );
  }
  else {
    attackContext.damage += 20;
    attackContext.ignoreArmor = true;
    attackContext.damageEffectMessageTitle = 'Coup critique - Coup mortel';
    attackContext.damageEffectMessageText =
      "L'armure de ${attackContext.target.name} n'est pas prise en compte et "
      "les dommages sont augmentés de 20.";
  }
}

void _ccCoupMagistral({
  required ActionInitializerAttackContext attackContext,
}) {
  bool hasOneDeath = false;
  try {
    var capacity = attackContext.target.injuries.manager.capacity(Injury.death);
    hasOneDeath = capacity < 2;
  }
  on ArgumentError {
    hasOneDeath = true;
  }

  if(hasOneDeath) {
    attackContext.attackEffects.add(
      SessionEntityAddEffectMessage(
        entityId: attackContext.target.id,
        effect: EntityEffectInjury(
          name: 'Coup critique - Coup magistral',
          trigger: EntityEffectTrigger.once,
          statusMessageText:
            "Comme ${attackContext.target.name} ne dispose que d'une seule case "
            "de mort, il meurt sur le coup.",
          injury: Injury.death,
        )
      )
    );
  }
  else {
    attackContext.damage += 20;
    attackContext.ignoreArmor = true;
    attackContext.damageEffectMessageTitle = 'Coup critique - Coup magistral';
    attackContext.damageEffectMessageText =
      "L'armure de ${attackContext.target.name} n'est pas prise en compte et "
      "les dommages sont augmentés de 20.";
  }
}