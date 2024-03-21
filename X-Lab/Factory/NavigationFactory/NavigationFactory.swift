//
//  NavigationFactory.swift
//  Cinemax
//
//  Created by IPS-161 on 29/01/24.
//

import Foundation
import UIKit

typealias NavigationFactoryClosure = (UIViewController) -> UINavigationController

class NavigationFactory {
    static func build(rootView : UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootView)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController.setNavigationBarHidden(true, animated: true)
        return navigationController
    }
}


