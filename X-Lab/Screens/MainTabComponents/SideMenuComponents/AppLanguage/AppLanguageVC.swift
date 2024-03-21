//
//  AppLanguageVC.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import UIKit
import RxSwift

class AppLanguageVC: UIViewController, LanguageObserver {
    
    @IBOutlet weak var englishBtn: RoundedCornerButton!
    @IBOutlet weak var hindiBtn: RoundedCornerButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var mainView: RoundedCornerView!
    @IBOutlet weak var backBtn: RoundedCornerButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register as an observer for language changes
        LanguageManager.shared.addObserver(self)
    }
    
    deinit {
        // Remove the observer when the view controller is deallocated
        LanguageManager.shared.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupUI()
        englishBtn.setTitle("English".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        hindiBtn.setTitle("Hindi".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        
        navigationTitleLbl.text = "Language".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        headlineLbl.text = "Language.SubTitle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func englishBtnPressed(_ sender: UIButton) {
        setAppLanguage(languageCode: "en")
    }
    
    @IBAction func hindiBtnPressed(_ sender: UIButton) {
        setAppLanguage(languageCode: "hi")
    }
    
}

extension AppLanguageVC {
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.navigationTitleLbl.textColor = color
                self?.headlineLbl.textColor = color
                self?.backBtn.backgroundColor = color
                self?.englishBtn.backgroundColor = color
                self?.hindiBtn.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor2Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                
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
                self?.englishBtn.tintColor = color
                self?.hindiBtn.tintColor = color
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 25) {
                    self?.headlineLbl.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTitleLbl.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setAppLanguage(languageCode: String) {
        // Call the LanguageManager to set the app language
        LanguageManager.shared.setAppLanguage(languageCode: languageCode)
    }
    
    // Implement the LanguageObserver method to handle language changes
    func languageDidChange() {
        // Update UI elements with localized strings or handle other changes
        // For example, update the buttons' titles based on the new language
        englishBtn.setTitle("English".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        hindiBtn.setTitle("Hindi".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        
        navigationTitleLbl.text = "Language".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        headlineLbl.text = "Language.SubTitle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
    }
    
}
