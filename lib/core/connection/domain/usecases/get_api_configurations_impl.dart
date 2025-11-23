// Core
import 'package:dester/core/connection/domain/entities/api_configuration.dart';
import 'package:dester/core/connection/domain/repository/connection_repository.dart';

import 'get_api_configurations.dart';


/// Implementation of get API configurations use case
class GetApiConfigurationsImpl implements GetApiConfigurations {
  final ConnectionRepository repository;

  GetApiConfigurationsImpl(this.repository);

  @override
  List<ApiConfiguration> call() {
    return repository.getApiConfigurations();
  }
}
