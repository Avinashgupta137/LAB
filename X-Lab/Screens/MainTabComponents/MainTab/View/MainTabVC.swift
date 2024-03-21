//
//  MainTabVC.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import UIKit
import RxSwift

class MainTabVC: UITabBarController {
    
    @IBOutlet weak var barItemHome: UITabBar!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.tabBar.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor4Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.tabBar.tintColor = color
            })
            .disposed(by: disposeBag)
        if let items = barItemHome.items {
            items[0].title = "HomeTab".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
            items[1].title = "ProfilTab".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        }
        
    }
    
    
    
}
