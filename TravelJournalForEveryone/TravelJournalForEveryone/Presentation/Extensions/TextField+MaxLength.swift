//
//  TextField+MaxLength.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/28/25.
//

import SwiftUI

extension TextField {
    func maxLength(
        text: Binding<String>,
        _ maxLength: Int
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: MaxLengthModifier(
                text: text,
                maxLength: maxLength
            )
        )
    }
}
