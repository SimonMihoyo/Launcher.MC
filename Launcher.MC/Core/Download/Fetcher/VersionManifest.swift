//
//  VersionManifest.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/16.
//


import Foundation

// MARK: - 版本获取器（带缓存功能）

class MinecraftVersionFetcher {
    private let versionManifestURL = "https://launchermeta.mojang.com/mc/game/version_manifest.json"
    private let cacheFileName = "minecraft_version_manifest.json"
    private let cacheExpirationDays: TimeInterval = 7 // 缓存7天过期
    
    let fileutil = FileUtil()
    
    /// 获取缓存文件路径（返回 URL）
    private var cacheFileURL: URL? {
        let documentsDirectory = fileutil.getCachePath()
        return URL(fileURLWithPath: documentsDirectory)
            .appendingPathComponent(cacheFileName, isDirectory: false)
    }
    
    /// 检查缓存是否存在且有效
    private func isCacheValid() -> Bool {
        guard let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path) else {
            return false
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let modificationDate = attributes[.modificationDate] as? Date {
                let now = Date()
                let timeSinceModification = now.timeIntervalSince(modificationDate)
                return timeSinceModification < cacheExpirationDays * 24 * 60 * 60
            }
        } catch {
            print("Error checking cache: \(error)")
        }
        
        return false
    }
    
    /// 从缓存加载版本清单
    private func loadFromCache() -> VersionManifest? {
        guard let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url.path))
            return try JSONDecoder().decode(VersionManifest.self, from: data)
        } catch {
            print("Error loading from cache: \(error)")
            // 如果缓存损坏，删除它
            try? FileManager.default.removeItem(atPath: url.path)
            return nil
        }
    }
    
    /// 保存版本清单到缓存
    private func saveToCache(manifest: VersionManifest) {
        guard let url = cacheFileURL else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(manifest)
            try data.write(to: URL(fileURLWithPath: url.path))
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
    
    /// 获取所有版本的基本信息（使用缓存）
    func fetchAllVersions(ignoreSnapshots: Bool = false, completion: @escaping (Result<[VersionInfo], Error>) -> Void) {
        // 先检查缓存
        if isCacheValid(), let cachedManifest = loadFromCache() {
            var versions = cachedManifest.versions
            if ignoreSnapshots {
                versions = versions.filter { $0.type != "snapshot" }
            }
            completion(.success(versions))
            return
        }
        
        // 缓存无效或不存在，从网络获取
        guard let url = URL(string: versionManifestURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let manifest = try JSONDecoder().decode(VersionManifest.self, from: data)
                // 保存到缓存
                self.saveToCache(manifest: manifest)
                
                var versions = manifest.versions
                if ignoreSnapshots {
                    versions = versions.filter { $0.type != "snapshot" }
                }
                
                completion(.success(versions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// 获取指定版本的详细信息（包括下载地址）
    func fetchVersionDetails(for versionInfo: VersionInfo, completion: @escaping (Result<VersionDetails, Error>) -> Void) {
        guard let url = URL(string: versionInfo.url) else {
            completion(.failure(NSError(domain: "Invalid version URL", code: -3, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No version details data", code: -4, userInfo: nil)))
                return
            }
            
            do {
                let details = try JSONDecoder().decode(VersionDetails.self, from: data)
                completion(.success(details))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// 获取最新的发布版本
    func fetchLatestReleaseVersion(completion: @escaping (Result<VersionInfo, Error>) -> Void) {
        fetchAllVersions(ignoreSnapshots: true) { result in
            switch result {
            case .success(let versions):
                // 从版本清单的latest字段获取最新正式版ID
                // 先尝试从缓存或网络获取完整清单以获取latest信息
                if self.isCacheValid(), let cachedManifest = self.loadFromCache() {
                    let latestReleaseId = cachedManifest.latest.release
                    if let latestRelease = versions.first(where: { $0.id == latestReleaseId }) {
                        completion(.success(latestRelease))
                        return
                    }
                }
                
                // 如果找不到，退而求其次找第一个release类型的版本
                if let latestRelease = versions.first(where: { $0.type == "release" }) {
                    completion(.success(latestRelease))
                } else {
                    completion(.failure(NSError(domain: "No release version found", code: -5, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 强制刷新缓存
    func refreshCache(completion: @escaping (Result<Void, Error>) -> Void) {
        // 删除现有缓存
        if let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(atPath: url.path)
        }
        
        // 重新获取并缓存
        guard let url = URL(string: versionManifestURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let manifest = try JSONDecoder().decode(VersionManifest.self, from: data)
                self.saveToCache(manifest: manifest)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
