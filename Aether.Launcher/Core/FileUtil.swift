//
//  FileManager.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/17.
//

import Foundation

class FileUtil {
    private let fileManager = FileManager.default
    private let AppSDir: URL = {
            guard let url = FileManager.default.urls(for: .applicationSupportDirectory,
                                                     in: .userDomainMask).first else {
                fatalError("无法定位 Application Support 目录")
            }
            return url
        }()
    /// 返回 ~/Library/Application Support/<AppName>/cache 的 URL
    private var cacheURL: URL {
        // 2. 拼接 App 名称
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                   ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
                   ?? "MyApp"
        let appSupportDir = AppSDir.appendingPathComponent(appName, isDirectory: true)

        // 3. 拼接 cache
        let cacheDir = appSupportDir.appendingPathComponent("cache", isDirectory: true)

        // 4. 如果目录不存在就创建
        if !fileManager.fileExists(atPath: cacheDir.path) {
            do {
                try fileManager.createDirectory(at: cacheDir,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                fatalError("创建 cache 目录失败: \(error)")
            }
        }

        return cacheDir
    }

    /// 对外暴露：返回 cache 目录的 String 路径
    public func getCachePath() -> String {
        return cacheURL.path
    }
}
