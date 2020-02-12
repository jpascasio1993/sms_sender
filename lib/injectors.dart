
import 'package:get_it/get_it.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';

final serviceLocator = GetIt.instance;
final String remoteUrl = '';
final bool smsIsRead = false;

Future<void> init() async {

  //Database
  // serviceLocator.registerFactory(() => AppDatabase());

  //Bloc
  serviceLocator.registerFactory(() => InboxBloc(getInbox: serviceLocator()));
  serviceLocator.registerFactory(() => OutboxBloc(getOutbox: serviceLocator()));

  //Sms
  serviceLocator.registerLazySingleton<SmsQuery>(() => SmsQuery());
  serviceLocator.registerLazySingleton<List<SmsQueryKind>>(() => [SmsQueryKind.Inbox]);

  // Data sources
  serviceLocator.registerLazySingleton<RemoteSource>(() => RemoteSourceImpl(client: serviceLocator(), url: remoteUrl));
  serviceLocator.registerLazySingleton<LocalSource>(() => LocalSourceImpl());
  serviceLocator.registerLazySingleton<InboxSource>(() => InboxSourceImpl(smsQuery: serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<OutboxRepository>(() => OutboxRepositoryImpl(remoteSource: serviceLocator(), localSource: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxRepository>(() => InboxRepositoryImpl(inboxSource: serviceLocator(), queryKinds: serviceLocator(), read: smsIsRead));

  //usecases
  serviceLocator.registerLazySingleton<GetInbox>(() => GetInbox(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOutbox>(() => GetOutbox(outboxRepository: serviceLocator()));
}