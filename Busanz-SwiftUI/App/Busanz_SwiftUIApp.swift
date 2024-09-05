//
//  Busanz_SwiftUIApp.swift
//  Busanz-SwiftUI
//
//  Created by Hyungjun KIM on 8/5/24.
//

import SwiftUI

@main
struct Busanz_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var favoriteManager = FavoriteManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteManager)
        }
    }
}
