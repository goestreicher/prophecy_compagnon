import 'package:json_annotation/json_annotation.dart';

part 'ticker.g.dart';

enum TickerDurationUnit {
  action,
  turn,
  minute,
  hour,
  day,
  ;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TickerDuration {
  TickerDuration({
    required this.count,
    required this.unit,
  });

  int count;
  TickerDurationUnit unit;

  factory TickerDuration.fromJson(Map<String, dynamic> json) =>
      _$TickerDurationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TickerDurationToJson(this);
}