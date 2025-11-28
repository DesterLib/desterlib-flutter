// Core
import 'package:dester/features/connection/domain/entities/api_configuration.dart';


/// Use case interface for getting all API configurations
abstract class GetApiConfigurations {
  List<ApiConfiguration> call();
}
