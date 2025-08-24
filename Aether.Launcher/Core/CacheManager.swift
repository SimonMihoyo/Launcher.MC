//
//  CacheManager.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/18.
//

import Foundation

// 通用缓存管理器
class CacheManager<T: Codable> {
    private let cacheFileName: String
    private let cacheExpirationDays: TimeInterval
    private let fileutil = FileUtil()
    
    init(cacheFileName: String, cacheExpirationDays: TimeInterval = 7) {
        self.cacheFileName = cacheFileName
        self.cacheExpirationDays = cacheExpirationDays
    }
    
    /// 获取缓存文件路径
    private var cacheFileURL: URL? {
        let documentsDirectory = fileutil.getCachePath()
        return URL(fileURLWithPath: documentsDirectory)
            .appendingPathComponent(cacheFileName, isDirectory: false)
    }
    
    /// 检查缓存是否有效
    func isCacheValid() -> Bool {
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
    
    /// 从缓存加载数据
    func loadFromCache() -> T? {
        guard let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error loading from cache: \(error)")
            // 如果缓存损坏，删除它
            try? FileManager.default.removeItem(at: url)
            return nil
        }
    }
    
    /// 保存数据到缓存
    func saveToCache(data: T) {
        guard let url = cacheFileURL else {
            return
        }
        
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: url)
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
    
    /// 强制刷新缓存
    func refreshCache(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        // 删除现有缓存
        if let url = cacheFileURL, FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "CacheManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "CacheManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                self.saveToCache(data: decodedData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// 清除缓存
    func clearCache() {
        guard let url = cacheFileURL else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
