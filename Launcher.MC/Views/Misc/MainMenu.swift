//
//  MainMenu.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/16.
//

import SwiftUI
import AppKit

struct MainMenu: Commands {
    var settings: SettingsStore
    
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New"){
                
                
            }
        }

        
        CommandGroup(after: .appSettings) {
            
            Divider()
            
            Button("Check for updates") {
                print("CU selected")
            }
        }
        CommandGroup(replacing: .appInfo) {
            Button(LocalizedStringKey("AboutLauncher.MC")) {
                AboutWindowManager.shared.show(with: settings)
            }
        }
    }
}



