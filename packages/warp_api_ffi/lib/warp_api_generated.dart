// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void init_wallet(
    ffi.Pointer<ffi.Int8> db_path,
  ) {
    return _init_wallet(
      db_path,
    );
  }

  late final _init_wallet_ptr =
      _lookup<ffi.NativeFunction<_c_init_wallet>>('init_wallet');
  late final _dart_init_wallet _init_wallet =
      _init_wallet_ptr.asFunction<_dart_init_wallet>();

  void warp_sync(
    int port,
  ) {
    return _warp_sync(
      port,
    );
  }

  late final _warp_sync_ptr =
      _lookup<ffi.NativeFunction<_c_warp_sync>>('warp_sync');
  late final _dart_warp_sync _warp_sync =
      _warp_sync_ptr.asFunction<_dart_warp_sync>();

  void dart_post_cobject(
    ffi.Pointer<ffi.Void> ptr,
  ) {
    return _dart_post_cobject(
      ptr,
    );
  }

  late final _dart_post_cobject_ptr =
      _lookup<ffi.NativeFunction<_c_dart_post_cobject>>('dart_post_cobject');
  late final _dart_dart_post_cobject _dart_post_cobject =
      _dart_post_cobject_ptr.asFunction<_dart_dart_post_cobject>();

  int get_latest_height() {
    return _get_latest_height();
  }

  late final _get_latest_height_ptr =
      _lookup<ffi.NativeFunction<_c_get_latest_height>>('get_latest_height');
  late final _dart_get_latest_height _get_latest_height =
      _get_latest_height_ptr.asFunction<_dart_get_latest_height>();

  int is_valid_key(
    ffi.Pointer<ffi.Int8> seed,
  ) {
    return _is_valid_key(
      seed,
    );
  }

  late final _is_valid_key_ptr =
      _lookup<ffi.NativeFunction<_c_is_valid_key>>('is_valid_key');
  late final _dart_is_valid_key _is_valid_key =
      _is_valid_key_ptr.asFunction<_dart_is_valid_key>();

  int valid_address(
    ffi.Pointer<ffi.Int8> address,
  ) {
    return _valid_address(
      address,
    );
  }

  late final _valid_address_ptr =
      _lookup<ffi.NativeFunction<_c_valid_address>>('valid_address');
  late final _dart_valid_address _valid_address =
      _valid_address_ptr.asFunction<_dart_valid_address>();

  void set_mempool_account(
    int account,
  ) {
    return _set_mempool_account(
      account,
    );
  }

  late final _set_mempool_account_ptr =
      _lookup<ffi.NativeFunction<_c_set_mempool_account>>(
          'set_mempool_account');
  late final _dart_set_mempool_account _set_mempool_account =
      _set_mempool_account_ptr.asFunction<_dart_set_mempool_account>();

  int new_account(
    ffi.Pointer<ffi.Int8> name,
    ffi.Pointer<ffi.Int8> data,
  ) {
    return _new_account(
      name,
      data,
    );
  }

  late final _new_account_ptr =
      _lookup<ffi.NativeFunction<_c_new_account>>('new_account');
  late final _dart_new_account _new_account =
      _new_account_ptr.asFunction<_dart_new_account>();

  int get_mempool_balance() {
    return _get_mempool_balance();
  }

  late final _get_mempool_balance_ptr =
      _lookup<ffi.NativeFunction<_c_get_mempool_balance>>(
          'get_mempool_balance');
  late final _dart_get_mempool_balance _get_mempool_balance =
      _get_mempool_balance_ptr.asFunction<_dart_get_mempool_balance>();

  ffi.Pointer<ffi.Int8> send_payment(
    int account,
    ffi.Pointer<ffi.Int8> address,
    int amount,
    int max_amount_per_note,
    int port,
  ) {
    return _send_payment(
      account,
      address,
      amount,
      max_amount_per_note,
      port,
    );
  }

  late final _send_payment_ptr =
      _lookup<ffi.NativeFunction<_c_send_payment>>('send_payment');
  late final _dart_send_payment _send_payment =
      _send_payment_ptr.asFunction<_dart_send_payment>();

  int try_warp_sync() {
    return _try_warp_sync();
  }

  late final _try_warp_sync_ptr =
      _lookup<ffi.NativeFunction<_c_try_warp_sync>>('try_warp_sync');
  late final _dart_try_warp_sync _try_warp_sync =
      _try_warp_sync_ptr.asFunction<_dart_try_warp_sync>();

  void skip_to_last_height() {
    return _skip_to_last_height();
  }

  late final _skip_to_last_height_ptr =
      _lookup<ffi.NativeFunction<_c_skip_to_last_height>>(
          'skip_to_last_height');
  late final _dart_skip_to_last_height _skip_to_last_height =
      _skip_to_last_height_ptr.asFunction<_dart_skip_to_last_height>();

  void rewind_to_height(
    int height,
  ) {
    return _rewind_to_height(
      height,
    );
  }

  late final _rewind_to_height_ptr =
      _lookup<ffi.NativeFunction<_c_rewind_to_height>>('rewind_to_height');
  late final _dart_rewind_to_height _rewind_to_height =
      _rewind_to_height_ptr.asFunction<_dart_rewind_to_height>();

  int mempool_sync() {
    return _mempool_sync();
  }

  late final _mempool_sync_ptr =
      _lookup<ffi.NativeFunction<_c_mempool_sync>>('mempool_sync');
  late final _dart_mempool_sync _mempool_sync =
      _mempool_sync_ptr.asFunction<_dart_mempool_sync>();
}

