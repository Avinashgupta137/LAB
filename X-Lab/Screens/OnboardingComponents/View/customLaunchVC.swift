//
//  customLaunchVC.swift
//  X-Lab
//
//  Created by IPS-149 on 13/02/24.
//

import UIKit
import FirebaseAuth

class CustomLaunchVC: UIViewController {
    
    @IBOutlet weak var gifImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifImg.loadGif(name: "giphy")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.redirectUser()
        }
    }
    
    private func redirectUser() {
        UIApplication.shared.windows.first?.rootViewController = setupScreens()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    private func setupScreens() -> UIViewController {
        if let isOnboardingDone = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .isOnboardingDone) {
            if let isLogin = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .isLogin), let currentUser = Auth.auth().currentUser, currentUser.isEmailVerified && isLogin == "true"{
                return MainTabVCBuilder.build()
            }else{
                return SignInVCBuilder.build(factory: NavigationFactory.build(rootView:))
            }
        } else {
            return OnboardingVCBuilder.build(factory: NavigationFactory.build(rootView:))
        }
    }
    
}


