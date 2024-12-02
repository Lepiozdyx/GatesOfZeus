//
//  TimerManager.swift
//  GatesOfZeus
//
//  Created by Alex on 20.11.2024.
//

import Foundation
import Combine


@MainActor
final class TimerManager: ObservableObject {
    @Published private(set) var timeRemaining: Int
    @Published private(set) var isRunning = false
    
    private var timer: AnyCancellable?
    private var onComplete: (() -> Void)?
    private let duration: Int
    
    init(duration: Int = 60) {
        self.duration = duration
        self.timeRemaining = duration
    }
    
    func start(onComplete: (() -> Void)? = nil) {
        self.onComplete = onComplete
        isRunning = true
        timeRemaining = duration
        
        timer?.cancel()
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
        isRunning = false
    }
    
    func reset(duration: Int = 60) {
        stop()
        timeRemaining = duration
    }
    
    private func tick() {
        guard timeRemaining > 0 else {
            stop()
            onComplete?()
            return
        }
        timeRemaining -= 1
    }
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        Task { @MainActor [weak self] in
            self?.stop()
        }
    }
}
