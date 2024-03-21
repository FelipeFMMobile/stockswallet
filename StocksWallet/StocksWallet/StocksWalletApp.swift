//
//  StocksWalletApp.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 29/03/23.
//

import SwiftUI

@main
struct StocksWalletApp: App {
    let persistenceController = PersistenceController.shared
    let initializer = AppLauchInitializer()

    init() {
        initializer.initializeFirebase()
        #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try persistenceController.container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            IntroUIView()
        }
    }
}
