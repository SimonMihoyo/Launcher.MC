//
//  Settings.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/19.
//

import SwiftUI

/// 主设置页面
struct SettingsView: View {
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        TabView {
            // MARK: - 外观
            AppearanceTab()
                .tabItem {
                    Label("外观", systemImage: "paintbrush")
                }
                .environmentObject(settings)

            // MARK: - 其他
            OtherTab()
                .tabItem {
                    Label("其他", systemImage: "ellipsis.circle")
                }
        }
        // 为窗口提供一个合适的最小尺寸，防止内容被压得太小
        .frame(idealWidth: 380, idealHeight: 160)
    }
}

// MARK: - 预览
#Preview()
{
    SettingsView()
}
