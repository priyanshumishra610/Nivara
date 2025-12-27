import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../../../core/domain/base_usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/state/providers/app_providers.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    ref.read(apiServiceProvider),
    ref.read(cacheServiceProvider),
  );
});

final getDashboardDataUseCaseProvider = Provider<GetDashboardDataUseCase>((ref) {
  return GetDashboardDataUseCase(ref.read(dashboardRepositoryProvider));
});

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final useCase = ref.read(getDashboardDataUseCaseProvider);
  final result = await useCase.call(const NoParams());
  
  return result.fold(
    onSuccess: (data) => data,
    onFailure: (error) => throw error,
  );
});

