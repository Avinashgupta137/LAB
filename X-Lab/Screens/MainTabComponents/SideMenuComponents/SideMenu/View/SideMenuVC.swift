//
//  SideMenuVC.swift
//  X-Lab
//
//  Created by IPS-177  on 09/02/24.
//

import UIKit
import SideMenu
import FirebaseAuth
import RxSwift

protocol SideMenuVCProtocol : AnyObject {
    func updateUI(firstname:String,phonenumber:String,profileImgUrl:String)
}

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewAndSocialMediaView: UIView!
    @IBOutlet weak var currentUserProfileImg: CircleImageView!
    @IBOutlet weak var currentUsersFirstname: UILabel!
    @IBOutlet weak var btnLogout: RoundedButton!
    @IBOutlet weak var currentUsersPhonenumber: UILabel!
  
    @IBOutlet weak var headerView: RoundedCornerView!
    
    var viewModel : ItemsViewModelProtocal?
    var sabModelScreens = [AppThemesVCBuilder.build(),AppLanguageVCBuilder.build(),FontStyleVCBuilder.build(),AppPrivacyVCBuilder.build(),AppAboutVCBuilder.build()]
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ItemsViewModel(view: self)
        btnLogout.setTitle("SideMenu.Logout".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    static func presentSideMenu(from viewController: UIViewController) {
        let menu = SideMenuNavigationController(rootViewController: SideMenuVC())
        viewController.present(menu, animated: true, completion: nil)
    }
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        logoutCurrentUser()
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .thankuPopUp, data: "false") { _ in }
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .isLogin, data: "false") { _ in}
    }
    
    @IBAction func instaBtn(_ sender: UIButton) {
        if let url = URL(string: "https://www.instagram.com/itpathsolutions/?hl=en") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func linkedinBtn(_ sender: UIButton) {
        if let url = URL(string: "https://in.linkedin.com/company/itpathsolutions") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func twitterXBtn(_ sender: UIButton) {
        if let url = URL(string: "https://twitter.com/itpathsolutions") {
            UIApplication.shared.open(url)
        }
    }
    func goToSignInVC() {
        let signInVC = SignInVCBuilder.build(factory: NavigationFactory.build(rootView:))
        // Add a fade animation
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            UIApplication.shared.keyWindow?.rootViewController = signInVC
        },completion: nil)
    }
    func logoutCurrentUser() {
        do {
            try Auth.auth().signOut()
            goToSignInVC()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
}


extension SideMenuVC : SideMenuVCProtocol {
    
    func updateUI(firstname:String,phonenumber:String,profileImgUrl:String){
        ImageLoader.loadImage(for: URL(string: profileImgUrl), into: currentUserProfileImg, withPlaceholder: UIImage(systemName: "person.fill"))
        currentUsersFirstname.text = "Hello".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()) + " " + "\(firstname)"
        currentUsersPhonenumber.text = phonenumber
        
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.currentUsersFirstname.textColor = color
                self?.btnLogout.titleLabel?.textColor = color
                self?.btnLogout.tintColor = color
                self?.currentUsersPhonenumber.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor2Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.headerView.backgroundColor = color
                self?.tableViewAndSocialMediaView.backgroundColor = color
                self?.btnLogout.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor3Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.view.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor4Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 25) {
                    self?.currentUsersFirstname.font = font
                    self?.currentUsersPhonenumber.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.btnLogout.titleLabel?.font = font
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension SideMenuVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuCell
        if let item = viewModel?.items[indexPath.row] {
            cell.configure(item: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destinationVC = sabModelScreens[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}


