//
//  ForgetPasswordVC.swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol ForgetPasswordVCProtocol : AnyObject {
    func errorAlert(message:String)
    func successAlert(message:String)
}

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var lblFogotPasswordDetails: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var emailAddressTxtFld: UITextField!
    @IBOutlet weak var submitBtn: RoundedCornerButton!
    @IBOutlet weak var emailWarning: RoundedCornerView!
    
    var viewModel : ForgetPasswordVCViewModelProtocol?
    var viewModelProducer : ForgetPasswordVCViewModelProtocol.Producer!
    private let bag = DisposeBag()
    var doSendRequest = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLanguage()
        setupInputs()
        setUpBinding()
        setupUI()
    }
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if doSendRequest.value {
            viewModel?.resetPasswordRequest(email: emailAddressTxtFld.text)
        }else{
            if !(emailAddressTxtFld.text!.isEmpty){
                alert(message: "Fill_CorrectEmail_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message: "Fill_Email_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            emailWarning.borderColor = .red
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ForgetPasswordVC : ForgetPasswordVCProtocol ,PopUpDelegate {
    
    func setupTextLanguage() {
        lblForgotPassword.text = "Forgot.Header".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        lblFogotPasswordDetails.text = "Forgot.SubHeader".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        emailAddressTxtFld.placeholder = "Login.Email".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        submitBtn.setTitle("Forgot.Submit".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
    }
    
    func setupInputs(){
        viewModel = viewModelProducer((
            email: emailAddressTxtFld.rx.text.orEmpty.asDriver(),
            login: doSendRequest.asDriver()
        ))
    }
    
    func setUpBinding(){
        viewModel?.output.enableLogin
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableLogin in
                self?.doSendRequest.accept(enableLogin)
            }
            .disposed(by: bag)
    }
    
    func setupUI(){
        emailWarning.borderColor = .lightGray
        emailAddressTxtFld.addTarget(self, action: #selector(textFieldDidChangeForEmailAddressTxtFld(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChangeForEmailAddressTxtFld(_ textField: UITextField) {
        emailWarning.borderColor = .lightGray
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
        
    }
    
    func didTapCloseButton() {
        
    }
    
    func successAlert(message:String){
        let successPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Success.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(successPopup, animated: true, completion: nil)
    }
}
