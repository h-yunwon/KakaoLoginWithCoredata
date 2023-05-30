//
//  ContentView.swift
//  KakaoLogInWithCoredata
//
//  Created by Yunwon Han on 2023/05/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTY
    @StateObject var kakaoAuthModel: KaKaoAuthModel = KaKaoAuthModel()
    @State private var userId: Int64 = 0
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            Button(action: {
                
                if !kakaoAuthModel.isLogin {
                    kakaoAuthModel.kakaoLogin()
                    kakaoAuthModel.loadKakaoUserInfo()

                } else {
                    kakaoAuthModel.kakaoLogout()
                }
            }) {
                VStack {
                    
                    Text(kakaoAuthModel.isLogin ?  "유저 아이디: \(userId)": "로그인 해주세요")
                    HStack {
                        Image(systemName: "message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                        
                        Text(kakaoAuthModel.isLogin ? "로그아웃" : "로그인")
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .opacity(0.85)
                    } //: HStack
                    .padding()
                    .background(Color("ColorKakaoButton"))
                    .cornerRadius(12)
                } //: VStack
                .onAppear {
                    fetchUserInfo()
                }
            }//: Button
        }//: VStack
    }
    
    func fetchUserInfo() {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            
            if let user = users.first {
                userId = user.userId
            }
        } catch {
            print("유저 데이터를 가져오기 실패했습니다: \(error.localizedDescription)")
        }
    }
    
} //: CONTENTVIEW


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
