//
//  MainMenu.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/16.
//



import SwiftUI

struct MainMenu: Commands {
    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button("Preferences...") {
                print("Pref selected")
            }
            .keyboardShortcut(",", modifiers: [.command])
            
            Divider()
            
            Button("Check for updates") {
                print("CU selected")
            }
        }
        CommandGroup(replacing: .appInfo) {
            Button(LocalizedStringKey("AboutLauncher.MC")) {
                AboutWindowManager.shared.show()
            }
        }
        CommandMenu("File") {
            Button("New Item") {
                print("New Item selected")
            }
            .keyboardShortcut("n", modifiers: [.command])
            
            Button("Open") {
                print("Open selected")
            }
            .keyboardShortcut("o", modifiers: [.command])
            
            Divider()
            
            Button("Save") {
                print("Save selected")
            }
            .keyboardShortcut("s", modifiers: [.command])
        }
        
        CommandMenu("Edit") {
            Button("Undo") {
                print("Undo selected")
            }
            .keyboardShortcut("z", modifiers: [.command])
            
            Button("Redo") {
                print("Redo selected")
            }
            .keyboardShortcut("z", modifiers: [.command, .shift])
            
            Divider()
            
            Button("Cut") {
                print("Cut selected")
            }
            .keyboardShortcut("x", modifiers: [.command])
            
            Button("Copy") {
                print("Copy selected")
            }
            .keyboardShortcut("c", modifiers: [.command])
            
            Button("Paste") {
                print("Paste selected")
            }
            .keyboardShortcut("v", modifiers: [.command])
        }
        
    }
}



