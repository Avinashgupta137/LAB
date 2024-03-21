//
//  AppThemesVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import Foundation
import UIKit

public final class AppThemesVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let appThemesVC = storyboard.instantiateViewController(withIdentifier: "AppThemesVC") as! AppThemesVC
        return appThemesVC
    }
}
