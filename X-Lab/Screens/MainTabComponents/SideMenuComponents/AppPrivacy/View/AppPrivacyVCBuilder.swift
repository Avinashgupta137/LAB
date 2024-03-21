//
//  AppPrivacyVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import Foundation
import UIKit

public final class AppPrivacyVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let appPrivacyVC = storyboard.instantiateViewController(withIdentifier: "AppPrivacyVC") as! AppPrivacyVC
        appPrivacyVC.title = "Privacy"
        return appPrivacyVC
    }
}
