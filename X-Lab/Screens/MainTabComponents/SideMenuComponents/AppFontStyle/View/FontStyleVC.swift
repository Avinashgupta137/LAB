//
//  FontStyleVC.swift
//  X-Lab
//
//  Created by IPS-177  on 13/02/24.
//

import UIKit
import RxSwift

protocol FontStyleVCProtocol : AnyObject {
    func setupUI()
    func updateUI()
}

class FontStyleVC: UIViewController {
    
    
    @IBOutlet weak var tblViewFontOutlet: UITableView!
    @IBOutlet weak var appThemesVCTitleLbl: UILabel!
    @IBOutlet weak var hedlineTxtLbl: UILabel!
    @IBOutlet weak var backBtn: RoundedCornerButton!
    @IBOutlet weak var mainView: RoundedCornerView!
    
    var viewModel : FontStyleVCViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        appThemesVCTitleLbl.text = "Font".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        hedlineTxtLbl.text = "Font.Subtitle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension FontStyleVC : FontStyleVCProtocol {
    
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
                if let font = UIFont(name: fontName, size: 20) {
                    self?.appThemesVCTitleLbl.font = font
                }
                if let font = UIFont(name: fontName, size: 25) {
                    self?.hedlineTxtLbl.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateUI(){
        tblViewFontOutlet.reloadData()
    }
    
}

extension FontStyleVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.dataSource[section].appFontType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppFontStyleTBCell", for: indexPath) as! AppFontStyleTBCell
        guard let cellData = viewModel?.dataSource[indexPath.section].appFontSubTypes else {
            return UITableViewCell()
        }
        cell.configure(appFontSubTypes:cellData)
        return cell
    }
}


