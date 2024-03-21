//
//  FetchUserServerManager.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

public final class FetchUserServerManager {
    static let shared = FetchUserServerManager()
    private init(){}
    
    // MARK: - Fetch CurrentUser From Firebase
    
    func fetchCurrentUserFromFirebase(completion: @escaping (Result<UserServerModel?, Error>) -> Void) {
        if let currentUid = Auth.auth().currentUser?.uid{
            let db = Firestore.firestore()
            db.collection("users").document(currentUid).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching current user: \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let document = document, document.exists {
                    print("Fetched current user document: \(document.data())")
                    let uid = document["uid"] as? String
                    let firstName = document["firstName"] as? String
                    let lastName = document["lastName"] as? String
                    let phoneNumber = document["phoneNumber"] as? String
                    let dateOfBirth = document["dateOfBirth"] as? String
                    let gender = document["gender"] as? String
                    let email = document["email"] as? String
                    let profileImgUrl = document["profileImgUrl"] as? String
                    let user = UserServerModel(uid: uid ?? "", firstName: firstName ?? "", lastName: lastName ?? "", phoneNumber: phoneNumber ?? "", dateOfBirth: dateOfBirth ?? "", gender: gender ?? "", email: email ?? "", profileImgUrl: profileImgUrl ?? "")
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                } else {
                    // User document not found
                    DispatchQueue.main.async {
                        completion(.success(nil))
                    }
                }
            }
        }
    }
    
}







