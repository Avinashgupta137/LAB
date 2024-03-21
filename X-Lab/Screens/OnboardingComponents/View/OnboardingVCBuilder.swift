//
//  OnboardingVCBuilder.swift
//  X-Lab
//
//  Created by IPS-177  on 08/02/24.
//

import Foundation
import UIKit

public final class OnboardingVCBuilder {
    static func build(factory:NavigationFactoryClosure) -> UIViewController {
        let storyboard = UIStoryboard.Onboarding
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        let viewModel = OnboardingViewModel(view: onboardingVC)
        onboardingVC.viewModel = viewModel
        return onboardingVC
    }
}
