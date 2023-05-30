//
//  KakaoAuthModel.swift
//  KakaoLogInWithCoredata
//
//  Created by Yunwon Han on 2023/05/26.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import CoreData

class KaKaoAuthModel: ObservableObject {
    
    @Published var isLogin: Bool = false
    
    func kakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                if await loginWithKakaoTalk() {
                    DispatchQueue.main.async {
                        self.isLogin = true
                    }
                }
            } else {
                if await loginWithKakaoAccount() {
                    DispatchQueue.main.async {
                        self.isLogin = true
                    }
                }
            }
        }
    }
    
    func kakaoLogout() {
        Task {
            if await logoutWithKakao() {
                DispatchQueue.main.async {
                    self.isLogin = false
                }
            }
        }
    }
    
    // MARK: - 카카오 로그인 (카카오톡 설치 O)
    func loginWithKakaoTalk() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() 호출 성공.")
                    continuation.resume(returning: true)
                    //do something
                    _ = oauthToken
                }
            }
        }
    }
    
    // MARK: - 카카오 로그인 (카카오톡 설치 X)
    func loginWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() 호출 성공.")
                    continuation.resume(returning: true)
                    //do something
                    _ = oauthToken
                }
            }
        }
    }
    
    // MARK: - 카카오 로그아웃
    func logoutWithKakao() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() 호출 성공.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // MARK: - 카카오 사용자 정보 불러오기
    func loadKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                let userID: Int64 = user?.id ?? 0
                
                print("loadKakaoUserInfo() 호출 성공.")
                self.saveUserIdToCoreData(userId: userID)
                //do something
            }
        }
    }
    
    // MARK: - userId를 CoreData에 저장
    func saveUserIdToCoreData(userId: Int64) {
        let context = PersistenceController.shared.container.viewContext

        // 이전에 저장된 데이터를 확인합니다.
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            if users.isEmpty {
                // 이전에 저장된 데이터가 없을 경우에만 저장합니다.
                let newUser = User(context: context)
                newUser.userId = userId

                PersistenceController.shared.save()
            }
        } catch {
            print("유저 데이터를 가져오기 실패했습니다: \(error.localizedDescription)")
        }
    }

}
