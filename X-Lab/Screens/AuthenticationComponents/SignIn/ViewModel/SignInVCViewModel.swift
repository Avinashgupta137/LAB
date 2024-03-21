//
//  SignInVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth
import GoogleSignIn

protocol SignInVCViewModelProtocol {
    
    func signIn(email: String?, password: String?)
    func signInWithGoogle(view: UIViewController)
    
    typealias Input = (
        email : Driver<String>,
        password : Driver<String>,
        login:Driver<Bool>
    )
    
    typealias Output = (
        enableLogin : Driver<Bool>,
        emailWarning: Driver<Bool>,
        passwordWarning: Driver<Bool>
    )
    
    typealias Producer = (SignInVCViewModelProtocol.Input) -> SignInVCViewModelProtocol
    
    var input : Input { get }
    var output : Output { get }
}

class SignInVCViewModel {
    weak var view: SignInVCProtocol?
    var input:Input
    var output:Output
    init(view: SignInVCProtocol,input:Input){
        self.view = view
        self.input = input
        self.output = SignInVCViewModel.output(input: input)
    }
}

extension SignInVCViewModel: SignInVCViewModelProtocol {
    
    func signIn(email: String?, password: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.privateSignIn(email: email, password: password) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.storeCurrentUsersInfoToUserdefault { [weak self] in
                        self?.hideLoader()
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.goToMainTabBar()
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
    
    func privateSignIn(email: String?, password: String?, completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email , let password = password else {
            return completion(.failure(AuthenticationError.invalidCredentials("Error.InvalidCredentials.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                // Handle sign-in error
                print("Sign-in error: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError("Error.InvalidEmailAndPassword.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
                return
            }
            print("Sign-in successful with email: \(email)")
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified {
                    completion(.failure(AuthenticationError.invalidCredentials("Error.EmailNotVerify.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
                }else{
                    completion(.success(true))
                }
            }
        }
    }
    
    func signInWithGoogle(view: UIViewController){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.privateSigninWithGoogle(view: view) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.getGoogleUserProfile { [weak self] in
                        self?.hideLoader()
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.goToMainTabBar()
                        }
                    }
                case.failure(let error):
                    print(error)
                    self?.hideLoader()
                }
            }
        }
    }
    
    func privateSigninWithGoogle(view: UIViewController , completion:@escaping(Result<Bool,Error>)->()){
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [weak self] result, error in
            print(error)
            guard error == nil else {
                completion(.failure(error as! Error))
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    completion(.failure(error as! Error))
                    return
                }
                completion(.success(true))
            }
            
        }
    }
    
    
    func getGoogleUserProfile(completion: @escaping () -> ()) {
        FetchUserServerManager.shared.fetchCurrentUserFromFirebase { result in
            switch result {
            case.success(let user):
                if let user = user , user.firstName != "" {
                    self.storeInfo(user:user){ [weak self] in
                        completion()
                    }
                }else{
                    guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                        completion()
                        return
                    }
                    var user = UserServerModel(
                        uid: currentUser.userID ?? "",
                        firstName: currentUser.profile?.givenName ?? "",
                        lastName: currentUser.profile?.familyName ?? "",
                        phoneNumber: "",
                        dateOfBirth: "",
                        gender: "",
                        email: currentUser.profile?.email ?? "",
                        profileImgUrl: currentUser.profile?.imageURL(withDimension: 300)?.absoluteString ?? ""
                    )
                    self.storeCurrentUsersInfo(user: user) { [weak self] in
                        completion()
                    }
                }
            case.failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    
    func storeCurrentUsersInfo(user:UserServerModel,completion:@escaping()->()){
        storeInfo(user: user){}
        storeCurrentUsersInfoToFBDatabase(user: user) { [weak self] in
            completion()
        }
    }
    
    private func storeCurrentUsersInfoToFBDatabase(user:UserServerModel,completion:@escaping()->()){
        StoreUserServerManager.shared.storeCurrentUserDataToServerNameAndEmail(firstName: user.firstName, lastName: user.lastName, phoneNumber: user.phoneNumber, dateOfBirth: user.dateOfBirth, gender: user.gender, email: user.email, profileImgUrl: user.profileImgUrl) { result in
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
    
    private func storeCurrentUsersInfoToUserdefault(completion:@escaping()->()){
        FetchUserServerManager.shared.fetchCurrentUserFromFirebase { result in
            switch result {
            case.success(let user):
                if let user = user {
                    self.storeInfo(user:user){ [weak self] in
                        completion()
                    }
                }
            case.failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    
    private func storeInfo(user:UserServerModel,completion:@escaping()->()){
        guard let currentUsersUid = Auth.auth().currentUser?.uid,
              let firstName = user.firstName,
              let lastName = user.lastName,
              let phoneNumber = user.phoneNumber,
              let dateOfBirth = user.dateOfBirth,
              let gender = user.gender,
              let email = user.email,
              let profileImgUrl = user.profileImgUrl else {
                  completion()
                  return
              }
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersUid, data: currentUsersUid) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUserGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersEmail, data: email) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersProfileImageUrl, data: profileImgUrl) { _ in}
        completion()
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .isLogin, data: "true") { _ in}
    }
    
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .black)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}

private extension SignInVCViewModel {
    
    static func output(input:Input) -> Output {
        let enableLoginDriver =  Driver.combineLatest(input.email.map{( $0.isEmailValid())},
                                                      input.password.map{( !$0.isEmpty && $0.isPasswordValid())})
            .map{( $0 && $1 )}
        
        let emailWarningDriver = input.email.map { $0.isEmailValid() }
        let passwordWarningDriver = input.password.map { !$0.isEmpty && $0.isPasswordValid() }
        
        return (
            enableLogin : enableLoginDriver,
            emailWarning: emailWarningDriver,
            passwordWarning: passwordWarningDriver
        )
    }
    
}
