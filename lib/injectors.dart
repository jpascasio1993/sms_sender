
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_remote_source.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';

final serviceLocator = GetIt.instance;
final String inboxPostRemoteURL = 'http://sms.web99s.com/sms/insert_datas';
final String outboxGetRemoteURL = 'http://sms.web99s.com/sms/get_outbox';
final String outboxAPIKey = 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A';
final String inboxAPIKey = '';
final bool smsIsRead = false;

Future<void> init() async {

  //Database
  serviceLocator.registerSingleton<AppDatabase>(AppDatabase());

  //usecases
  serviceLocator.registerLazySingleton<GetInbox>(() => GetInbox(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetSmsAndSaveToDb>(() => GetSmsAndSaveToDb(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOutbox>(() => GetOutbox(outboxRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOutboxFromRemote>(() => GetOutboxFromRemote(repository: serviceLocator()));

  //Bloc
  serviceLocator.registerFactory(() => InboxBloc(getInbox: serviceLocator(), getSmsAndSaveToDb: serviceLocator()));
  serviceLocator.registerFactory(() => OutboxBloc(getOutbox: serviceLocator(), getOutboxFromRemote: serviceLocator()));

  //Sms
  serviceLocator.registerLazySingleton<SmsQuery>(() => SmsQuery());
  serviceLocator.registerLazySingleton<List<SmsQueryKind>>(() => [SmsQueryKind.Inbox]);

  // Data sources
  serviceLocator.registerLazySingleton<RemoteSource>(() => RemoteSourceImpl(client: serviceLocator(), url: outboxGetRemoteURL, apiKey: outboxAPIKey));
  serviceLocator.registerLazySingleton<LocalSource>(() => LocalSourceImpl(appDatabase: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxSource>(() => InboxSourceImpl(appDatabase: serviceLocator(), smsQuery: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxRemoteSource>(() => InboxRemoteSourceImpl(url: null, apikey: null, client: null));

  // Repository
  serviceLocator.registerLazySingleton<OutboxRepository>(() => OutboxRepositoryImpl(remoteSource: serviceLocator(), localSource: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxRepository>(() => InboxRepositoryImpl(inboxSource: serviceLocator(),  inboxRemoteSource: serviceLocator(), queryKinds: serviceLocator()));

  //external
  serviceLocator.registerLazySingleton<Client>(() => Client());
}