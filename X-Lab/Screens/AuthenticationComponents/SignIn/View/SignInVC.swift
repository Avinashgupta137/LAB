//
//  SignInVC.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignInVCProtocol : AnyObject {
    func errorAlert(message:String)
    func goToMainTabBar()
}

class SignInVC: UIViewController {
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnGoogleLogiin: RoundedCornerButton!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var lblLoginHeader: UILabel!
    @IBOutlet weak var emailAddressTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var passwordHideShowBtn: UIButton!
    @IBOutlet weak var loginBtn: RoundedCornerButton!
    
    @IBOutlet weak var emailView: RoundedCornerView!
    @IBOutlet weak var passwordView: RoundedCornerView!
    
    var viewModel : SignInVCViewModelProtocol?
    var viewModelProducer : SignInVCViewModelProtocol.Producer!
    var isPasswordShow = false {
        didSet{
            passwordTxtFld.isSecureTextEntry = isPasswordShow ? false : true
            passwordHideShowBtn.setImage(UIImage(systemName: isPasswordShow ? "eye.fill" : "eye.slash.fill"), for: .normal)
        }
    }
    private let bag = DisposeBag()
    var doLogIn = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInputs()
        setUpBinding()
        setupUI()
    }
    
    
    @IBAction func passwordHideShowBtnPressed(_ sender: UIButton) {
        isPasswordShow.toggle()
    }
    
    @IBAction func logInBtnPressed(_ sender: UIButton) {
        if doLogIn.value {
            viewModel?.signIn(email: emailAddressTxtFld.text, password: passwordTxtFld.text)
        }else{
            showErrors()
        }
    }
    
    @IBAction func signInWithGoogleBtnPressed(_ sender: UIButton) {
        viewModel?.signInWithGoogle(view: self)
    }
    
    @IBAction func forgetPasswordBtnPressed(_ sender: UIButton) {
        let forgetPasswordVC = ForgetPasswordVCBuilder.build()
        navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVCBuilder.build()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}

extension SignInVC: SignInVCProtocol , PopUpDelegate {
    
    func setupInputs(){
        viewModel = viewModelProducer((
            email: emailAddressTxtFld.rx.text.orEmpty.asDriver(),
            password: passwordTxtFld.rx.text.orEmpty.asDriver(),
            login: doLogIn.asDriver()
        ))
    }
    
    func setUpBinding(){
        viewModel?.output.enableLogin
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableLogin in
                self?.doLogIn.accept(enableLogin)
            }
            .disposed(by: bag)
    }
    
    private func showErrors(){
        if (emailAddressTxtFld.text!.isEmpty) && (passwordTxtFld.text!.isEmpty){
            alert(message: "Fill_Credentials_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            emailView.borderColor = .red
            passwordView.borderColor = .red
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        } else if !(emailAddressTxtFld.text!.isEmailValid()){
            if (emailAddressTxtFld.text!.isEmpty){
                alert(message: "Fill_Email_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message: "Fill_CorrectEmail_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            emailView.borderColor = .red
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(passwordTxtFld.text!.isPasswordValid()){
            if (passwordTxtFld.text!.isEmpty){
                alert(message: "Fill_Password_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message: "Fill_CorrectPassword_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            passwordView.borderColor = .red
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    func setupUI(){
        emailView.borderColor = .lightGray
        passwordView.borderColor = .lightGray
        emailAddressTxtFld.addTarget(self, action: #selector(textFieldDidChangeForEmailaddressTxtFld(_:)), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPasswordTxtFld(_:)), for: .editingChanged)
        lblLoginHeader.text = "Login.Title".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        lblSubHeader.text = "Login.SubTitle".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        emailAddressTxtFld.placeholder = "Login.Email".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        passwordTxtFld.placeholder = ("Login.Password".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
        loginBtn.setTitle("Login.LoginButton".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        btnGoogleLogiin.setTitle("Login.GoogleSignIn".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        btnForgotPassword.setTitle("Login.ForgotPassword".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        btnSignUp.setTitle("Login.SignUp".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        isPasswordShow = false
    }
    
    
    @objc func textFieldDidChangeForEmailaddressTxtFld(_ textField: UITextField) {
        emailView.borderColor = .lightGray
    }
    
    @objc func textFieldDidChangeForPasswordTxtFld(_ textField: UITextField) {
        passwordView.borderColor = .lightGray
    }
    
    func alert(message:String){
        let alertPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Alert.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(alertPopup, animated: true, completion: nil)
    }
    
    
    func errorAlert(message:String){
        let errorPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Error.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(errorPopup, animated: true, completion: nil)
    }
    
    func didTapOKButton() {
        print("didTapOKButton")
    }
    
    func didTapCloseButton() {
        print("didTapCloseButton")
    }
    
    func goToMainTabBar(){
        let mainTabVC = MainTabVCBuilder.build()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = mainTabVC
            window.makeKeyAndVisible()
        }
    }
    
}
