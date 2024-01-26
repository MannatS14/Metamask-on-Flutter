import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MetaMask extends StatefulWidget {
  const MetaMask({super.key});

  @override
  State<MetaMask> createState() => _MetaMaskState();
}

class _MetaMaskState extends State<MetaMask> {
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'WalletConnect',
      description: 'Flutter Wallet Connect',
      url: 'https://walletconnect.org',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );
  var _session;

  connectMetamaskWallet(BuildContext context) async {
    if (!connector.connected) {
      try {
        _session =
            await connector.createSession(onDisplayUri: (receivedUri) async {
          // Display URI using WebView
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('MetaMask Connection')),
                body: WebView(
                  initialUrl: receivedUri,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ),
          );
        });

        setState(() {
          _session = _session;
        });
        print(_session);
      } catch (e) {
        print("Error in connecting $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(() {
              _session = session;
            }));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
            }));
    connector.on(
        'disconnect',
        (session) => setState(() {
              _session = session;
            }));

    var account = _session?.accounts[0];
    var chainId = _session?.chainId;

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Connect')),
      body: _session == null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        'Please click the button to connect to MetaMask wallet'),
                  ),
                  TextButton(
                    onPressed: () async {
                      connectMetamaskWallet(context);
                      print('Wallet connected');
                    },
                    child: const Text('Connect Wallet'),
                  ),
                ],
              ),
            )
          : account != null
              ? Column(
                  children: [
                    Text("You are connected $account"),
                    Text("ChainId is $chainId"),
                  ],
                )
              : const Text('No account'),
    );
  }
}
