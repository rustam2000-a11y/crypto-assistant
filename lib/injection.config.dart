// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:crypto_assistant/assistant/bloc/filter_detailing_bloc.dart'
    as _i2;
import 'package:crypto_assistant/auth/data/api/auth_api.dart' as _i375;
import 'package:crypto_assistant/auth/data/repository/auth_repository.dart'
    as _i767;
import 'package:crypto_assistant/auth/login/bloc/login_bloc.dart' as _i168;
import 'package:crypto_assistant/auth/registration/bloc/registration_bloc.dart'
    as _i685;
import 'package:crypto_assistant/briefcase/bloc/briefcase_bloc.dart' as _i612;
import 'package:crypto_assistant/coin_card/bloc/coin_bloc.dart' as _i287;
import 'package:crypto_assistant/core/app_bloc/app_locale_bloc.dart' as _i423;
import 'package:crypto_assistant/home/bloc/home_bloc.dart' as _i838;
import 'package:crypto_assistant/home/data/api/coint_api.dart' as _i997;
import 'package:crypto_assistant/home/data/client/api_client.dart' as _i292;
import 'package:crypto_assistant/home/data/repository/coint_rpository.dart'
    as _i404;
import 'package:crypto_assistant/home/domain/usecase/search_coins_usecase.dart'
    as _i976;
import 'package:crypto_assistant/home/language/bloc/language_bloc.dart'
    as _i861;
import 'package:crypto_assistant/home/language/data/api/language_api.dart'
    as _i234;
import 'package:crypto_assistant/home/language/data/repository/language_repository.dart'
    as _i576;
import 'package:crypto_assistant/injection.dart' as _i437;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i976.SearchCoinsUseCase>(() => _i976.SearchCoinsUseCase());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i292.ApiClient>(() => _i292.ApiClient());
    gh.factory<_i997.CoinApI>(() => _i997.CoinApi(gh<_i292.ApiClient>()));
    gh.lazySingleton<_i404.CoinRepositoryI>(
      () => _i404.CoinRepository(api: gh<_i997.CoinApI>()),
    );
    gh.factory<_i234.LanguageApiI>(
      () => _i234.LanguageApi(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i2.FilterDetailingBloc>(
      () => _i2.FilterDetailingBloc(repository: gh<_i404.CoinRepositoryI>()),
    );
    gh.factory<_i375.AuthApiI>(() => _i375.AuthApi());
    gh.lazySingleton<_i576.LanguageRepositoryI>(
      () => _i576.LanguageRepository(api: gh<_i234.LanguageApiI>()),
    );
    gh.lazySingleton<_i767.AuthRepositoryI>(
      () => _i767.AuthRepository(api: gh<_i375.AuthApiI>()),
    );
    gh.factory<_i838.HomeBloc>(
      () => _i838.HomeBloc(
        coinRepository: gh<_i404.CoinRepositoryI>(),
        authRepository: gh<_i767.AuthRepositoryI>(),
        searchCoinsUseCase: gh<_i976.SearchCoinsUseCase>(),
      ),
    );
    gh.factory<_i168.LoginBloc>(
      () => _i168.LoginBloc(repository: gh<_i767.AuthRepositoryI>()),
    );
    gh.factory<_i685.RegistrationBloc>(
      () => _i685.RegistrationBloc(repository: gh<_i767.AuthRepositoryI>()),
    );
    gh.factory<_i861.LanguageBloc>(
      () => _i861.LanguageBloc(
        languageRepository: gh<_i576.LanguageRepositoryI>(),
      ),
    );
    gh.lazySingleton<_i423.AppLocaleBloc>(
      () => _i423.AppLocaleBloc(
        languageRepository: gh<_i576.LanguageRepositoryI>(),
      ),
    );
    gh.factory<_i612.BriefcaseBloc>(
      () => _i612.BriefcaseBloc(
        coinRepository: gh<_i404.CoinRepositoryI>(),
        authRepository: gh<_i767.AuthRepositoryI>(),
      ),
    );
    gh.factory<_i287.CoinBloc>(
      () => _i287.CoinBloc(
        coinRepository: gh<_i404.CoinRepositoryI>(),
        authRepository: gh<_i767.AuthRepositoryI>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i437.RegisterModule {}
