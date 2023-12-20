//
//  NetworkMonitor.swift
//  Challenger-2023
//
//  Created by Micaela Rossi on 17/12/2023.
//

import Foundation
import Network

// Clase para monitorear la conectividad
class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private var monitor: NWPathMonitor

    @Published var isConnected: Bool = true

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
