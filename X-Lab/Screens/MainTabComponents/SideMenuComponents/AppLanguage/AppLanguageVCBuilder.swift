//
//  AppLanguageVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import Foundation
import UIKit

public final class AppLanguageVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let appLanguageVC = storyboard.instantiateViewController(withIdentifier: "AppLanguageVC") as! AppLanguageVC
        appLanguageVC.title = "Language"
        return appLanguageVC
    }
}
