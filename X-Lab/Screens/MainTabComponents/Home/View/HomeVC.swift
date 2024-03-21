//
//  HomeVC.swift
//  X-Lab
//
//  Created by IPS-177  on 08/02/24.
//

import UIKit
import SideMenu
import FirebaseAuth
import RxSwift
import FSPagerView
import CHIPageControl

protocol HomeVCProtocol : AnyObject {
    func setupUI()
    func reloadData()
    func showThankuPopUp()
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var navigationTitleLbl: UILabel!
    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    @IBOutlet weak var carouselTitle: UILabel!
    @IBOutlet weak var carouselSubTitle: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var carousel: FSPagerView! {
        didSet {
            self.carousel.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "imageCell")
            carousel.transformer = FSPagerViewTransformer(type: .cubic)
        }
    }
    
    var viewModel : HomeVCViewModelProtocol?
    private let disposeBag = DisposeBag()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeVCViewModel(view: self)
        viewModel?.viewDidload()
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    
    // MARK: - Navigation Button
    @IBAction func sideMenu(_ sender: Any) {
        SideMenuVC.presentSideMenu(from: self)
    }
    
}

extension HomeVC : HomeVCProtocol  {
    
    func showThankuPopUp(){
        if let thankuPopUp = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .thankuPopUp)
        {
            if thankuPopUp == "false" {
                showWelcomePopup()
                UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .thankuPopUp, data: "true") { _ in }
            }
        }else{
            showWelcomePopup()
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .thankuPopUp, data: "true") { _ in }
        }
    }
    
    func showWelcomePopup() {
        let popup = UIStoryboard(name: "PopUp", bundle: nil)
        let popVC = popup.instantiateViewController(identifier: "ThankYouPopUP") as! ThankYouPopUP
        popVC.modalPresentationStyle = .overFullScreen
        present(popVC, animated: true, completion: nil)
    }
    
    func setupUI(){
        
        pageControl.numberOfPages = viewModel?.carouselImg.count ?? 0
        pageControl.tintColor = UIColor(named: "AppBlue")
        pageControl.currentPageTintColor = .black
        pageControl.elementWidth = 30
        self.view.layoutIfNeeded()
        navigationTitleLbl.text = "Home".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        startTimer()
        
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.sideMenuBtn.tintColor = color
                self?.navigationTitleLbl.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor2Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.middleView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor3Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                
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
                if let font = UIFont(name: fontName, size: 30) {
                    self?.carouselTitle.font = font
                }
                if let font = UIFont(name: fontName, size: 25) {
                    self?.carouselSubTitle.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTitleLbl.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
    func reloadData(){
        viewModel?.carouselTitleText = ["Title.ChichenItza".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.ChristtheRedeemer".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.Colosseum".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.GreatwallofChina".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.MachuPicchu".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.Petra".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
                                        "Title.TajMahal".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())]
        
        viewModel?.carouselSubTitleText = [
            "Subtitle.ChichenItza".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.ChristtheRedeemer".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.Colosseum".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.GreatwallofChina".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.MachuPicchu".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.Petra".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()),
            "Subtitle.TajMahal".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())]
        carousel.reloadData()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updatePageControl), userInfo: nil, repeats: true)
    }
    
    @objc func updatePageControl() {
        let currentIndex = carousel.currentIndex
        let nextPage = (currentIndex + 1) % (viewModel?.carouselImg.count ?? 0)
        carousel.scrollToItem(at: nextPage, animated: true)
        pageControl.set(progress: nextPage, animated: true)
    }
    
}

extension HomeVC : FSPagerViewDelegate, FSPagerViewDataSource {
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentIndex = pagerView.currentIndex
        if currentIndex >= 0 && currentIndex < viewModel?.carouselTitleText.count ?? 0 {
            carouselTitle.alpha = 0
            carouselSubTitle.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.carouselTitle.text = self.viewModel?.carouselTitleText[currentIndex]
                self.carouselSubTitle.text = self.viewModel?.carouselSubTitleText[currentIndex]
                self.carouselTitle.alpha = 1
                self.carouselSubTitle.alpha = 1
            }, completion: nil)
        }
        pageControl.set(progress: pagerView.currentIndex, animated: true)
        
        timer?.invalidate()
        startTimer()
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel?.carouselImg.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "imageCell", at: index) as! FSPagerViewCell
        cell.imageView?.image = UIImage(named:(viewModel?.carouselImg[index] ?? ""))
        return cell
    }
}
