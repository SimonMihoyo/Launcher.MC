//
//  SideBar.swift
//  Launcher.MC
//
//  Created by 四月初一茶染绮良 on 2025/7/15.
//

import SwiftUI

struct SideBar: View {
    @State private var isFavoritesExpanded = true
    @State private var isFoldersExpanded = true
    @State private var isDownloadsExpanded = true
    @EnvironmentObject var settings: SettingsStore
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $isFavoritesExpanded) {
                NavigationLink(destination: HomeView())
                {
                    Label("Home", systemImage: "house")
                }
            } label: {
                Label("Favorites", systemImage: "star")
            }
            
            DisclosureGroup(isExpanded: $isDownloadsExpanded) {
                NavigationLink(destination: DownloadsView()){
                    Label("Versions", systemImage: "arrow.down.doc")
                }
                NavigationLink(destination: Text("Mods View")){
                    Label("Mods", systemImage: "puzzlepiece.extension")
                }
                NavigationLink(destination: Text("Shaders View")){
                    Label("Shaders", systemImage: "camera.filters")
                }
                
            } label: {
                Label("Downloads", systemImage: "arrow.down.to.line")
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 150, idealWidth: 150, maxWidth: 300)
        .tint(settings.accentColor)
        
        Spacer()
            .padding(.horizontal, -8)   // 与 List 边距对齐
        
        HStack {
            NavigationLink(destination: AccountView()) {
                Label("Account", systemImage: "person.circle")
            }
            .buttonStyle(PlainButtonStyle())            // 去掉默认的按钮样式
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    NavigationSplitView {
        SideBar()
            .environmentObject(SettingsStore())   // 直接注入
    } detail: {
        Text("Select an item from the sidebar")
    }
}

