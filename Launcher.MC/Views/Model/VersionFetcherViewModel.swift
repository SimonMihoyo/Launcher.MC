//
//  VersionFetcherViewModel.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/16.
//

import SwiftUI
import Combine

class VersionFetcherViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var versions: [VersionInfo] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    // 版本类型过滤选项
    @Published var showRelease = true
    @Published var showSnapshot = false
    @Published var showAncient = false

    // MARK: - Private fetcher
    private let fetcher = MinecraftVersionFetcher()
    
    // MARK: - Public API
    
    /// 加载所有版本（依据版本类型过滤）
    func loadAllVersions() {
        isLoading = true
        errorMessage = nil
        
        fetcher.fetchAllVersions { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let list):
                    self?.versions = list
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }
    
    /// 获取版本详情
    func fetchDetails(for version: VersionInfo, completion: @escaping (VersionDetails?) -> Void) {
        isLoading = true
        fetcher.fetchVersionDetails(for: version) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let details):
                    completion(details)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    /// 强制刷新缓存并重新加载数据
    func refreshCacheAndReload() {
        isLoading = true
        errorMessage = nil
        
        fetcher.refreshCache { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadAllVersions()
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    // MARK: - 初始化时自动加载
    init() {
        loadAllVersions()
    }
}
