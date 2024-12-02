//
//  RulesView.swift
//  GatesOfZeus
//
//  Created by Alex on 22.11.2024.
//

import SwiftUI

struct RulesView: View {
    var body: some View {
        RulesWebView(rulesURL: URL(string: "https://gatesofzeus.online/rules.html"))
    }
}

#Preview {
    RulesView()
}
