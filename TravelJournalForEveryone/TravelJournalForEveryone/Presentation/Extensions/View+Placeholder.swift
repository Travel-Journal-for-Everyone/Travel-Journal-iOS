//
//  View+Placeholder.swift
//  TravelJournalForEveryone
//
//  Created by 최주리 on 4/19/25.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when isShowing: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            placeholder()
                .opacity(isShowing ? 1 : 0)
            self
        }
    }
}
