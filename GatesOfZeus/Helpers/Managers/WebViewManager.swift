//
//  WebViewManager.swift
//  GatesOfZeus
//
//  Created by Alex on 22.11.2024.
//

import Foundation
import WebKit

final class WebViewManager {
    static let shared = WebViewManager()
    private let defaults = UserDefaults.standard
    private let initialURL = URL(string: "https://gatesofzeus.online/score")!
    
    private enum Keys: String {
        case savedURL
    }
    
    private init() {}
    
    var gameURL: URL? {
        get {
            guard let urlString = defaults.string(forKey: Keys.savedURL.rawValue),
                  let url = URL(string: urlString) else { return nil }
            return url
        }
        set {
            if let newURL = newValue?.absoluteString {
                defaults.set(newURL, forKey: Keys.savedURL.rawValue)
            } else {
                defaults.removeObject(forKey: Keys.savedURL.rawValue)
            }
        }
    }
    
    func getInitialURL() -> URL {
        if let savedRulesURL = gameURL {
            return savedRulesURL
        }
        return initialURL
    }
    
    func handleStatus(url: URL, isRulesURL: Bool) {
        guard !isRulesURL else { return }
        
        let urlString = url.absoluteString
        
        guard !urlString.contains("about:blank"),
              !urlString.contains("about:srcdoc"),
              !urlString.isEmpty else {
            return
        }
        
        if !urlString.contains("google.com") &&
           urlString != initialURL.absoluteString &&
           URL(string: urlString)?.host?.isEmpty == false {
            gameURL = url
        } else {
            print("❌ URL with rules not saved")
        }
    }
    
    func getUAgent() -> String {
        let version = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
        return "Mozilla/5.0 (iPhone; CPU iPhone OS \(version) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
    }
}
