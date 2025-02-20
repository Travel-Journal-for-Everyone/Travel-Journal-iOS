//
//  CustomNavigationBarModifier.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/20/25.
//

import SwiftUI

struct CustomNavigationBarModifier<C, L, T>: ViewModifier where C: View, L: View, T: View {
    let centerView: (() -> C)?
    let leadingView: (() -> L)?
    let trailingView: (() -> T)?
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    leadingView?()
                    
                    Spacer()
                    
                    trailingView?()
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 30)
                
                HStack {
                    Spacer()
                    
                    centerView?()
                    
                    Spacer()
                }
            }
            content
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
