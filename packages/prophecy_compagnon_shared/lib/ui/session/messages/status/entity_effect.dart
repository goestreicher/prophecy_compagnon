import 'package:prophecy_compagnon_shared/classes/session/entity_effect.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_status.dart';

class SessionEntitySetEffectMessage extends SessionEntityStatusMessage {
  SessionEntitySetEffectMessage({
    super.source,
    super.broadcastIncludesSelf,
    required super.entityId,
    required this.effect,
  });

  EntityEffect effect;
}