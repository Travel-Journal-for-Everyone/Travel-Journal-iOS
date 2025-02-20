//
//  LoginView.swift
//  TravelJournalForEveryone
//
//  Created by 김성민 on 2/19/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 2) {
                        Text("모두의 여행 일지")
                            .fontWeight(.bold)
                        // TODO: - 색상 정해주기
                            .background(.purple.opacity(0.2))
                        Text("와 함께")
                    }
                    Text("나만의 여행 일기를")
                    Text("만들어 보세요!")
                }
                .font(.system(size: 24, weight: .medium))
                .padding(.bottom, 282)
                
                Spacer()
            }
            
            VStack(spacing: 10) {
                Text("로그인/회원가입")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.bottom, 8)
                
                TJButton(title: "카카오로 로그인") {
                    
                }
                
                TJButton(title: "애플로 로그인") {
                    
                }
                
                TJButton(title: "구글 로그인") {
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
    }
}

#Preview {
    LoginView()
}
