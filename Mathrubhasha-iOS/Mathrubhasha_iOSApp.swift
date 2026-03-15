//
//  Mathrubhasha_iOSApp.swift
//  Mathrubhasha-iOS
//
//  Created by Ganesh Nemmani on 3/15/26.
//
import SwiftUI
import FirebaseCore

@main
struct Mathrubhasha_iOSApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
