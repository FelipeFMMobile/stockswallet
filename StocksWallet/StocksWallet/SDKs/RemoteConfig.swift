//
//  RemoteConfig.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 18/02/24.
//

import FirebaseCore
import FirebaseRemoteConfig

class RemoteConfigSDK {
    static let shared: RemoteConfigSDK = RemoteConfigSDK()
    private var remoteConfig: RemoteConfig
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    public func fetch() {
        remoteConfig.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig.activate { _, _ in
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }

    public func getValueFor(_ key: String) -> String? {
        return remoteConfig.configValue(forKey: key).stringValue
    }
}
