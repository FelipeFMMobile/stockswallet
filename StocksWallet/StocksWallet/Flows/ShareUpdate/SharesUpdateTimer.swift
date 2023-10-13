//
//  SharesUpdate.swift
//  StocksWallet
//
//  Created by Felipe Menezes on 22/05/23.
//

import Foundation

class SharesUpdateTimer: ObservableObject {
    private var timer: Timer?
    private let interval: TimeInterval = 5.0
    private let shareUpdate = SharesUpdate()
    private var task: Task<Void, Error>?
    @Published var isLoading: Bool = false

    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil, repeats: true)
    }

    @objc func timerFired() {
        // Perform your desired actions here
        task = Task<Void, Error>(priority: .background) {
            await loadingState(isLoading: true)
            if let result = try? await shareUpdate.getUpdatedShares() {
                debugPrint("shares update! \(result)")
                await loadingState(isLoading: false)
                return
            }
            return
        }
    }

    @MainActor
    func loadingState(isLoading value: Bool) async {
        isLoading = value
    }

    func stop() {
        task?.cancel()
        timer?.invalidate()
        timer = nil
    }
}
