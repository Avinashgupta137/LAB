//
//  HomeVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 20/02/24.
//

import Foundation

protocol HomeVCViewModelProtocol {
    func viewDidload()
    func viewWillAppear()
    var carouselImg : [String] { get set }
    var carouselTitleText : [String] { get set }
    var carouselSubTitleText : [String] { get set }
}

class HomeVCViewModel {
    
    weak var view : HomeVCProtocol?
    var carouselImg = ["Chichen.Itza","Christ.the.Redeemer","Colosseum","great.wall.of.china","Machu.Picchu","Petra","Taj.Mahal"]
    
    var carouselTitleText = ["Title.ChichenItza".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.ChristtheRedeemer".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.Colosseum".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.GreatwallofChina".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.MachuPicchu".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.Petra".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                             "Title.TajMahal".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())]
    
    var carouselSubTitleText = [
        "Subtitle.ChichenItza".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.ChristtheRedeemer".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.Colosseum".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.GreatwallofChina".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.MachuPicchu".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.Petra".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
        "Subtitle.TajMahal".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())]
    
    init(view : HomeVCProtocol){
        self.view = view
    }
    
}

extension HomeVCViewModel : HomeVCViewModelProtocol {
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.showThankuPopUp()
        }
    }
    func viewWillAppear(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupUI()
            self?.view?.reloadData()
        }
    }
}