typedef _c_init_wallet = ffi.Void Function(
  ffi.Pointer<ffi.Int8> db_path,
);

typedef _dart_init_wallet = void Function(
  ffi.Pointer<ffi.Int8> db_path,
);

typedef _c_warp_sync = ffi.Void Function(
  ffi.Int64 port,
);

typedef _dart_warp_sync = void Function(
  int port,
);

typedef _c_dart_post_cobject = ffi.Void Function(
  ffi.Pointer<ffi.Void> ptr,
);

typedef _dart_dart_post_cobject = void Function(
  ffi.Pointer<ffi.Void> ptr,
);

typedef _c_get_latest_height = ffi.Uint32 Function();

typedef _dart_get_latest_height = int Function();

typedef _c_is_valid_key = ffi.Int8 Function(
  ffi.Pointer<ffi.Int8> seed,
);

typedef _dart_is_valid_key = int Function(
  ffi.Pointer<ffi.Int8> seed,
);

typedef _c_valid_address = ffi.Int8 Function(
  ffi.Pointer<ffi.Int8> address,
);

typedef _dart_valid_address = int Function(
  ffi.Pointer<ffi.Int8> address,
);

typedef _c_set_mempool_account = ffi.Void Function(
  ffi.Uint32 account,
);

typedef _dart_set_mempool_account = void Function(
  int account,
);

typedef _c_new_account = ffi.Uint32 Function(
  ffi.Pointer<ffi.Int8> name,
  ffi.Pointer<ffi.Int8> data,
);

typedef _dart_new_account = int Function(
  ffi.Pointer<ffi.Int8> name,
  ffi.Pointer<ffi.Int8> data,
);

typedef _c_get_mempool_balance = ffi.Int64 Function();

typedef _dart_get_mempool_balance = int Function();

typedef _c_send_payment = ffi.Pointer<ffi.Int8> Function(
  ffi.Uint32 account,
  ffi.Pointer<ffi.Int8> address,
  ffi.Uint64 amount,
  ffi.Uint64 max_amount_per_note,
  ffi.Int64 port,
);

typedef _dart_send_payment = ffi.Pointer<ffi.Int8> Function(
  int account,
  ffi.Pointer<ffi.Int8> address,
  int amount,
  int max_amount_per_note,
  int port,
);

typedef _c_try_warp_sync = ffi.Int8 Function();

typedef _dart_try_warp_sync = int Function();

typedef _c_skip_to_last_height = ffi.Void Function();

typedef _dart_skip_to_last_height = void Function();

typedef _c_rewind_to_height = ffi.Void Function(
  ffi.Uint32 height,
);

typedef _dart_rewind_to_height = void Function(
  int height,
);

typedef _c_mempool_sync = ffi.Int64 Function();

typedef _dart_mempool_sync = int Function();