//
//  ContentView.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
                    SideBar()
                } detail: {
                    Text("Select an item from the sidebar")
                }
    }
}

#Preview {
    ContentView()
}
