//
//  View+CustomNavigation.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import SwiftUI

extension View {
    func customNavigationBar<C>(
        centerView: @escaping () -> C
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
        centerView: @escaping () -> C,
        leaddingView: @escaping () -> L
    ) -> some View where C: View, L: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leadingView: leaddingView,
                trailingView: { EmptyView() }
            )
        )
    }
    
    func customNavigationBar<C, L, T>(
        centerView: @escaping () -> C,
        leaddingView: @escaping () -> L,
        trailingView: @escaping () -> T
    ) -> some View where C: View, L: View, T: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leadingView: leaddingView,
                trailingView: trailingView
            )
        )
    }
}
