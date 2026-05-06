import 'package:twelfth_mobile/features/no_spoiler/data/datasources/no_spoiler_local_datasource.dart';
import 'package:twelfth_mobile/features/no_spoiler/domain/repositories/i_no_spoiler_repository.dart';

class NoSpoilerRepositoryImpl implements INoSpoilerRepository {
  const NoSpoilerRepositoryImpl(this._dataSource);

  final INoSpoilerLocalDataSource _dataSource;

  @override
  Future<bool> get() => _dataSource.get();

  @override
  Future<void> save(bool enabled) => _dataSource.save(enabled);
}
