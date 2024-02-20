//
//  AppLauchInitializer.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 18/02/24.
//

import Firebase

class AppLauchInitializer {
    func initializeFirebase() {
        FirebaseApp.configure()
        RemoteConfigSDK.shared.fetch()
    }
}
