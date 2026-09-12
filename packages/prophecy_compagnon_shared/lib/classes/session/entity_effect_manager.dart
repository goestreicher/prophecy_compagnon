import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

class EntityEffectManager {
  EntityEffectManager()
    : entityEffects = <String, List<EntityEffect>>{};

  final Map<String, List<EntityEffect>> entityEffects;

  void addEffect(String entityId, EntityEffect effect) {
    if(!entityEffects.containsKey(entityId)) {
      entityEffects[entityId] = [];
    }
    entityEffects[entityId]!.add(effect);
  }
}