//
//  SideMenuDetails.swift
//  X-Lab
//
//  Created by IPS-177  on 09/02/24.
//

import Foundation

protocol ItemsViewModelProtocal {
    var items: [Item] {
        get set
    }
    func viewWillAppear()
}

struct Item {
    let name: String
    let icon: String
}

class ItemsViewModel {
    
    var items: [Item] = [
        Item(name: "SideMenu.Theme".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), icon: "paintpalette"),
        Item(name: "SideMenu.Language".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), icon: "person.wave.2"),
        Item(name: "SideMenu.FontStyle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), icon: "character.textbox"),
        Item(name: "SideMenu.PrivacyPolicy".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), icon: "lock.shield"),
        Item(name: "SideMenu.About".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), icon: "book")
    ]
    
    weak var view : SideMenuVCProtocol?
    init(view : SideMenuVCProtocol){
        self.view = view
    }
    
    
}

extension ItemsViewModel : ItemsViewModelProtocal {
    
    func viewWillAppear(){
        updateUI()
    }
    
    private func updateUI(){
        if let firstname = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersFirstName),
           let phonenumber = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersPhoneNumber),
           let profileImgUrl = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersProfileImageUrl){
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateUI(firstname: firstname, phonenumber: phonenumber, profileImgUrl: profileImgUrl)
            }
        }
    }
    
}
