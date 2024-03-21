//
//   .swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth

protocol ForgetPasswordVCViewModelProtocol {
    
    func resetPasswordRequest(email: String?)
    
    typealias Input = (
        email : Driver<String>,
        login:Driver<Bool>
    )
    
    typealias Output = (
        enableLogin : Driver<Bool>,
        emailWarning: Driver<Bool>
    )
    
    typealias Producer = (ForgetPasswordVCViewModelProtocol.Input) -> ForgetPasswordVCViewModelProtocol
    
    var input : Input { get }
    var output : Output { get }
}

class ForgetPasswordVCViewModel {
    weak var view : ForgetPasswordVCProtocol?
    var input:Input
    var output:Output
    init(view : ForgetPasswordVCProtocol,input:Input){
        self.view = view
        self.input = input
        self.output = ForgetPasswordVCViewModel.output(input: input)
    }
}

extension ForgetPasswordVCViewModel : ForgetPasswordVCViewModelProtocol {
    
    func resetPasswordRequest(email: String?){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.privateResetPasswordRequest(email: email) { result in
                switch result {
                case.success(let bool):
                    print(bool)
                    self?.hideLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                        self?.view?.successAlert(message:"Success.EmailResetSendSuccessfully.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))
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
    
    func privateResetPasswordRequest(email: String?,completion: @escaping (Result<Bool,AuthenticationError>) -> Void){
        guard let email = email  else {
            return completion(.failure(AuthenticationError.invalidCredentials("Error.InvalidCredentials.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // An error occurred while sending the password reset email
                print("Error: \(error.localizedDescription)")
                completion(.failure(AuthenticationError.serverError("Error.SendingEmailResetRequest.Message".localizableString(loc: LanguageManager.shared.getCurrentLanguageCode()))))
            } else {
                // Password reset email sent successfully
                print("Password reset email sent successfully")
                completion(.success(true))
            }
        }
    }
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .black)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}

private extension ForgetPasswordVCViewModel {
    static func output(input:Input) -> Output {
        let enableLoginDriver =  input.email.map { $0.isEmailValid() }
        let emailWarningDriver = input.email.map { $0.isEmailValid() }
        return (
            enableLogin : enableLoginDriver,
            emailWarning: emailWarningDriver
        )
    }
}
