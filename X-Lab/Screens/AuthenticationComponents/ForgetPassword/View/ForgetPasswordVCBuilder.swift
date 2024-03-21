//
//  ForgetPasswordVCBuilder.swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import Foundation
import UIKit

public final class ForgetPasswordVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.Authentication
        let forgetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        forgetPasswordVC.viewModelProducer = {
            ForgetPasswordVCViewModel(view: forgetPasswordVC, input:$0)
        }
        return forgetPasswordVC
    }
}

