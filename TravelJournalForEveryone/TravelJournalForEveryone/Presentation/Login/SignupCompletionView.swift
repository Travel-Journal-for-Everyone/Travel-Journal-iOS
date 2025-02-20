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
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 2) {
                        Text("마루김마루")
                            .fontWeight(.bold)
                        Text("님 가입 완료!")
                    }
                    
                    HStack(spacing: 0) {
                        Text("모두의 여행일지")
                            .fontWeight(.bold)
                        Text("와")
                    }
                    
                    Text("추억을 만들어 보아요!")
                }
                .font(.system(size: 24, weight: .medium))
                
                Spacer()
            }
            .padding(.top, 100)
            
            Spacer()
            
            TJButton(title: "여행 일지 작성하러 가기") {
                
            }
            .padding(.bottom, 17)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
}

#Preview {
    SignupCompletionView()
}
