//
//  ProfileVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 14/02/24.
//

import Foundation
import UIKit
import RxSwift

protocol ProfileVCViewModelProtocol {
    func viewDidload()
    func viewWillAppear()
    func updateUserImg(image: UIImage)
    func updateUserInfo(firstName: String?,lastName: String?,phoneNumber: String?,dateOfBirth: String?,gender: String?, completion:@escaping(Result<Bool,Error>)->())
}

class ProfileVCViewModel {
    weak var view : ProfileVCProtocol?
    init(view : ProfileVCProtocol){
        self.view = view
    }
}

extension ProfileVCViewModel : ProfileVCViewModelProtocol {
    
    func viewDidload(){
        
    }
    
    func viewWillAppear(){
        updateUI()
    }
    
    func updateUI(){
        if let firstname = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersFirstName),
           let lastname = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersLastName),
           let phonenumber = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersPhoneNumber),
           let dateOfBirth = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersDateOfBirth),
           let gender = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUserGender),
           let email = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersEmail),
           let profileImgUrl = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersProfileImageUrl){
            let user = UserServerModel(uid: "", firstName: firstname, lastName: lastname, phoneNumber: phonenumber, dateOfBirth: dateOfBirth, gender: gender, email: email, profileImgUrl: profileImgUrl)
            DispatchQueue.main.async { [weak self] in
                self?.view?.updateUI(user: user)
            }
        }
    }
    
    
    func updateUserInfo(firstName: String?,lastName: String?,phoneNumber: String?,dateOfBirth: String?,gender: String?, completion:@escaping(Result<Bool,Error>)->()){
        showLoader()
        DispatchQueue.global(qos: .background).async { [weak self] in
            let email = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersEmail)
            let profileImgUrl = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .currentUsersProfileImageUrl)
            self?.storeCurrentUsersInfoToFBDatabase(firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", dateOfBirth: dateOfBirth ?? "", gender: gender ?? "", email: email ?? "" , profileImgUrl : profileImgUrl ?? "") { result in
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoader()
                    completion(result)
                }
            }
        }
    }
    
    
    private func storeCurrentUsersInfoToFBDatabase(firstName: String,lastName: String,phoneNumber: String,dateOfBirth: String,gender: String,email: String,profileImgUrl:String,completion:@escaping(Result<Bool,Error>)->()){
        StoreUserServerManager.shared.storeCurrentUserDataToServerNameAndEmail(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth, gender: gender, email: email, profileImgUrl: profileImgUrl) { result in
            switch result {
            case.success(let bool):
                print(bool)
                self.storeCurrentUsersInfoToUserdefault(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth, gender: gender, profileImgUrl: profileImgUrl)
                completion(.success(bool))
            case.failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    private func storeCurrentUsersInfoToUserdefault(firstName: String,lastName: String,phoneNumber: String,dateOfBirth: String,gender: String,profileImgUrl: String){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersFirstName, data: firstName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersLastName, data: lastName) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersPhoneNumber, data: phoneNumber) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersDateOfBirth, data: dateOfBirth) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUserGender, data: gender) { _ in}
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersProfileImageUrl, data: profileImgUrl) { _ in}
    }
    
    
    func updateUserImg(image: UIImage){
        DispatchQueue.main.async { [weak self] in
            self?.showLoader()
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.saveCurrentUserImgToFirebaseStorageAndDatabase(image: image) { result in
                switch result{
                case.success(let bool):
                    print(bool)
                    DispatchQueue.main.async { [weak self] in
                        self?.hideLoader()
                        self?.updateUI()
                    }
                case.failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        self?.hideLoader()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){  [weak self] in
                        self?.view?.errorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func saveCurrentUserImgToFirebaseStorageAndDatabase(image: UIImage,completion:@escaping(Result<Bool,Error>)->()){
        StoreUserServerManager.shared.saveCurrentUserImageToFirebaseStorage(image: image) { result in
            switch result {
            case.success(let url):
                let profileUrl = url.absoluteString
                self.saveImgUrlToDatabase(url: profileUrl){ urlData in
                    switch urlData {
                    case.success(let bool):
                        completion(.success(bool))
                        self.saveCurrentUserImageUrlToUserDefault(url:profileUrl)
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func saveImgUrlToDatabase(url:String,completion:@escaping(Result<Bool,Error>)->()){
        StoreUserServerManager.shared.saveCurrentUserImageToFirebaseDatabase(url: url) { result in
            completion(result)
        }
    }
    
    private func saveCurrentUserImageUrlToUserDefault(url:String?){
        UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .currentUsersProfileImageUrl, data: url) { _ in}
    }
    
    private func showLoader(){
        Loader.shared.showLoader(type: .lineScale, color: .black)
    }
    
    private func hideLoader(){
        Loader.shared.hideLoader()
    }
    
}
