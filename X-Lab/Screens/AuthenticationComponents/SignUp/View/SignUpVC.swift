//
//  SignUpVC.swift
//  X-Lab
//
//  Created by IPS-161 on 07/02/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignUpVCProtocol: AnyObject {
    func errorAlert(message:String)
    func successAlert(message:String)
    func storeCurrentUsersInfo(completion:@escaping()->())
    var isSignupSuccessfull : Bool? { get set }
}

class SignUpVC: UIViewController {
    
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var lblSubHeader: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var genderTxtFld: UITextField!
    @IBOutlet weak var emailAddressTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var passwordHideShowBtn: UIButton!
    @IBOutlet weak var signUpBtn: RoundedCornerButton!
    @IBOutlet weak var firstNameView: RoundedCornerView!
    @IBOutlet weak var lastNameView: RoundedCornerView!
    @IBOutlet weak var phonenumberView: RoundedCornerView!
    @IBOutlet weak var genderView: RoundedCornerView!
    @IBOutlet weak var emailView: RoundedCornerView!
    @IBOutlet weak var passwordView: RoundedCornerView!
    
    
    var viewModel : SignUpVCViewModelProtocol?
    var viewModelProducer : SignUpVCViewModelProtocol.Producer!
    var isPasswordShow = false {
        didSet{
            passwordTxtFld.isSecureTextEntry = isPasswordShow ? false : true
            passwordHideShowBtn.setImage(UIImage(systemName: isPasswordShow ? "eye.fill" : "eye.slash.fill"), for: .normal)
        }
    }
    private let bag = DisposeBag()
    private let genderOptions = ["Male", "Female"]
    var doSignUp = BehaviorRelay<Bool>(value: false)
    var isSignupSuccessfull : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTextLanguage()
        setupInputs()
        setUpBinding()
        setupUI()
        setupBirthDatePicker()
        setupGenderPicker()
        phoneNumberTxtFld.delegate = self
    }
    
    
    @IBAction func passwordHideShowBtnPressed(_ sender: UIButton) {
        isPasswordShow.toggle()
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if doSignUp.value {
            if !(phoneNumberTxtFld.text!.isEmpty){
                if phoneNumberTxtFld.text!.isPhoneNumberValid(){
                    viewModel?.signUp(email: emailAddressTxtFld.text, password: passwordTxtFld.text)
                }else{
                    alert(message:"Fill_Phonenumber_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
                    phonenumberView.borderColor = .red
                    phoneNumberTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
                }
            }else{
                viewModel?.signUp(email: emailAddressTxtFld.text, password: passwordTxtFld.text)
            }
        }else{
            showErrors()
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpVC: SignUpVCProtocol , PopUpDelegate {
    
    private func showErrors(){
        if (firstNameTxtFld.text!.isEmpty) &&
            (lastNameTxtFld.text!.isEmpty) &&
            (genderTxtFld.text!.isEmpty) &&
            (emailAddressTxtFld.text!.isEmpty) &&
            (passwordTxtFld.text!.isEmpty){
            alert(message:"Fill_AllRequiredCredentials_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            firstNameView.borderColor = .red
            lastNameView.borderColor = .red
            genderView.borderColor = .red
            emailView.borderColor = .red
            passwordView.borderColor = .red
            firstNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            lastNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(firstNameTxtFld.text!.isValidName()){
            if(firstNameTxtFld.text!.isEmpty){
                alert(message:"Fill_FirstName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectFirstName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            firstNameView.borderColor = .red
            firstNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(lastNameTxtFld.text!.isValidName()){
            if(lastNameTxtFld.text!.isEmpty){
                alert(message:"Fill_LastName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectLastName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            lastNameView.borderColor = .red
            lastNameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if(genderTxtFld.text!.isEmpty){
            alert(message:"Fill_Gender_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            genderView.borderColor = .red
            genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(emailAddressTxtFld.text!.isEmailValid()){
            if(emailAddressTxtFld.text!.isEmpty){
                alert(message:"Fill_Email_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectEmail_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            emailView.borderColor = .red
            emailAddressTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(passwordTxtFld.text!.isPasswordValid()){
            if(passwordTxtFld.text!.isEmpty){
                alert(message:"Fill_Password_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectPassword_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            passwordView.borderColor = .red
            passwordTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    func setupTextLanguage() {
        
        lblHeader.text = "SignUp.Header".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        lblSubHeader.text = "SignUp.SubHeader".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        btnSignin.setTitle("SignUp.AlreadyAccount".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        
        signUpBtn.setTitle("SignUp.SignUpButton".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
        
        firstNameTxtFld.placeholder = "Profile.FirstName".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        lastNameTxtFld.placeholder = "Profile.LastName".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        phoneNumberTxtFld.placeholder = "Profile.PhomeNumber".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())  + " " + "SignUp.Optional".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        dateOfBirthTxtFld.placeholder = "Profile.DOB".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())  + " " + "SignUp.Optional".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        genderTxtFld.placeholder = "Profile.Gender".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        emailAddressTxtFld.placeholder = "Login.Email".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
        passwordTxtFld.placeholder = "Login.Password".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        
    }
    func setupInputs(){
        viewModel = viewModelProducer((
            firstName : firstNameTxtFld.rx.text.orEmpty.asDriver(),
            lastName : lastNameTxtFld.rx.text.orEmpty.asDriver(),
            phoneNumber : phoneNumberTxtFld.rx.text.orEmpty.asDriver(),
            gender : genderTxtFld.rx.text.orEmpty.asDriver(),
            email : emailAddressTxtFld.rx.text.orEmpty.asDriver(),
            password : passwordTxtFld.rx.text.orEmpty.asDriver(),
            login: doSignUp.asDriver()
        ))
    }
    
    func setUpBinding(){
        viewModel?.output.enableLogin
            .debug("Enable Login Driver", trimOutput: false)
            .drive { [weak self] enableLogin in
                self?.doSignUp.accept(enableLogin)
            }
            .disposed(by: bag)
    }
    
    func setupUI(){
        firstNameView.borderColor = .lightGray
        lastNameView.borderColor = .lightGray
        phonenumberView.borderColor = .lightGray
        genderView.borderColor = .lightGray
        emailView.borderColor = .lightGray
        passwordView.borderColor = .lightGray
        isPasswordShow = false
        isSignupSuccessfull = false
        firstNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForFirstNameTxtFld(_:)), for: .editingChanged)
        lastNameTxtFld.addTarget(self, action: #selector(textFieldDidChangeForLastNameTxtFld(_:)), for: .editingChanged)
        phoneNumberTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPhoneNumberTxtFld(_:)), for: .editingChanged)
        emailAddressTxtFld.addTarget(self, action: #selector(textFieldDidChangeForEmailAddressTxtFld(_:)), for: .editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(textFieldDidChangeForPasswordTxtFld(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChangeForFirstNameTxtFld(_ textField: UITextField) {
        firstNameView.borderColor = .lightGray
    }
    @objc func textFieldDidChangeForLastNameTxtFld(_ textField: UITextField) {
        lastNameView.borderColor = .lightGray
    }
    @objc func textFieldDidChangeForPhoneNumberTxtFld(_ textField: UITextField) {
        phonenumberView.borderColor = .lightGray
    }
    @objc func textFieldDidChangeForGenderTxtFld(_ textField: UITextField) {
        genderView.borderColor = .lightGray
    }
    @objc func textFieldDidChangeForEmailAddressTxtFld(_ textField: UITextField) {
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
    
    func successAlert(message:String){
        let successPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Success.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(successPopup, animated: true, completion: nil)
    }
    
    func didTapOKButton() {
        print("didTapOKButton")
        if isSignupSuccessfull! {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }else{
            
        }
    }
    
    func didTapCloseButton() {
        print("didTapCloseButton")
    }
    
    func setupBirthDatePicker() {
        let birthDatePicker = UIDatePicker()
        birthDatePicker.datePickerMode = .date
        birthDatePicker.maximumDate = Date() // Set maximum date to the current date
        birthDatePicker.addTarget(self, action: #selector(dateChange(birthDatePicker:)), for: .valueChanged)
        birthDatePicker.frame.size = CGSize(width: 0, height: 300)
        birthDatePicker.preferredDatePickerStyle = .wheels
        dateOfBirthTxtFld.inputView = birthDatePicker
    }
    
    @objc func dateChange(birthDatePicker:UIDatePicker){
        dateOfBirthTxtFld.text = formatDate(date: birthDatePicker.date)
    }
    
    func formatDate(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyy"
        return formatter.string(from: date)
    }
    
    func storeCurrentUsersInfo(completion:@escaping()->()){
        viewModel?.storeCurrentUsersInfo(firstName: firstNameTxtFld.text, lastName: lastNameTxtFld.text, phoneNumber: phoneNumberTxtFld.text, dateOfBirth: dateOfBirthTxtFld.text, gender: genderTxtFld.text, email: emailAddressTxtFld.text, completion: {
            completion()
        })
    }
    
    
}

extension SignUpVC:  UIPickerViewDelegate , UIPickerViewDataSource {
    
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.frame.size = CGSize(width: 0, height: 150)
        genderPicker.showsSelectionIndicator = true
        genderTxtFld.inputView = genderPicker
        // Use .editingDidEnd event for UIPickerView
        genderTxtFld.addTarget(self, action: #selector(textFieldDidChangeForGenderTxtFld(_:)), for: .editingDidEnd)
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxtFld.text = genderOptions[row]
    }
    
}

extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTxtFld || textField == lastNameTxtFld || textField == dateOfBirthTxtFld || textField == genderTxtFld{
            return false
        }
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 10
    }
}

