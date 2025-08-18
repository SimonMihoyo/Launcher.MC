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
    
    
    var body: some View {
        List {
            DisclosureGroup(isExpanded: $isFavoritesExpanded) {
                NavigationLink("Home", destination: HomeView())
                NavigationLink("Downloads", destination: //MinecraftVersionView())//
                               DownloadsView())
            } label: {
                Label("Favorites", systemImage: "star.fill")
            }
            
            DisclosureGroup(isExpanded: $isFoldersExpanded) {
                NavigationLink("Projects", destination: Text("Projects View"))
                NavigationLink("Archive", destination: Text("Archive View"))
            } label: {
                Label("Folders", systemImage: "folder.fill")
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 150, idealWidth: 150, maxWidth: 300)
    }
}

#Preview {
    NavigationSplitView {
        SideBar()
    } detail: {
        Text("Select an item from the sidebar")
    }
}

