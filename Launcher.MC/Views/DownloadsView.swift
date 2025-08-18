//
//  DownloadsView.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/18.
//

import SwiftUI

//MARK: - 主视图
struct DownloadsView: View {
    @StateObject private var vm = VersionFetcherViewModel()
    @State private var showFilterPop = false
    
    private var filteredVersions: [VersionInfo] {
        vm.versions.filter { ver in
            switch ver.type.lowercased() {
            case "release":         return vm.showRelease
            case "snapshot":        return vm.showSnapshot
            case "old_alpha",
                 "old_beta":       return vm.showAncient
            default:               return false
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("正在加载…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errorMessage {
                    ContentUnavailableView(
                        label: {
                            Label("获取数据失败", systemImage: "exclamationmark.triangle")
                        },
                        description: { Text(error) }
                    )
                } else if filteredVersions.isEmpty {
                    ContentUnavailableView(
                        label: { Label("没有符合条件的版本", systemImage: "magnifyingglass") },
                        description: { Text("请尝试调整过滤条件") }
                    )
                }
                else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 220), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(filteredVersions) { version in
                                NavigationLink {
                                    VersionDetail(version: version)
                                } label: {
                                    VersionBox(version: version)
                                }
                                .buttonStyle(.plain) // 去掉默认按钮样式
                            }
                        }
                        .padding()
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color(nsColor: .controlBackgroundColor))
                }
                
            }
            .navigationTitle("Minecraft 版本")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showFilterPop = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .popover(isPresented: $showFilterPop) {
                        FilterPopover(vm: vm)
                            .frame(width: 260, height: 180)
                            .padding()
                    }
                }
            }
        }
    }
}

// MARK: - 单行视图
private struct VersionRow: View {
    let version: VersionInfo
    
    private var tintColor: Color {
        switch version.type.lowercased() {
        case "release":  return .green
        case "snapshot": return .blue
        default:         return .brown
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(tintColor)
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(version.id)
                    .font(.headline)
                Text(version.type.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(version.releaseTime.prefix(10))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 过滤弹窗（Popover 内部）
private struct FilterPopover: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: VersionFetcherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("过滤版本")
                .font(.headline)
            Divider()
            Toggle("正式版", isOn: $vm.showRelease)
            Toggle("快照版", isOn: $vm.showSnapshot)
            Toggle("远古版", isOn: $vm.showAncient)
            Spacer()
            HStack {
                Spacer()
                Button("完成") { dismiss() }
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(width: 240)
    }
}

// MARK: - 版本卡片
private struct VersionBox: View {
    let version: VersionInfo
    
    // 类型颜色
    private var typeColor: Color {
        switch version.type.lowercased() {
        case "release":  return .green
        case "snapshot": return .blue
        default:         return .brown
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 顶部类型标识
            HStack {
                Image(systemName: "circle.fill")
                    .foregroundStyle(typeColor)
                Text(version.type.capitalized)
                    .font(.subheadline.bold())
                Spacer()
            }
            
            // 版本号
            Text(version.id)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            // 日期
            Text(version.releaseTime.prefix(10))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .scaleEffect(1)      // 便于后续 hover 放大
        .animation(.easeOut(duration: 0.15), value: 1)
    }
}

#Preview {
    DownloadsView()
}
