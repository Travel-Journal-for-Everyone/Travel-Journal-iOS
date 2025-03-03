//
//  View+HideKeyboard.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/26/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
