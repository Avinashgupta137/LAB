//
//  FontStyleVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 13/02/24.
//

import Foundation
import UIKit
public final class FontStyleVCBuilder {
    static func build() -> UIViewController {
        let storyboard = UIStoryboard.MainTab
        let appFontStyleVC = storyboard.instantiateViewController(withIdentifier: "FontStyleVC") as! FontStyleVC
        appFontStyleVC.viewModel =  FontStyleVCViewModel(view: appFontStyleVC)
        return appFontStyleVC
    }
}
