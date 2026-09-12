import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

abstract class EntityEffect {
  EntityEffect({
    this.once,
    this.permanent,
    this.duration,
  })
  {
    if(once == null && permanent == null && duration == null) {
      throw(ArgumentError('One of "once", "permanent" or "duration" must be given'));
    }
  }

  final bool? once;
  final bool? permanent;
  final TickerDuration? duration;

  void apply(EntityBase entity);
  void unapply(EntityBase entity);
}