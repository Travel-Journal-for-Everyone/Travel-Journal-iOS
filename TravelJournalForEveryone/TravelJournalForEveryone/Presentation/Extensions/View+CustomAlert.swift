//
//  View+CustomAlert.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 5/14/25.
//

import SwiftUI

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        alertType: CustomAlertModifier.AlertType,
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                alertType: alertType,
                action: action
            )
        )
    }
}
