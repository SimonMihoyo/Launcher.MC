

import SwiftUI

// MARK: - 详情页
struct VersionDetail: View {
    let version: VersionInfo
    
    var body: some View {
        VStack(spacing: 20) {
            Text("版本详情")
                .font(.largeTitle.bold())
            Text("ID：\(version.id)")
            Text("类型：\(version.type)")
            Text("发布时间：\(version.releaseTime)")
        }
        .navigationTitle(version.id)
    }
}

