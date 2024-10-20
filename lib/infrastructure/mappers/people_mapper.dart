
import 'package:ui_flutter/domain/domains.dart';
import 'package:ui_flutter/infrastructure/infrastructures.dart';

class PeopleMapper {

  static People fireToEntity( PeopleResponse pResponse) => People(
    id: pResponse.id ?? 'raro',
    name: pResponse.name,
    url: pResponse.url ?? 'SinUrl'
  );
}