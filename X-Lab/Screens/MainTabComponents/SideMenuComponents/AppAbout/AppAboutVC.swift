//
//  AppAboutVC.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import UIKit
import RxSwift

class AppAboutVC: UIViewController {
    
    @IBOutlet weak var backBtn: RoundedCornerButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var mainView: RoundedCornerView!
    @IBOutlet weak var xlabLbl: UILabel!
    @IBOutlet weak var appVersionLbl: UILabel!
    @IBOutlet weak var reDirectLinkLbl: LinkUILabel!
    @IBOutlet weak var reDirectLinkView: RoundedCornerView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationTitleLbl.text = "About".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        appVersionLbl.text = "AppVersion".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        xlabLbl.text = "DevelopedAt".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AppAboutVC {
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.navigationTitleLbl.textColor = color
                self?.backBtn.backgroundColor = color
                self?.xlabLbl.textColor = color
                self?.appVersionLbl.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor2Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.reDirectLinkView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor3Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.mainView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor4Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.view.backgroundColor = color
                self?.reDirectLinkLbl.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 25) {
                    self?.xlabLbl.font = font
                    self?.appVersionLbl.font = font
                    self?.reDirectLinkLbl.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTitleLbl.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
}
