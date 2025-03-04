//
//  SignupCompletionView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct SignupCompletionView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 2) {
                        Text("마루김마루")
                            .font(.pretendardBold(24))
                        Text("님 가입 완료!")
                    }
                    
                    HStack(spacing: 0) {
                        Text("모두의 여행일지")
                            .font(.pretendardBold(24))
                        Text("와")
                    }
                    
                    Text("추억을 만들어 보아요!")
                }
                .font(.pretendardMedium(24))
                
                Spacer()
            }
            .padding(.top, 100)
            
            Spacer()
            
            TJButton(title: "모두의 여행 시작하기") {
                
            }
            .padding(.bottom, 17)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SignupCompletionView()
}
