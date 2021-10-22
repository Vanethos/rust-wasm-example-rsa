import 'dart:convert';

import 'package:crypton/crypton.dart';
import 'package:flutter/material.dart';
import 'package:js/js_util.dart';
import 'package:rust_wasm/wasm/bindings.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({Key? key}) : super(key: key);

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final _messageController = TextEditingController();

  int? _flutterConverstionTime;

  String? _flutterEncrypted;

  int? _wasmConverstionTime;

  String? _wasmEncrypted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WASM and Flutter Encryption with RSA"),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Message',
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(
                height: 40,
              ),

              /// Flutter Converstion
              MaterialButton(
                onPressed: _messageController.text.isNotEmpty
                    ? () async {
                        DateTime start = DateTime.now();
                        final secret = _messageController.text;

                        RSAKeypair rsaKeypair = RSAKeypair.fromRandom(keySize: 2048);

                        String encrypted = rsaKeypair.publicKey.encrypt(secret);

                        DateTime end = DateTime.now();

                        setState(() {
                          _flutterConverstionTime =
                              end.difference(start).inMilliseconds;
                            
                          _flutterEncrypted = encrypted;
                        });
                      }
                    : null,
                disabledColor: Theme.of(context).primaryColor.withOpacity(0.6),
                color: Theme.of(context).primaryColor,
                child: const Text(
                  "Flutter Signature",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (_flutterConverstionTime != null)
                Center(
                  child: Text(
                    "Duration :  ${_flutterConverstionTime.toString()} ms, base64 encoded message: $_flutterEncrypted",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(
                height: 40,
              ),

              /// Wasm Converstion
              MaterialButton(
                onPressed: _messageController.text.isNotEmpty
                    ? () async {
                        DateTime start = DateTime.now();
                        final secret = _messageController.text;

                        final signature = await rsaSignature(secret);

                        final encrypted = base64.encode(signature);

                        DateTime end = DateTime.now();

                        setState(() {
                          _wasmConverstionTime =
                              end.difference(start).inMilliseconds;
                          _wasmEncrypted = encrypted;
                        });
                      }
                    : null,
                disabledColor: Theme.of(context).primaryColor.withOpacity(0.6),
                color: Theme.of(context).primaryColor,
                child: const Text(
                  "WASM Signature",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (_wasmConverstionTime != null)
                Center(
                  child: Text(
                    "Duration :  ${_wasmConverstionTime.toString()} ms, base64 encoded message: $_wasmEncrypted",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularBorderWidget extends StatelessWidget {
  final Widget child;

  const CircularBorderWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            /// BoxShape controls the shape of the container
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: child,
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 6.0,
            ),

            /// BoxShape controls the shape of the container
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class Results {
  final int initialSize;
  final int finalSize;
  final int durationMilliseconds;

  Results(this.initialSize, this.finalSize, this.durationMilliseconds);
}

bool _isInit = false;

Future<void> checkInit() async {
  if (!_isInit) {
    await promiseToFuture(init());
    _isInit = true;
  }
}

Future<List<int>> rsaSignature(String data) async {
  await checkInit();
  return sign(data);
}
