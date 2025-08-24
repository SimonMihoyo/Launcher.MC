//
//  AccountView.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/20.
//

import SwiftUI

// 新建的账户视图
struct AccountView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
                .padding()
            
            Text("这是将来的账户管理页面")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
}
