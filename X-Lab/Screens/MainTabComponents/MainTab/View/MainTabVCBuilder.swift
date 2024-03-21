//
//  MainTabVCBuilder.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import Foundation
import UIKit

public final class MainTabVCBuilder {
    static func build() -> UITabBarController {
        let storyboard = UIStoryboard.MainTab
        let mainTabVC = storyboard.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        return mainTabVC
    }
}

