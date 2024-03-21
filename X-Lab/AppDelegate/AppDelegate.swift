//
//  AppDelegate.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       


        if UIApplication.isFirstLaunch() {
            if UserDefaults.standard.value(forKey: "AppleLanguages") == nil {
                // If not set, retrieve the system language
                let systemLanguage = Locale.preferredLanguages.first ?? "en"
                
                // Set the app language to English or Hindi, default to English if not either
                let languageCode = (systemLanguage.lowercased().hasPrefix("hi")) ? "hi" : "en"
                setAppLanguage(languageCode: languageCode)
            }
            
            // Retrieve the preferred language from UserDefaults or use the current language code
            let preferredLanguage = UserDefaults.standard.string(forKey: "AppleLanguages") ?? LanguageManager.shared.getCurrentLanguageCode()

            // Set the app language
            LanguageManager.shared.setAppLanguage(languageCode: preferredLanguage)
        }



        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        orientationLock = .portrait
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return true
        }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        AppTheme()
        AppFonts()
        return true
    }
    func setAppLanguage(languageCode: String) {
        // Implement logic to set the app language based on the selected languageCode
        
        // For example, you can use UserDefaults to store the selected language
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Notify observers about the language change
        LanguageManager.shared.notifyLanguageChange()
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
