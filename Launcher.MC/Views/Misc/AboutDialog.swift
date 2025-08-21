//
//  AboutDialog.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/18.
//

import SwiftUI

struct AboutDialog: View {
    var settings: SettingsStore
    
    var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
                .padding(.top, 20)
            
            Text("Launcher.MC")
                .font(.system(size: 18, weight: .bold))
            
            Text("Version 1.0.0")
                .foregroundColor(.secondary)
            
            Text("© 2025 SimonMihoyo.")
                .font(.caption)
                .padding(.top, 10)
                .foregroundColor(.secondary)
            
            Text("Published with GPLv3 and ❤️")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button("Close") {
                NSApp.keyWindow?.close()
            }
            .keyboardShortcut(.defaultAction)
            .padding(.bottom, 16)
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 300, height:270)
        .tint(settings.accentColor)
    }
}

class AboutWindowManager: NSObject, ObservableObject, NSWindowDelegate {
    static let shared = AboutWindowManager()
    private(set) var window: NSWindow?
    
    
    func show(with settings: SettingsStore) {
        if window == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 350, height: 320),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.title = "About Launcher.MC"
            window.contentView = NSHostingView(rootView:AboutDialog(settings: settings))
            window.isReleasedWhenClosed = false //防止自动释放，以便重复打开
            window.center()
            window.delegate = self //设置代理
            self.window = window
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
        
    // MARK: - NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        window = nil //窗口关闭时清除引用
    }
}

#Preview {
    //@EnvironmentObject var settings: SettingsStore
    //AboutDialog()
}
