//
//  KakaoLogInWithCoredataApp.swift
//  KakaoLogInWithCoredata
//
//  Created by Yunwon Han on 2023/05/24.
//

import SwiftUI

@main
struct KakaoLogInWithCoredataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
