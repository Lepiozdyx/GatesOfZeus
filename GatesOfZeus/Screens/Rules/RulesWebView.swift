//
//  RulesWebView.swift
//  GatesOfZeus
//
//  Created by Alex on 22.11.2024.
//

import SwiftUI
@preconcurrency import WebKit

struct RulesWebView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var vm: WebViewModel
    let rulesURL: URL?
    
    init(rulesURL: URL?) {
        self.rulesURL = rulesURL
        _vm = StateObject(wrappedValue: WebViewModel(rulesURL: rulesURL))
    }
    
    var body: some View {
        Group {
            if vm.showFallback {
                ContentView()
            } else {
                ZStack {
                    SafeAreaRulesView(url: vm.currentURL, isRulesURL: rulesURL != nil)
                        .ignoresSafeArea(.all, edges: .bottom)
                    
                    if rulesURL != nil {
                        VStack {
                            HStack {
                                NavigationBackButton {
                                    navigationManager.navigateBack()
                                }
                                Spacer()
                            }
                            .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.onAppear()
        }
        .onDisappear {
            vm.onDisappear()
        }
    }
}

// MARK: - SafeAreaRulesView
struct SafeAreaRulesView: UIViewRepresentable {
    let url: URL?
    let isRulesURL: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = WebViewManager.shared.getUAgent()
        webView.allowsBackForwardNavigationGestures = !isRulesURL
        
        if let url = url {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SafeAreaRulesView
        
        init(_ parent: SafeAreaRulesView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                WebViewManager.shared.handleStatus(url: url, isRulesURL: parent.isRulesURL)
            }
            decisionHandler(.allow)
        }
    }
}
