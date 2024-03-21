//
//  SignUpVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth


enum AuthenticationError : Error {
    case invalidCredentials(String)
    case serverError(String)
}

protocol SignUpVCViewModelProtocol {
    
    func signUp(email: String?, password: String?)
    func storeCurrentUsersInfo(firstName: String?,lastName: String?,phoneNumber: String?,dateOfBirth: String?,gender: String?,email: String?, completion:@escaping()->())
    
    typealias Input = (
        firstName : Driver<String>,
        lastName : Driver<String>,
        phoneNumber : Driver<String>,
        gender : Driver<String>,
        email : Driver<String>,
        password : Driver<String>,
        login:Driver<Bool>
    )
    
    typealias Output = (
        enableLogin : Driver<Bool>,
        firstNameWarning: Driver<Bool>,
        lastNameWarning: Driver<Bool>,
        phoneNumberWarning: Driver<Bool>,
        genderWarning: Driver<Bool>,
        emailWarning: Driver<Bool>,
        passwordWarning: Driver<Bool>
    )
    
    typealias Producer = (SignUpVCViewModelProtocol.Input) -> SignUpVCViewModelProtocol
    
    var input : Input { get }
    var output : Output { get }
}

class SignUpVCViewModel {
    weak var view: SignUpVCProtocol?
    var input:Input
    var output:Output
    init(view: SignUpVCProtocol,input:Input){
        self.view = view
        self.input = input
        self.output = SignUpVCViewModel.output(input: input)
    }
}

extension SignUpVCViewModel: SignUpVCViewModelProtocol {
    
    func signUp(email: String?, password: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.privateSignUp(email: email, password: password) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.view?.storeCurrentUsersInfo { [weak self] in
                        self?.hideLoader()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                            self?.view?.isSignupSuccessfull = true
                            self?.view?.successAlert(message:"Success.EmailVerificationMailSuccess.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
                        }
                    }
                case.failure(let error):
                    print(error)
                    self?.hideLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                        switch error {
                        case.invalidCredentials(let error):
                            self?.view?.errorAlert(message: error)
                        case.serverError(let error):
                            self?.view?.errorAlert(message: error)
                        }
                    }
                }
            }
        }
    }
    
    private func privateSignUp(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email , let password = password else {
            return completion(.failure(AuthenticationError.invalidCredentials("Error.InvalidCredentials.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError("Error.EmailAlreadyUsed.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
            } else {
                // User created successfully
                print("User created successfully. Verification email sent.")
                // Check if the user's email is verified before allowing login
                if let user = Auth.auth().currentUser {
                    if !user.isEmailVerified {
                        // Send a new verification email
                        user.sendEmailVerification { error in
                            if let error = error {
                                print("Error sending verification email: \(error.localizedDescription)")
                                completion(.failure(AuthenticationError.serverError("Error.EmailVerificationMail.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
                            } else {
                                print("Verification email sent.")
                                completion(.success(true))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func storeCurrentUsersInfo(firstName: String?,lastName: String?,phoneNumber: String?,dateOfBirth: String?,gender: String?,email: String?, completion:@escaping()->()){
        storeCurrentUsersInfoToUserdefault(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", dateOfBirth: dateOfBirth ?? "", gender: gender ?? "", email: email ?? "")
        storeCurrentUsersInfoToFBDatabase(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", dateOfBirth: dateOfBirth ?? "", gender: gender ?? "", email: email ?? "") {
            completion()
        }
    }
    
    private func storeCurrentUsersInfoToFBDatabase(firstName: String,lastName: String,phoneNumber: String,dateOfBirth: String,gender: String,email: String , completion:@escaping()->()){
        StoreUserServerManager.shared.storeCurrentUserDataToServerNameAndEmail(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth, gender: gender, email: email, profileImgUrl: "") { result in
            switch result {
            case.success(let bool):
                print(bool)
                completion()
            case.failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func storeCurrentUsersInfoToUserdefault(firstName: String,lastName: String,phoneNumber: String,dateOfBirth: String,gender: String,email: String){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUserGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersEmail, data: email) { _ in}
    }
    
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .black)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}

private extension SignUpVCViewModel {
    
    static func output(input:Input) -> Output {
        let enableLoginDriver =  Driver.combineLatest(input.firstName.map{($0.isValidName())},
                                                      input.lastName.map{($0.isValidName())},
                                                      input.gender.map{(!$0.isEmpty)},
                                                      input.email.map{( $0.isEmailValid())},
                                                      input.password.map{( !$0.isEmpty && $0.isPasswordValid())})            .map{( $0 && $1 && $2 && $3 && $4 )}
        
        let firstNameWarningDriver = input.firstName.map { !$0.isEmpty }
        let lastNameWarningDriver = input.lastName.map { !$0.isEmpty }
        let phoneNumberWarningDriver = input.phoneNumber.map { $0.isPhoneNumberValid() }
        let genderWarningDriver = input.gender.map { !$0.isEmpty }
        let emailWarningDriver = input.email.map { $0.isEmailValid() }
        let passwordWarningDriver = input.password.map { !$0.isEmpty && $0.isPasswordValid() }
        
        return (
            enableLogin : enableLoginDriver,
            firstNameWarning: firstNameWarningDriver,
            lastNameWarning: lastNameWarningDriver,
            phoneNumberWarning: phoneNumberWarningDriver,
            genderWarning: genderWarningDriver,
            emailWarning: emailWarningDriver,
            passwordWarning: passwordWarningDriver
        )
    }
    
}

