//
//  SettingsStore.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/20.
//


import SwiftUI

class SettingsStore: ObservableObject {
    @Published var accentColor: Color = Color(red: 57/255, green: 197/255, blue: 187/255) {
        didSet {
            // 保存颜色到用户默认设置
            let components = accentColor.cgColor?.components?.map { Double($0) } ?? [57/255, 197/255, 187/255, 1.0]
            UserDefaults.standard.set(components, forKey: "AccentColor")
        }
    }
    
    init() {
        // 从用户默认设置加载颜色
        // 读取时
        if let components = UserDefaults.standard.array(forKey: "AccentColor") as? [Double],
           components.count >= 3 {
            accentColor = Color(
                red: components[0],
                green: components[1],
                blue: components[2]
            )
        }
    }
}
