//
//  HomeView.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/16.
//

import SwiftUI

let fileutil = FileUtil()
let fetcher = LoaderFetcher()
let appThemeColor = Color(red: 0.8, green: 0.2, blue: 0.2) // 红色主题

struct HomeView: View {
    var body: some View {
        GroupBox(label: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Label@*/Text("Label")/*@END_MENU_TOKEN@*/) {
            Button("testForge"){
                // 示例1: 获取所有 Forge 版本
                fetcher.fetchAllVersions { result in
                    switch result {
                    case .success(let versions):
                        print("获取到 \(versions.count) 个 Forge 版本")
                        // 打印前5个版本信息
                        for version in versions.prefix(5) {
                            print("MC版本: \(version.mcversion), Forge版本: \(version.version), 发布日期: \(version.date)")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                // 示例2: 获取特定 Minecraft 版本的 Forge 版本
                fetcher.fetchVersions(for: "1.19.2") { result in
                    switch result {
                    case .success(let versions):
                        print("Minecraft 1.19.2 有 \(versions.count) 个 Forge 版本")
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                // 示例3: 获取特定 Minecraft 版本的最新 Forge 版本及其安装器 URL
                fetcher.fetchLatestVersion(for: "1.20.1") { result in
                    switch result {
                    case .success(let latestVersion):
                        guard let version = latestVersion else {
                            print("未找到 Minecraft 1.20.1 的 Forge 版本")
                            return
                        }
                        print("Minecraft 1.20.1 的最新 Forge 版本是: \(version.version)")
                        
                        if let installerURL = fetcher.getInstallerURL(for: version) {
                            print("安装器下载地址: \(installerURL)")
                        } else {
                            print("未找到安装器下载地址")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
            }
            Button("testNeoForge"){
                // 示例1: 获取所有 NeoForge 版本
                fetcher.fetchAllVersions(loader: .neoforge) { result in
                    switch result {
                    case .success(let versions):
                        print("获取到 \(versions.count) 个 NeoForge 版本")
                        // 打印前5个版本信息
                        for version in versions.prefix(5) {
                            print("MC版本: \(version.mcversion), NeoForge版本: \(version.version), 发布日期: \(version.date)")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                // 示例2: 获取特定 Minecraft 版本的 Forge 版本
                fetcher.fetchVersions(for: "1.21.2",loader: .neoforge) { result in
                    switch result {
                    case .success(let versions):
                        print("Minecraft 1.21.2 有 \(versions.count) 个 NeoForge 版本")
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                
                // 示例3: 获取特定 Minecraft 版本的最新 Forge 版本及其安装器 URL
                fetcher.fetchLatestVersion(for: "1.21.1",loader: .neoforge) { result in
                    switch result {
                    case .success(let latestVersion):
                        guard let version = latestVersion else {
                            print("未找到 Minecraft 1.21.1 的 NeoForge 版本")
                            return
                        }
                        print("Minecraft 1.20.1 的最新 NeoForge 版本是: \(version.version)")
                        
                        if let installerURL = fetcher.getInstallerURL(for: version) {
                            print("安装器下载地址: \(installerURL)")
                        } else {
                            print("未找到安装器下载地址")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
            }
            
            Button("testFabric"){
                // 示例1: 获取所有 Fabric 版本
                fetcher.fetchAllVersions(loader: .fabric) { result in
                    switch result {
                    case .success(let versions):
                        print("获取到 \(versions.count) 个 Fabric 版本")
                        // 打印前5个版本信息
                        for version in versions.prefix(5) {
                            print("MC版本: \(version.mcversion), Fabric版本: \(version.version), 发布日期: \(version.date)")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                // 示例2: 获取特定 Minecraft 版本的 Forge 版本
                fetcher.fetchVersions(for: "1.21.2",loader: .neoforge) { result in
                    switch result {
                    case .success(let versions):
                        print("Minecraft 1.21.2 有 \(versions.count) 个 Fabric 版本")
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
                // 示例3: 获取特定 Minecraft 版本的最新 Forge 版本及其安装器 URL
                fetcher.fetchLatestVersion(for: "1.21.1",loader: .neoforge) { result in
                    switch result {
                    case .success(let latestVersion):
                        guard let version = latestVersion else {
                            print("未找到 Minecraft 1.21.1 的 Fabric 版本")
                            return
                        }
                        print("Minecraft 1.20.1 的最新 fabric 版本是: \(version.version)")
                        
                        if let installerURL = fetcher.getInstallerURL(for: version) {
                            print("安装器下载地址: \(installerURL)")
                        } else {
                            print("未找到安装器下载地址")
                        }
                    case .failure(let error):
                        print("获取失败: \(error.localizedDescription)")
                    }
                }
            }
        }
        .background(.ultraThickMaterial)
    }
}

#Preview {
    HomeView()
}
