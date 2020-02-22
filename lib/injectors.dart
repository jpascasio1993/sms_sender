import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
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
import 'package:sms_sender/features/inbox/domain/usecases/send_sms_to_server.dart';
import 'package:sms_sender/features/inbox/domain/usecases/update_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/domain/usecases/update_outbox.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/permission/data/datasources/permission_local_source.dart';
import 'package:sms_sender/features/permission/data/datasources/permission_remote_source.dart';
import 'package:sms_sender/features/permission/data/repositories/permission_repository_impl.dart';
import 'package:sms_sender/features/permission/domain/repositories/permission_repository.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_request.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_save_info.dart';
import 'package:sms_sender/features/permission/presentation/bloc/bloc.dart';

// final serviceLocator = GetIt.instance;
final String inboxPostRemoteURL = 'http://sms.web99s.com/sms/insert_datas';
final String outboxGetRemoteURL = 'http://sms.web99s.com/sms/get_outbox';
final String outboxAPIKey = 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A';
final String inboxAPIKey = 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A';
final bool smsIsRead = false;


class Injector {
  GetIt _serviceLocator;
  Injector({@required GetIt serviceLocator}): _serviceLocator = serviceLocator;
  
  Injector.asNewInstance(){
    _serviceLocator = GetIt.asNewInstance();
  }

  GetIt get serviceLocator => _serviceLocator;

  Future<bool> init() async {
    final preferences = await SharedPreferences.getInstance();

    //Database
    _serviceLocator.registerSingleton<AppDatabase>(AppDatabase());

    //usecases
    _serviceLocator.registerLazySingleton<GetInbox>(
        () => GetInbox(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<GetSmsAndSaveToDb>(
        () => GetSmsAndSaveToDb(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<GetOutbox>(
        () => GetOutbox(outboxRepository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<GetOutboxFromRemote>(
        () => GetOutboxFromRemote(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<PermissionSaveInfo>(
        () => PermissionSaveInfo(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<PermissionRequest>(
        () => PermissionRequest(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<UpdateOutbox>(
        () => UpdateOutbox(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<UpdateInbox>(
        () => UpdateInbox(repository: _serviceLocator()));
    _serviceLocator.registerLazySingleton<SendSmsToServer>(() => SendSmsToServer(repository: _serviceLocator()));

    //Bloc
    _serviceLocator.registerFactory(() => InboxBloc(
        getInbox: _serviceLocator(),
        getSmsAndSaveToDb: _serviceLocator(),
        updateInbox: _serviceLocator()));
    _serviceLocator.registerFactory(() => OutboxBloc(
        getOutbox: _serviceLocator(),
        getOutboxFromRemote: _serviceLocator(),
        updateOutbox: _serviceLocator()));
    _serviceLocator.registerFactory(() => PermissionBloc(
        preferences: _serviceLocator(),
        permissionRequest: _serviceLocator(),
        permissionSaveInfo: _serviceLocator()));

    //Sms
    _serviceLocator.registerLazySingleton<SmsQuery>(() => SmsQuery());
    serviceLocator
        .registerLazySingleton<List<SmsQueryKind>>(() => [SmsQueryKind.Inbox]);

    // Data sources
    _serviceLocator.registerLazySingleton<RemoteSource>(() => RemoteSourceImpl(
        client: _serviceLocator(),
        firebaseReference: _serviceLocator(),
        apiKey: outboxAPIKey));
    _serviceLocator.registerLazySingleton<LocalSource>(
        () => LocalSourceImpl(appDatabase: _serviceLocator()));
    _serviceLocator.registerLazySingleton<InboxSource>(() => InboxSourceImpl(
        appDatabase: _serviceLocator(), smsQuery: _serviceLocator()));
    _serviceLocator.registerLazySingleton<InboxRemoteSource>(() =>
        InboxRemoteSourceImpl(
            firebaseReference: _serviceLocator(),
            apikey: inboxAPIKey,
            client: _serviceLocator()));
    _serviceLocator.registerLazySingleton<PermissionLocalSource>(() =>
        PermissionLocalSourceImpl(
            preferences: _serviceLocator(), permissionHandler: _serviceLocator()));
    _serviceLocator.registerLazySingleton<PermissionRemoteSource>(() =>
        PermissionRemoteSourceImpl(
            firebaseDatabase: _serviceLocator(), firebaseURLS: _serviceLocator()));

    // Repository
    _serviceLocator.registerLazySingleton<OutboxRepository>(() =>
        OutboxRepositoryImpl(
            remoteSource: _serviceLocator(), localSource: _serviceLocator()));
    _serviceLocator.registerLazySingleton<InboxRepository>(() =>
        InboxRepositoryImpl(
            inboxSource: _serviceLocator(),
            inboxRemoteSource: _serviceLocator(),
            queryKinds: _serviceLocator()));
    _serviceLocator.registerLazySingleton<PermissionRepository>(() =>
        PermissionRepositoryImpl(
            localSource: _serviceLocator(), remoteSource: _serviceLocator()));

    //external
    _serviceLocator.registerLazySingleton<Client>(() => Client());
    _serviceLocator.registerLazySingleton<SharedPreferences>(() => preferences);
    serviceLocator
        .registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase());
    serviceLocator
        .registerLazySingleton<PermissionHandler>(() => PermissionHandler());
    _serviceLocator.registerLazySingleton<FirebaseURLS>(
        () => FirebaseURLSImpl(preferences: _serviceLocator()));
    _serviceLocator.registerLazySingleton<FirebaseReference>(() =>
        FirebaseReferenceImpl(
            firebaseURLS: _serviceLocator(), firebaseDatabase: _serviceLocator()));
    return true;
  }
}


