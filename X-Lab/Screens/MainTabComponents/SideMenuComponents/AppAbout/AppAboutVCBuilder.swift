//
//  AppAboutVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import Foundation
import UIKit

public final class AppAboutVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let appAboutVC = storyboard.instantiateViewController(withIdentifier: "AppAboutVC") as! AppAboutVC
        appAboutVC.title = "About"
        return appAboutVC
    }
}

