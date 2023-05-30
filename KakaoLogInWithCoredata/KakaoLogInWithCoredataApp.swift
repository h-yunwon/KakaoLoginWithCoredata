//
//  KakaoLogInWithCoredataApp.swift
//  KakaoLogInWithCoredata
//
//  Created by Yunwon Han on 2023/05/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth


@main
struct SwiftUI_testApp: App {

    let kakaoNativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey as! String)
        
        print("kakaoAppkey: \(kakaoNativeAppKey)")
    }

    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            ContentView().onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
