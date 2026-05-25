import 'package:twelfth_mobile/features/no_spoiler/data/datasources/no_spoiler_remote_datasource.dart';
import 'package:twelfth_mobile/features/no_spoiler/domain/repositories/i_no_spoiler_repository.dart';

class NoSpoilerRepositoryImpl implements INoSpoilerRepository {
  const NoSpoilerRepositoryImpl(this._dataSource);

  final INoSpoilerRemoteDataSource _dataSource;

  @override
  Future<bool> get() => _dataSource.get();

  @override
  Future<bool> save(bool enabled) => _dataSource.save(enabled);
}
