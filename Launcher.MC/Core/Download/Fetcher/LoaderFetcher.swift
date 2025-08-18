//
//  LoaderFetcher.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/8/18.
//

import Foundation
// MARK: - 统一抓取器
class LoaderFetcher: NSObject, XMLParserDelegate {

    // MARK: --------------- 内部状态 ---------------
    private var loader: ModLoader = .forge
    private var versions: [ForgeVersion] = []
    private var currentElement = ""
    private var currentVersion = ""
    private var isParsingVersions = false

    // MARK: --------------- 对外接口 ---------------

    /// 1. 取回指定加载器的全部版本
    func fetchAllVersions(loader: ModLoader = .forge,
                          completion: @escaping (Result<[ForgeVersion], Error>) -> Void) {
        self.loader = loader

        switch loader {
        case .forge, .neoforge:
            fetchForgeMeta(loader: loader, completion: completion)

        case .fabric:
            fetchFabricMeta(completion: completion)
        }
    }

    /// 2. 取回某个 MC 版本对应的全部 Loader 版本
    func fetchVersions(for mcVersion: String,
                       loader: ModLoader = .forge,
                       completion: @escaping (Result<[ForgeVersion], Error>) -> Void) {
        fetchAllVersions(loader: loader) { result in
            switch result {
            case .success(let all):
                let filtered = all.filter { $0.mcversion == mcVersion }
                completion(.success(filtered))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 3. 取回某个 MC 版本最新 Loader 版本
    func fetchLatestVersion(for mcVersion: String,
                            loader: ModLoader = .forge,
                            completion: @escaping (Result<ForgeVersion?, Error>) -> Void) {
        fetchVersions(for: mcVersion, loader: loader) { result in
            switch result {
            case .success(let vers):
                let sorted = vers.sorted { $0.version > $1.version }
                completion(.success(sorted.first))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 4. 生成安装器直链
    func getInstallerURL(for version: ForgeVersion) -> String? {
        switch version.loader {
        case .forge:
            return "https://maven.minecraftforge.net/releases/net/minecraftforge/forge/\(version.mcversion)-\(version.version)/forge-\(version.mcversion)-\(version.version)-installer.jar"
        case .neoforge:
            return "https://maven.neoforged.net/releases/net/neoforged/neoforge/\(version.mcversion)-\(version.version)/neoforge-\(version.mcversion)-\(version.version)-installer.jar"
        case .fabric:
            // Fabric 安装器固定一个 universal jar
            // 真正安装时需要把 loader 版本和游戏版本传给安装器，这里只给出安装器本身
            return "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar"
        }
    }

    // MARK: --------------- Forge / NeoForge 实现 ---------------
    private func fetchForgeMeta(loader: ModLoader,
                                completion: @escaping (Result<[ForgeVersion], Error>) -> Void) {
        let urlStr = loader == .forge
            ? "https://maven.minecraftforge.net/releases/net/minecraftforge/forge/maven-metadata.xml"
            : "https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml"

        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "LoaderFetcher", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                completion(.failure(NSError(domain: "LoaderFetcher", code: -2,
                                            userInfo: [NSLocalizedDescriptionKey: "HTTP error"]))); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "LoaderFetcher", code: -3,
                                            userInfo: [NSLocalizedDescriptionKey: "No data"]))); return
            }

            let parser = XMLParser(data: data)
            let fetcher = LoaderFetcher()
            fetcher.loader = loader
            parser.delegate = fetcher
            fetcher.versions.removeAll()

            if parser.parse() {
                completion(.success(fetcher.versions))
            } else {
                completion(.failure(NSError(domain: "LoaderFetcher", code: -4,
                                            userInfo: [NSLocalizedDescriptionKey: "XML parse failed"])))
            }
        }
        task.resume()
    }

    // MARK: --------------- Fabric 实现 ---------------
    private func fetchFabricMeta(completion: @escaping (Result<[ForgeVersion], Error>) -> Void) {
        struct FabricLoaderResponse: Decodable {
            let version: String
            let stable: Bool
        }

        let urlStr = "https://meta.fabricmc.net/v2/versions/loader/"
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "LoaderFetcher", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { completion(.failure(error)); return }
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                completion(.failure(NSError(domain: "LoaderFetcher", code: -2,
                                            userInfo: [NSLocalizedDescriptionKey: "HTTP error"]))); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "LoaderFetcher", code: -3,
                                            userInfo: [NSLocalizedDescriptionKey: "No data"]))); return
            }

            do {
                let fabricVersions = try JSONDecoder().decode([FabricLoaderResponse].self, from: data)
                let mapped = fabricVersions.map {
                    ForgeVersion(mcversion: "",              // 先留空，真正使用时由外部再过滤
                                 version: $0.version,
                                 type: $0.stable ? "stable" : "unstable",
                                 date: "",
                                 files: [],
                                 loader: .fabric)
                }
                completion(.success(mapped))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // MARK: --------------- XMLParserDelegate（Forge/NeoForge 用） ---------------
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "versions" { isParsingVersions = true }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard isParsingVersions else { return }
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentElement == "version" && !trimmed.isEmpty {
            currentVersion += trimmed
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        if elementName == "version", !currentVersion.isEmpty {
            let mc: String
            let ver: String
            let type: String

            if loader == .neoforge {
                let parts = currentVersion.split(separator: ".")
                guard parts.count >= 2 else { currentVersion = ""; return }
                mc = "1.\(parts[0]).\(parts[1])"
                ver = currentVersion
                type = currentVersion.lowercased().contains("beta") ? "beta" : "release"
            } else {
                let parts = currentVersion.split(separator: "-", maxSplits: 1)
                guard parts.count == 2 else { currentVersion = ""; return }
                mc = String(parts[0])
                ver = String(parts[1])
                type = currentVersion.lowercased().contains("beta") ? "beta" : "release"
            }

            versions.append(ForgeVersion(mcversion: mc,
                                         version: ver,
                                         type: type,
                                         date: "",
                                         files: [],
                                         loader: loader))
            currentVersion = ""
        } else if elementName == "versions" {
            isParsingVersions = false
        }
        currentElement = ""
    }
}
