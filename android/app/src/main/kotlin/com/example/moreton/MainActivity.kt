package com.example.moreton

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    init {
        System.loadLibrary("TrustWalletCore")
    }
}
