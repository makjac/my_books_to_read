part of 'injection_container.dart';

final locator = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final dio = Dio();
  final firebaseAuth = fb_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  locator
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<TrendingBooksApi>(
      () => TrendingBooksApiImpl(dio: dio),
    )
    ..registerFactory<TrendingBooksProvider>(
      () => TrendingBooksProvider(trendingBooksApi: locator()),
    )
    ..registerLazySingleton<SearchBooksApi>(() => SearchBooksApiImpl(dio: dio))
    ..registerFactory<SearchBooksProvider>(
      () => SearchBooksProvider(searchApi: locator()),
    )
    ..registerFactory<AuthProvider>(() => AuthProvider(auth: firebaseAuth))
    ..registerLazySingleton<SavedBooksRepository>(
      () => SavedBooksRepositoryImpl(firestore: firestore, auth: firebaseAuth),
    )
    ..registerFactory(() => SavedBooksProvider(repository: locator()))
    ..registerLazySingleton<BookDetailsApi>(() => BookDetailsApiImpl(dio: dio))
    ..registerFactory(() => BooksDetailsProvider(api: locator()));
}
