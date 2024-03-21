//
//  ProfileVC.swift
//  X-Lab
//
//  Created by IPS-177  on 08/02/24.
//

import UIKit
import YPImagePicker
import RxSwift

protocol ProfileVCProtocol : AnyObject {
    func updateUI(user:UserServerModel)
    func errorAlert(message:String)
}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var navigationTitleTxtLbl: UILabel!
    @IBOutlet weak var currentUsersProfileImg: CircleImageView!
    @IBOutlet weak var currentUsersFirstName: UILabel!
    @IBOutlet weak var currentUsersEmailaddress: UILabel!
    @IBOutlet weak var firstnameTxtFld: UITextField!
    @IBOutlet weak var lastnameTxtFld: UITextField!
    @IBOutlet weak var phonenumberTxtFld: UITextField!
    @IBOutlet weak var dateOfBirthTxtFld: UITextField!
    @IBOutlet weak var genderTxtFld: UITextField!
    @IBOutlet weak var saveChangesBtn: RoundedButton!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var firstNameLblView: UIView!
    @IBOutlet weak var lastNameLblView: UIView!
    @IBOutlet weak var phoneNumberLblView: UIView!
    @IBOutlet weak var dateOfBirthLblView: UIView!
    @IBOutlet weak var genderLblView: UIView!
    @IBOutlet weak var subView: UIView!
    var viewModel : ProfileVCViewModelProtocol?
    var config = YPImagePickerConfiguration()
    var imgPicker = YPImagePicker()
    private let genderOptions = ["Profile.Male".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), "Profile.Female".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())]
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLang()
        viewModel = ProfileVCViewModel(view: self)
        viewModel?.viewDidload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
        setupTextLang()
        setupBirthDatePicker()
        setupGenderPicker()
    }
    
    @IBAction func editProfileBtnPressed(_ sender: UIButton) {
        presentImagePicker()
    }
    
    
    @IBAction func saveChnagesBtnPressed(_ sender: UIButton) {
        if (firstnameTxtFld.text!.isValidName()) && (lastnameTxtFld.text!.isValidName()) && !(genderTxtFld.text!.isEmpty) {
            if !(phonenumberTxtFld.text!.isEmpty){
                if phonenumberTxtFld.text!.isPhoneNumberValid(){
                    saveChanges()
                }else{
                    alert(message:"Fill_Phonenumber_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
                    phonenumberTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
                }
            }else{
                saveChanges()
            }
        }else{
            showErrors()
        }
    }
    
}

extension ProfileVC : ProfileVCProtocol , PopUpDelegate {
    
