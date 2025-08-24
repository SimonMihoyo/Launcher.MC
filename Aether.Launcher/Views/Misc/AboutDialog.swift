//
//  AboutDialog.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/18.
//

import SwiftUI

struct AboutDialog: View {
    var settings: SettingsStore
    private var shortVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    //private var Version : String = shortVersion + buildNumber
    
    var body: some View {
        VStack(spacing: 16) {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
                .padding(.top, 20)
            
            Text("Aether.Launcher")
                .font(.system(size: 18, weight: .bold))
            
            // 用法
            Text("Version \(shortVersion)")
                .foregroundColor(.secondary)
            Text("Build \(buildNumber)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("© 2025 SimonMihoyo.")
                .font(.caption)
                .padding(.top, 10)
                .foregroundColor(.secondary)
            
            Text(LocalizedStringKey("PublishedBy"))
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)   // 居中对齐（可选）
                .fixedSize(horizontal: false, vertical: true) // 允许垂直扩展
                .lineSpacing(2)
            
            Spacer()
            
            Button(LocalizedStringKey("CloseWindow")) {
                NSApp.keyWindow?.close()
            }
            .keyboardShortcut(.defaultAction)
            .padding(.bottom, 16)
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 300, height:340)
        .tint(settings.accentColor)
    }
}

class AboutWindowManager: NSObject, ObservableObject, NSWindowDelegate {
    static let shared = AboutWindowManager()
    private(set) var window: NSWindow?
    
    
    func show(with settings: SettingsStore) {
        if window == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 350, height: 390),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            window.title = "About Aether.Launcher"
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
