import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/notice/data/datasources/notice_remote_datasource.dart';
import 'package:twelfth_mobile/features/notice/data/repositories/notice_repository_impl.dart';
import 'package:twelfth_mobile/features/notice/domain/entities/notice.dart';
import 'package:twelfth_mobile/features/notice/domain/repositories/i_notice_repository.dart';

final _noticeApiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _noticeDataSourceProvider = Provider<INoticeRemoteDataSource>(
  (ref) => NoticeRemoteDataSourceImpl(ref.read(_noticeApiClientProvider)),
);

final noticeRepositoryProvider = Provider<INoticeRepository>(
  (ref) => NoticeRepositoryImpl(ref.read(_noticeDataSourceProvider)),
);

final noticeProvider = FutureProvider.family<Notice, String>((ref, noticeId) {
  return ref.read(noticeRepositoryProvider).getNotice(noticeId);
});
