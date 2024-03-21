//
//  AppPrivacyVC.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import UIKit
import WebKit
import RxSwift

class AppPrivacyVC: UIViewController {
    
    @IBOutlet weak var backBtn: RoundedCornerButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var mainView: RoundedCornerView!
    
    var webView: WKWebView!
    private let disposeBag = DisposeBag()
    private var viewModel = AppPrivacyVCViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(webView)
        
        // Set constraints to make webView fill the entire mainView
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: mainView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        loadHTMLContent()
        setupUI()
        navigationTitleLbl.text = "PrivacyPolicy".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AppPrivacyVC {
    
    func loadHTMLContent() {
        
        let currentLang = LanguageManager.shared.getCurrentLanguageCode()
        if currentLang == "hi"{
            print("Hindi")
            webView.loadHTMLString(viewModel.htmlHindiString, baseURL: nil)
        }
        else{
            print("English")
            webView.loadHTMLString(viewModel.htmlEngString, baseURL: nil)
        }
        
    }
    
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.navigationTitleLbl.textColor = color
                self?.backBtn.backgroundColor = color
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
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTitleLbl.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
}
