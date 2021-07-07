import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warp/store.dart';
import 'package:warp_api/warp_api.dart';

import 'about.dart';
import 'main.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  Timer _timerSync;
  int _progress = 0;
  StreamSubscription _sub;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    print("INITSTATE");
    Future.microtask(() async {
      await accountManager.updateUnconfirmedBalance();
      await accountManager.fetchNotesAndHistory();
      _setupTimer();
      await showAboutOnce(this.context);
    });
    WidgetsBinding.instance.addObserver(this);
    progressStream.listen((percent) {
      setState(() {
        _progress = percent;
      });
    });
  }

  @override
  void dispose() {
    print("DISPOSE");
    _timerSync?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("appstate $state");
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _timerSync?.cancel();
        break;
      case AppLifecycleState.resumed:
        _setupTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!syncStatus.isSynced()) _trySync();
    if (accountManager.active == null) return CircularProgressIndicator();
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Observer(
                  builder: (context) => Text(
                      "\u24E9 Wallet - ${accountManager.active.name}")),
              bottom: TabBar(tabs: [
                Tab(text: "Account"),
                Tab(text: "Notes"),
                Tab(text: "History"),
              ]),
              actions: [
                Observer(builder: (context) {
                  accountManager.canPay;
                  return PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      PopupMenuItem(child: Text("Accounts"), value: "Accounts"),
                      PopupMenuItem(child: Text("Backup"), value: "Backup"),
                      PopupMenuItem(child: Text("Rescan"), value: "Rescan"),
                      if (accountManager.canPay)
                        PopupMenuItem(
                            child: Text("Cold Storage"), value: "Cold"),
                      PopupMenuItem(
                          child: Text(settings.nextMode()), value: "Theme"),
                      PopupMenuItem(child: Text("About"), value: "About"),
                    ],
                    onSelected: _onMenu,
                  );
                })
              ],
            ),
            body: TabBarView(children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Column(children: [
                    Observer(
                        builder: (context) => syncStatus.syncedHeight <= 0
                            ? Text('Synching')
                            : syncStatus.isSynced()
                                ? Text('${syncStatus.syncedHeight}',
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .caption)
                                : Text(
                                    '${syncStatus.syncedHeight} / ${syncStatus.latestHeight}')),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    Observer(builder: (context) {
                      return Column(children: [
                        QrImage(
                            data: accountManager.active.address,
                            size: 200,
                            backgroundColor: Colors.white),
                        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                        SelectableText('${accountManager.active.address}'),
                      ]);
                    }),
                    Observer(
                        builder: (context) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: <Widget>[
                                  Text(
                                      '\u24E9 ${_getBalance_hi(accountManager.balance)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                  Text(
                                      '${_getBalance_lo(accountManager.balance)}'),
                                ])),
                    Observer(builder: (context) {
                      final zecPrice = priceStore.zecPrice;
                      final balanceUSD =
                          accountManager.balance * zecPrice / ZECUNIT;
                      return Column(children: [
                        if (zecPrice != 0.0)
                          Text("${balanceUSD.toStringAsFixed(2)} USDT",
                              style:
                                  Theme.of(this.context).textTheme.headline6),
                        if (zecPrice != 0.0)
                          Text("1 ZEC = ${zecPrice.toStringAsFixed(2)} USDT"),
                      ]);
                    }),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    Observer(
                        builder: (context) =>
                            (accountManager.unconfirmedBalance != 0)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.ideographic,
                                    children: <Widget>[
                                        Text(
                                            '${_sign(accountManager.unconfirmedBalance)} ${_getBalance_hi(accountManager.unconfirmedBalance)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.merge(_unconfirmedStyle())),
                                        Text(
                                            '${_getBalance_lo(accountManager.unconfirmedBalance)}',
                                            style: _unconfirmedStyle()),
                                      ])
                                : Container()),
                    if (_progress > 0)
                      LinearProgressIndicator(value: _progress / 100.0),
                  ]))),
              NoteWidget(),
              HistoryWidget(),
            ]),
            floatingActionButton: Observer(
              builder: (context) => accountManager.canPay
                  ? FloatingActionButton(
                      onPressed: _onSend,
                      tooltip: 'Send',
                      child: Icon(Icons.send),
                    )
                  : Container(), // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }

  _sign(int b) {
    return b < 0 ? '-' : '+';
  }

  _unconfirmedStyle() {
    return accountManager.unconfirmedBalance > 0
        ? TextStyle(color: Colors.green)
        : TextStyle(color: Colors.red);
  }

  _getBalance_hi(int b) {
    return ((b.abs() ~/ 100000) / 1000.0).toStringAsFixed(3);
  }

  _getBalance_lo(b) {
    return (b.abs() % 100000).toString().padLeft(5, '0');
  }

  _setupTimer() {
    _sync();
    _timerSync = Timer.periodic(Duration(seconds: 15), (Timer t) {
      _trySync();
    });
  }

  _sync() {
    WarpApi.warpSync((int height) async {
      setState(() {
        syncStatus.setSyncHeight(height);
        if (syncStatus.isSynced()) accountManager.fetchNotesAndHistory();
      });
    });
  }

  _trySync() async {
    priceStore.fetchZecPrice();
    if (syncStatus.syncedHeight < 0) return;
    await syncStatus.update();
    await accountManager.updateUnconfirmedBalance();
    if (!syncStatus.isSynced()) {
      final res = await WarpApi.tryWarpSync();
      if (res == 1) {
        // Reorg
        final targetHeight = syncStatus.syncedHeight - 10;
        WarpApi.rewindToHeight(targetHeight);
        syncStatus.setSyncHeight(targetHeight);
      } else if (res == 0) {
        syncStatus.setSyncHeight(syncStatus.latestHeight);
      }
    }
    await accountManager.fetchNotesAndHistory();
    await accountManager.updateBalance();
    await accountManager.updateUnconfirmedBalance();
  }

  _onSend() {
    Navigator.of(this.context).pushNamed('/send');
  }

  _onMenu(String choice) {
    switch (choice) {
      case "Accounts":
        Navigator.of(this.context).pushNamed('/accounts');
        break;
      case "Backup":
        _backup();
        break;
      case "Rescan":
        _rescan();
        break;
      case "Cold":
        _cold();
        break;
      case "Theme":
        settings.toggle();
        break;
      case "About":
        showAbout(this.context);
        break;
    }
  }

  _backup() async {
    final localAuth = LocalAuthentication();
    final didAuthenticate = await localAuth.authenticate(
        localizedReason: "Please authenticate to show account seed");
    if (didAuthenticate) {
      final seed = await accountManager.getBackup();
      showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text('Account Backup'),
            content: SelectableText(seed),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(this.context).pop();
                },
              )
            ]),
      );
    }
  }

  _rescan() {
    showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('Rescan'),
          content: Text('Rescan wallet from the first block?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(this.context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(this.context).pop();
                final snackBar = SnackBar(content: Text("Rescan Requested..."));
                rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
                syncStatus.setSyncHeight(0);
                WarpApi.rewindToHeight(0);
                _sync();
              },
            ),
          ]),
    );
  }

  _cold() {
    showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Cold Storage'),
                content: Text(
                    'Do you want to DELETE the secret key and convert this account to a watch-only account? '
                    'You will not be able to spend from this device anymore. This operation is NOT reversible.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: _convertToWatchOnly, child: Text('DELETE'))
                ]));
  }

  _convertToWatchOnly() {
    accountManager.convertToWatchOnly();
    Navigator.of(context).pop();
  }
}

class NoteWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteState();
}

class _NoteState extends State<NoteWidget> with AutomaticKeepAliveClientMixin {
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  bool get wantKeepAlive => true; //Set to true

  _notes() => accountManager.notes
      .map((note) => DataRow(
            cells: [
              DataCell(Text("${note.height}",
                  style: !_confirmed(note.height)
                      ? Theme.of(this.context).textTheme.overline
                      : null)),
              DataCell(Text("${note.timestamp}")),
              DataCell(Text("${note.value}")),
            ],
            // messes with dark theme
            // color: MaterialStateColor.resolveWith((states) => _color(note.height)),
          ))
      .toList();

  bool _confirmed(int height) {
    return syncStatus.latestHeight - height >= 10;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 32),
        child: Observer(
            builder: (context) => DataTable(
                  columns: [
                    DataColumn(label: Text('Height')),
                    DataColumn(label: Text('Date/Time')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: _notes(),
                )));
  }
}

class HistoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<HistoryWidget>
    with AutomaticKeepAliveClientMixin {
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  bool get wantKeepAlive => true; //Set to true

  _txs() => accountManager.txs
      .map((tx) => DataRow(cells: [
            DataCell(Text("${tx.height}")),
            DataCell(Text("${tx.timestamp}")),
            DataCell(Text("${tx.txid}")),
            DataCell(Text("${tx.value}")),
          ]))
      .toList();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(bottom: 64),
        child: Observer(
            builder: (context) => DataTable(
                  columns: [
                    DataColumn(label: Text('Height')),
                    DataColumn(label: Text('Date/Time')),
                    DataColumn(label: Text('TXID')),
                    DataColumn(label: Text('Amount')),
                  ],
                  columnSpacing: 32,
                  rows: _txs(),
                )));
  }
}

// TODO: Fix transaction / log panel
// transaction between account are counted properly