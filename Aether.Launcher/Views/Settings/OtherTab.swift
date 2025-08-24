//
//  OtherTab.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/20.
//

import SwiftUI

/// 「其他」选项卡的占位视图
struct OtherTab: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("其他设置")
                .font(.title2)
                .padding(.bottom, 8)

            Text("这里以后会放置高级选项、实验功能、关于信息等。")
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
