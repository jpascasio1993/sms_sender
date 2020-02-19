import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/datasources/constants.dart';
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
import 'package:sms_sender/features/permission/data/datasources/permission_local_source.dart';
import 'package:sms_sender/features/permission/data/datasources/permission_remote_source.dart';
import 'package:sms_sender/features/permission/data/repositories/permission_repository_impl.dart';
import 'package:sms_sender/features/permission/domain/repositories/permission_repository.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_request.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_save_info.dart';
import 'package:sms_sender/features/permission/presentation/bloc/bloc.dart';

final serviceLocator = GetIt.instance;
final String inboxPostRemoteURL = 'http://sms.web99s.com/sms/insert_datas';
final String outboxGetRemoteURL = 'http://sms.web99s.com/sms/get_outbox';
final String outboxAPIKey = 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A';
final String inboxAPIKey = 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A';
final bool smsIsRead = false;

Future<void> init() async {
  final preferences = await SharedPreferences.getInstance();

  //Database
  serviceLocator.registerSingleton<AppDatabase>(AppDatabase());

  //usecases
  serviceLocator.registerLazySingleton<GetInbox>(
      () => GetInbox(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetSmsAndSaveToDb>(
      () => GetSmsAndSaveToDb(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOutbox>(
      () => GetOutbox(outboxRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<GetOutboxFromRemote>(
      () => GetOutboxFromRemote(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<PermissionSaveInfo>(
      () => PermissionSaveInfo(repository: serviceLocator()));
  serviceLocator.registerLazySingleton<PermissionRequest>(
      () => PermissionRequest(repository: serviceLocator()));

  //Bloc
  serviceLocator.registerFactory(() => InboxBloc(
      getInbox: serviceLocator(), getSmsAndSaveToDb: serviceLocator()));
  serviceLocator.registerFactory(() => OutboxBloc(
      getOutbox: serviceLocator(), getOutboxFromRemote: serviceLocator()));
  serviceLocator.registerFactory(() => PermissionBloc(
      preferences: serviceLocator(),
      permissionRequest: serviceLocator(),
      permissionSaveInfo: serviceLocator()));

  //Sms
  serviceLocator.registerLazySingleton<SmsQuery>(() => SmsQuery());
  serviceLocator
      .registerLazySingleton<List<SmsQueryKind>>(() => [SmsQueryKind.Inbox]);

  // Data sources
  serviceLocator.registerLazySingleton<RemoteSource>(() => RemoteSourceImpl(
      client: serviceLocator(),
      firebaseReference: serviceLocator(),
      apiKey: outboxAPIKey));
  serviceLocator.registerLazySingleton<LocalSource>(
      () => LocalSourceImpl(appDatabase: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxSource>(() => InboxSourceImpl(
      appDatabase: serviceLocator(), smsQuery: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxRemoteSource>(() =>
      InboxRemoteSourceImpl(
          firebaseReference: serviceLocator(),
          apikey: inboxAPIKey,
          client: serviceLocator()));
  serviceLocator.registerLazySingleton<PermissionLocalSource>(() =>
      PermissionLocalSourceImpl(
          preferences: serviceLocator(), permissionHandler: serviceLocator()));
  serviceLocator.registerLazySingleton<PermissionRemoteSource>(() =>
      PermissionRemoteSourceImpl(
          firebaseDatabase: serviceLocator(), firebaseURLS: serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<OutboxRepository>(() =>
      OutboxRepositoryImpl(
          remoteSource: serviceLocator(), localSource: serviceLocator()));
  serviceLocator.registerLazySingleton<InboxRepository>(() =>
      InboxRepositoryImpl(
          inboxSource: serviceLocator(),
          inboxRemoteSource: serviceLocator(),
          queryKinds: serviceLocator()));
  serviceLocator.registerLazySingleton<PermissionRepository>(() =>
      PermissionRepositoryImpl(
          localSource: serviceLocator(), remoteSource: serviceLocator()));

  //external
  serviceLocator.registerLazySingleton<Client>(() => Client());
  serviceLocator.registerLazySingleton<SharedPreferences>(() => preferences);
  serviceLocator
      .registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase());
  serviceLocator
      .registerLazySingleton<PermissionHandler>(() => PermissionHandler());
  serviceLocator.registerLazySingleton<FirebaseURLS>(
      () => FirebaseURLSImpl(preferences: serviceLocator()));
  serviceLocator.registerLazySingleton<FirebaseReference>(() =>
      FirebaseReferenceImpl(
          firebaseURLS: serviceLocator(), firebaseDatabase: serviceLocator()));
}
