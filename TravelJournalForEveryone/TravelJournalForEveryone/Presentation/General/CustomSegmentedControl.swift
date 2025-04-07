//
//  CustomSegmentedControl.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 4/7/25.
//

import SwiftUI

struct CustomSegmentedControl: View {
    private let options: [String]
    @Binding var selectedIndex: Int
    private let namespace: Namespace.ID
    
    init(
        options: [String],
        selectedIndex: Binding<Int>,
        namespace: Namespace.ID
    ) {
        self.options = options
        self._selectedIndex = selectedIndex
        self.namespace = namespace
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack(alignment: .bottom) {
                    Text(options[index])
                        .font(.pretendardMedium(16))
                        .foregroundStyle(selectedIndex == index ? .tjBlack : .tjGray3)
                        .offset(y: -3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 29)
                        .contentShape(.rect)
                        .onTapGesture {
                            selectedIndex = index
                        }
                    
                    if selectedIndex == index {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(selectedIndex == index ? .tjPrimaryMain : .tjGray5)
                            .frame(height: selectedIndex == index ? 2 : 1)
                            .matchedGeometryEffect(id: "option", in: namespace)
                    }
                }
                .animation(.spring(), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 29)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.tjGray5)
                .frame(height: 1)
                .offset(y: -0.5)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    CustomSegmentedControl(
        options: ["여행 일지", "플레이스"],
        selectedIndex: .constant(0),
        namespace: namespace
    )
}
