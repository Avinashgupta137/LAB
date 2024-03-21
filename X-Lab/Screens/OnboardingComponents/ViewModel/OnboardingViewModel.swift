//
//  OnboardingViewModel.swift
//  X-Lab
//
//  Created by IPS-149 on 08/02/24.
//

import Foundation

protocol OnboardingViewModelProtocol {
    func forwardButtonTapped()
    var onboardScreenImg : [String] { get set }
    var titleDesc : [String] { get set }
    var subTitle : [String] { get set }
    var currentPageIndex : Int { get set }
}

class OnboardingViewModel {
    
    var onboardScreenImg = ["OnBoardImg1", "OnBoardImg2", "OnBoardImg3"]
    var titleDesc = ["Explore the world easily", "Reach the unknown spot", "Make connects with explorer"]
    var subTitle = ["To your desire", "To your destination", "To your dream trip"]
    var currentPageIndex = 0
    weak var view: OnboardingVCProtocol?
    init(view: OnboardingVCProtocol){
        self.view = view
    }
    
}

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func forwardButtonTapped(){
        if currentPageIndex < onboardScreenImg.count - 1 {
            currentPageIndex += 1
        }else{
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .isOnboardingDone, data: "true") { _ in}
            DispatchQueue.main.async { [weak self] in
                self?.view?.goToSignInVC()
            }
        }
    }
}
