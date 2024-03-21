//
//  UserdefaultRepositoryManager.swift
//  Cinemax
//
//  Created by IPS-161 on 25/01/24.
//

import Foundation

public final class UserdefaultRepositoryManager {
    
    enum UserInfoFromUserdefault: String {
        case isOnboardingDone = "isOnboardingDone"
        case currentUsersUid = "currentUsersUid"
        case currentUsersFirstName = "currentUsersFirstName"
        case currentUsersLastName = "currentUsersLastName"
        case currentUsersPhoneNumber = "currentUsersPhoneNumber"
        case currentUsersDateOfBirth = "currentUsersDateOfBirth"
        case currentUserGender = "currentUserGender"
        case currentUsersEmail = "currentUsersEmail"
        case currentUsersProfileImageUrl = "currentUsersProfileImageUrl"
        case currentAppLanguage = "currentAppLanguage"
        case appColor = "appColor"
        case appFont = "appFont"
        case thankuPopUp = "thankuPopUp"
        case isLogin = "isLogin"
    }
    
    static func fetchUserInfoFromUserdefault(type: UserInfoFromUserdefault) -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var result: String?
        
        // Use a background queue to avoid blocking the main thread
        DispatchQueue.global().async {
            UserdefaultRepository.shared.getData(key: type.rawValue) { (dataResult: Result<String?, Error>) in
                switch dataResult {
                case .success(let data):
                    result = data
                case .failure(let error):
                    print(error)
                }
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        return result
    }
    
    static func storeUserInfoFromUserdefault<T>(type: UserInfoFromUserdefault, data: T?, completion: @escaping (Bool) -> Void) {
        if let data = data {
            UserdefaultRepository.shared.saveData(data, key: type.rawValue, completionhandler: completion)
        } else {
            completion(false)
        }
    }
    
}
