//
//  SignInVCBuilder.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import Foundation
import UIKit

public final class SignInVCBuilder {
    static func build(factory:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        signInVC.viewModelProducer = {
            SignInVCViewModel(view: signInVC, input:$0)
        }
        return factory(signInVC)
    }
}



