//
//  TravelJournalForEveryoneApp.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

@main
struct TravelJournalForEveryoneApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authViewModel: AuthenticationViewModel())
        }
    }
}
