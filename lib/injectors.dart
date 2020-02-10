
import 'package:get_it/get_it.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';

final sl = GetIt.asNewInstance();
final String remoteUrl = '';

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<RemoteSource>(() => RemoteSourceImpl(client: sl(), url: remoteUrl));
  sl.registerLazySingleton<LocalSource>(() => LocalSourceImpl());

  // Repository
  sl.registerLazySingleton<OutboxRepository>(() => OutboxRepositoryImpl(remoteSource: sl(), localSource: sl()));
  
}