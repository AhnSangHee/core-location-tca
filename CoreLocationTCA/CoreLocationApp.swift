//
//  CoreLocationApp.swift
//  CoreLocationTCA
//
//  Created by Selina on 2023/04/14.
//

import SwiftUI

import ComposableArchitecture

@main
struct CoreLocationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: Gps.State(),
                    reducer: Gps()
                )
            )
        }
    }
}
