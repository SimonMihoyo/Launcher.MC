//
//  VersionData.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/16.
//

import Foundation

// MARK: - Mojang数据模型

/// 版本清单响应模型
struct VersionManifest: Codable {
    let versions: [VersionInfo]
    let latest: LatestVersions
}

/// 最新版本信息
struct LatestVersions: Codable {
    let release: String
    let snapshot: String
}

/// 单个版本的基本信息
struct VersionInfo: Codable, Identifiable {
    let id: String
    let type: String
    let url: String
    let time: String
    let releaseTime: String
}

/// 版本详细信息响应模型
struct VersionDetails: Codable {
    let downloads: VersionDownloads
}

/// 版本下载信息
struct VersionDownloads: Codable {
    let client: DownloadInfo?
    let server: DownloadInfo?
}

/// 单个下载项的信息
struct DownloadInfo: Codable {
    let url: String
    let sha1: String
    let size: Int
}

// MARK:  （Neo）/Forge数据模型

/// 统一的数据模型，Forge / NeoForge 都用它
struct ForgeVersion: Codable {
    let mcversion: String
    let version: String
    let type: String
    let date: String
    let files: [ForgeFile]
    let loader: ModLoader
}

/// 表示 Forge 版本相关的文件信息
struct ForgeFile: Codable {
    let format: Int                // 文件格式版本
    let category: String           // 文件类别
    let hash: String               // 文件哈希值
    let path: String               // 文件路径
    let url: String?               // 文件下载 URL
}

// MARK: mod加载器选择器
enum ModLoader: String, Codable {
    case forge
    case neoforge
    case fabric
    //case liteLoader //liteLoader尚未实现
}