    private func showErrors(){
        if (firstnameTxtFld.text!.isEmpty) && (lastnameTxtFld.text!.isEmpty) && (genderTxtFld.text!.isEmpty) {
            firstnameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            lastnameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
            alert(message: "Required credentials can't be empty.")
        }else if !(firstnameTxtFld.text!.isValidName()){
            if (firstnameTxtFld.text!.isEmpty) {
                alert(message:"Fill_FirstName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectFirstName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            firstnameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if !(lastnameTxtFld.text!.isValidName()){
            if (lastnameTxtFld.text!.isEmpty) {
                alert(message:"Fill_LastName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }else{
                alert(message:"Fill_CorrectLastName_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            }
            lastnameTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }else if (genderTxtFld.text!.isEmpty){
            alert(message:"Fill_Gender_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
            genderTxtFld.shake(duration: 0.07, repeatCount: 4, autoreverses: true)
        }
    }
    
    private func saveChanges(){
        viewModel?.updateUserInfo(firstName: firstnameTxtFld.text, lastName: lastnameTxtFld.text, phoneNumber: phonenumberTxtFld.text, dateOfBirth: dateOfBirthTxtFld.text, gender: genderTxtFld.text, completion: { result in
            switch result {
            case.success(let bool):
                DispatchQueue.main.async { [weak self] in
                    self?.successAlert(message:"Profile_Update_Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
                }
            case.failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.errorAlert(message: error.localizedDescription)
                }
            }
        })
    }
    
    func setupTextLang() {
        self.navigationTitleTxtLbl.text = "Profile".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        self.lblFirstName.text = "\("Profile.FirstName".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))*"
        self.lblLastName.text = "\("Profile.LastName".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))*"
        self.lblPhoneNumber.text = "Profile.PhomeNumber".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        self.lblDOB.text = "Profile.DOB".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode())
        self.lblGender.text = "\("Profile.Gender".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))*"
        self.saveChangesBtn.setTitle("Profile.SaveBtn".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), for: .normal)
    }
    
    func updateUI(user:UserServerModel){
        currentUsersFirstName.text = user.firstName
        currentUsersEmailaddress.text = user.email
        firstnameTxtFld.text = user.firstName
        lastnameTxtFld.text = user.lastName
        phonenumberTxtFld.text = user.phoneNumber
        dateOfBirthTxtFld.text = user.dateOfBirth
        genderTxtFld.text = user.gender
        ImageLoader.loadImage(for: URL(string: user.profileImgUrl!), into: currentUsersProfileImg, withPlaceholder: UIImage(systemName: "person.fill"))
        setupBirthDatePicker()
        setupGenderPicker()
        setupColors()
        phonenumberTxtFld.delegate = self
    }
    
    func setupColors(){
        
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.navigationTitleTxtLbl.textColor = color
                self?.saveChangesBtn.tintColor = color
                self?.firstNameLblView.tintColor = color
                self?.lastNameLblView.tintColor = color
                self?.phoneNumberLblView.tintColor = color
                self?.dateOfBirthLblView.tintColor = color
                self?.genderLblView.tintColor = color
                self?.currentUsersFirstName.textColor = color
                self?.currentUsersEmailaddress.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppTheme.shared.appColor2Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.firstNameLblView.backgroundColor = color
                self?.lastNameLblView.backgroundColor = color
                self?.phoneNumberLblView.backgroundColor = color
                self?.dateOfBirthLblView.backgroundColor = color
                self?.genderLblView.backgroundColor = color
                self?.subView.backgroundColor = color
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
                self?.saveChangesBtn.backgroundColor = color
                self?.view.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 30) {
                    self?.currentUsersFirstName.font = font
                }
                if let font = UIFont(name: fontName, size: 25) {
                    self?.currentUsersEmailaddress.font = font
                }
                if let font = UIFont(name: fontName, size: 20) {
                    self?.navigationTitleTxtLbl.font = font
                }
                if let font = UIFont(name: fontName, size: 17) {
                    self?.lblGender.font = font
                    self?.lblDOB.font = font
                    self?.lblPhoneNumber.font = font
                    self?.lblFirstName.font = font
                    self?.lblLastName.font = font
                    self?.firstnameTxtFld.font = font
                    self?.lastnameTxtFld.font = font
                    self?.phonenumberTxtFld.font = font
                    self?.dateOfBirthTxtFld.font = font
                    self?.genderTxtFld.font = font
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    
    func presentImagePicker(){
        if let topViewController = UIApplication.topViewController() {
            if topViewController.presentedViewController is YPImagePicker {
                return
            }
        }
        imgPicker.didFinishPicking { [weak self] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    let image = photo.image
                    self?.currentUsersProfileImg.image = image
                    self?.viewModel?.updateUserImg(image: image)
                case .video(let video):
                    break
                }
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(imgPicker, animated: true, completion: nil)
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
    
    func alert(message:String){
        let alertPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Alert.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(alertPopup, animated: true, completion: nil)
    }
    
    
    func successAlert(message:String){
        let successPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Success.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(successPopup, animated: true, completion: nil)
    }
    
    func errorAlert(message:String){
        let errorPopup = PopUpVCBuilder.buildPopUp(delegate: self, popUpTitle: "Error.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), popUpSubtitle: message, okBtnValue: "Ok.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), closeBtnValue: "Close.Button".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()), hideOkBtn: false , hideCloseBtn: true)
        navigationController?.present(errorPopup, animated: true, completion: nil)
    }
    
    func didTapOKButton() {
        
    }
    
    func didTapCloseButton() {
        
    }
    
}

extension ProfileVC:  UIPickerViewDelegate , UIPickerViewDataSource {
    
    func setupGenderPicker(){
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.frame.size = CGSize(width: 0, height: 150)
        genderPicker.showsSelectionIndicator = true
        genderTxtFld.inputView = genderPicker
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

extension ProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstnameTxtFld || textField == lastnameTxtFld || textField == dateOfBirthTxtFld || textField == genderTxtFld {
            return false
        }
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 10
    }
}
