//
//  CustomLaunchVCBuilder.swift
//  X-Lab
//
//  Created by IPS-149 on 13/02/24.
//

import Foundation
import UIKit

public final class CustomLaunchVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.customLaunchScreen
        let customLaunchVC = storyboard.instantiateViewController(withIdentifier: "CustomLaunchVC") as! CustomLaunchVC
        return customLaunchVC
    }
}

