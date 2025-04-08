//
//  View+CustomNavigation.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import SwiftUI

extension View {
    func customNavigationBar<C>(
        @ViewBuilder centerView: @escaping () -> C
    ) -> some View where C: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leadingView: { EmptyView() },
                trailingView: { EmptyView() }
            )
        )
    }
    
    func customNavigationBar<C, L>(
        @ViewBuilder centerView: @escaping () -> C,
        @ViewBuilder leadingView: @escaping () -> L
    ) -> some View where C: View, L: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leadingView: leadingView,
                trailingView: { EmptyView() }
            )
        )
    }
    
    func customNavigationBar<C, L, T>(
        @ViewBuilder centerView: @escaping () -> C,
        @ViewBuilder leadingView: @escaping () -> L,
        @ViewBuilder trailingView: @escaping () -> T
    ) -> some View where C: View, L: View, T: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leadingView: leadingView,
                trailingView: trailingView
            )
        )
    }
}
