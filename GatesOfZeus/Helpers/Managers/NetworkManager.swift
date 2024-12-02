//
//  NetworkManager.swift
//  GatesOfZeus
//
//  Created by Alex on 25.11.2024.
//

import Network

final class NetworkManager {
    static let shared = NetworkManager()
    private let check = NWPathMonitor()
    private var isChecking = false
    
    private init() {}
    
    func start(completion: @escaping (Bool) -> Void) {
        guard !isChecking else { return }
        
        check.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        check.start(queue: queue)
        isChecking = true
    }
    
    func stop() {
        guard isChecking else { return }
        check.cancel()
        isChecking = false
    }
}
