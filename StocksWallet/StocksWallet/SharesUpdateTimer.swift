//
//  SharesUpdate.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 22/05/23.
//

import Foundation

class SharesUpdateTimer {
    private var timer: Timer?
    private let interval: TimeInterval = 10.0
    private let shareUpdate = SharesUpdate()
    private var task: Task<[Share], Error>?
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil, repeats: true)
    }

    @objc func timerFired() {
        // Perform your desired actions here
        task = Task<[Share], Error> {
            if let result = try? await shareUpdate.getUpdatedShares() {
                print("shares update! \(result)")
                return []
            }
            return []
        }
    }

    func stop() {
        task?.cancel()
        timer?.invalidate()
        timer = nil
    }
}
