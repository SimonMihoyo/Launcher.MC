//
//  AppearanceTab.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/20.
//

import SwiftUI

struct AppearanceTab: View {
    @EnvironmentObject var settings: SettingsStore
    
    // 预设的颜色选项
    let presetColors: [Color] = [
        Color(red: 57/255, green: 197/255, blue: 187/255), // 原始颜色
        Color(red: 102/255, green: 204/255, blue: 1),
        .blue,
        .red,
        .green,
        .orange,
        .purple,
        .pink,
        .yellow
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("外观设置")
                .font(.title2)
                .padding(.bottom, 8)
            
            Text("强调色设置")
                .font(.headline)
            
            // 预设颜色选择器
            HStack(spacing: 10) {
                ForEach(presetColors, id: \.self) { color in
                    Button(action: {
                        settings.accentColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .overlay(
                                settings.accentColor == color ?
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 36, height: 36) :
                                    nil
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 8)
            
            // 自定义颜色选择器
            ColorPicker("自定义颜色", selection: $settings.accentColor)
                .padding(.vertical, 4)
            
            Spacer()
        }
        .padding()
    }
}
