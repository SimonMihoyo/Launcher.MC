//
//  Launcher_MCApp.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/15.
//

import SwiftUI

@main
struct Aether_Launcher: App {
    let settings = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(settings.accentColor)
                .environmentObject(settings) // 添加这一行
        }
        .commands {
            MainMenu(settings: settings)
                
        }
        Settings {
            SettingsView()
                .accentColor(settings.accentColor)
                .environmentObject(settings) // 添加这一行
        }
    }
}
