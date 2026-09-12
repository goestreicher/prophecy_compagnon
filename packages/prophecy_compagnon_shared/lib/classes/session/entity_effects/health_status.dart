import 'package:prophecy_compagnon_shared/classes/entity/health_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';

class EffectSetHealthStatus extends EntityEffect {
  EffectSetHealthStatus({
    required this.status,
  })
    : super(once: true);

  final EntityHealthStatusFlag status;

  @override
  void apply(EntityBase entity) => entity.healthStatus.add(status);

  @override
  void unapply(EntityBase entity) {}
}

class EffectClearHealthStatus extends EntityEffect {
  EffectClearHealthStatus({
    required this.status,
  })
    : super(once: true);

  final EntityHealthStatusFlag status;

  @override
  void apply(EntityBase entity) => entity.healthStatus.clear(status);

  @override
  void unapply(EntityBase entity) {}
}