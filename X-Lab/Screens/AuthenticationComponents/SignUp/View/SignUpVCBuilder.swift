//
//  SignUpVCBuilder.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import Foundation
import UIKit

public final class SignUpVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        signUpVC.viewModelProducer = {
            SignUpVCViewModel(view: signUpVC, input:$0)
        }
        return signUpVC
    }
}
