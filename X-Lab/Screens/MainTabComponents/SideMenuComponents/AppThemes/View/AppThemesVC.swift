//
//  AppThemesVC.swift
//  X-Lab
//
//  Created by IPS-177  on 12/02/24.
//

import UIKit
import RxSwift

protocol AppThemesVCProtocol : AnyObject {
    func setupUI()
    func setupCollectionView()
}

class AppThemesVC: UIViewController {
    
    @IBOutlet weak var navigationTilteLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var hedlineTxtLbl: UILabel!
    @IBOutlet weak var appThemesVCTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tehemesCollectionViewOutlet: UICollectionView!
    var viewModel : AppThemesVCViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AppThemesVCViewModel(view: self)
        viewModel?.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        appThemesVCTitleLbl.text = "Theme".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        hedlineTxtLbl.text = "Theme.Subtitle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AppThemesVC : AppThemesVCProtocol {
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.appThemesVCTitleLbl.textColor = color
                self?.hedlineTxtLbl.textColor = color
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
                if let font = UIFont(name: fontName, size: 25) {
                    self?.hedlineTxtLbl.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTilteLbl.font = font
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func setupCollectionView(){
        tehemesCollectionViewOutlet.collectionViewLayout = UICollectionViewFlowLayout()
        tehemesCollectionViewOutlet.reloadData()
    }
    
}


extension AppThemesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.colorsArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppThemesVCCollectionCell", for: indexPath) as! AppThemesVCCollectionCell
        var datasource = viewModel?.colorsArray[indexPath.row]
        cell.configure(color: datasource!)
        cell.colorBtnPressedClosure = { [weak self] in
            AppTheme.shared.appThemeColor = datasource
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .appColor, data: self?.storeAppColorInUserDefault(color : datasource!)){ _ in}
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = tehemesCollectionViewOutlet.frame.width
        let collectionViewHeight = tehemesCollectionViewOutlet.frame.height
        let spacingBetweenRow: CGFloat = 10
        let spacingBetweenCells: CGFloat = 5
        let cellWidth = (collectionViewWidth / 2) - spacingBetweenCells
        let cellHeight = (collectionViewHeight / 4) - spacingBetweenRow
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    private func storeAppColorInUserDefault(color:UIColor) -> String {
        switch color {
        case.appRed2!:
            return "appRed2"
        case.appGreen2!:
            return "appGreen2"
        case.appBlue2!:
            return "appBlue2"
        default:
            return "appBlue2"
        }
    }
    
}


