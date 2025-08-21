//
//  ContentView.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        NavigationSplitView {
                    SideBar()
                        .accentColor(settings.accentColor)
                } detail: {
                    Text("Select an item from the sidebar")
                }
                
    }
        
}

#Preview {
    ContentView()
}
