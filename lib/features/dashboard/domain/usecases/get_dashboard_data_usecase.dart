import '../../../../core/domain/base_usecase.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';

class GetDashboardDataUseCase implements UseCase<DashboardData, NoParams> {
  final DashboardRepository _repository;
  
  GetDashboardDataUseCase(this._repository);
  
  @override
  Future<Result<DashboardData>> call(NoParams params) {
    return _repository.getDashboardData();
  }
}

