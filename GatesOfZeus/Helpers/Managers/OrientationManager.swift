//
//  OrientationManager.swift
//  GatesOfZeus
//
//  Created by Alex on 25.11.2024.
//

import Foundation

final class OrientationManager {
    static let shared = OrientationManager()
    
    private enum Keys: String {
        case orientationAlertShown
    }
    
    private let defaults = UserDefaults.standard
    
    var isOrientationAlertShown: Bool {
        get { defaults.bool(forKey: Keys.orientationAlertShown.rawValue) }
        set { defaults.set(newValue, forKey: Keys.orientationAlertShown.rawValue) }
    }
    
    private init() {}
}
