//
//  StoreUserServerManager.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

typealias EscapingResultBoolErrorClosure = (Result<Bool, Error>)->()

public final class StoreUserServerManager {
    static let shared = StoreUserServerManager()
    private init(){}
    
    // MARK: - Store Current UserName And Email To Server
    
    func storeCurrentUserDataToServerNameAndEmail(firstName: String?, lastName: String?,phoneNumber: String?, dateOfBirth: String?,gender: String?, email: String?, profileImgUrl:String?,completion: @escaping EscapingResultBoolErrorClosure) {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let firstName = firstName,
              let lastName = lastName,
              let phoneNumber = phoneNumber,
              let dateOfBirth = dateOfBirth,
              let gender = gender,
              let profileImgUrl = profileImgUrl,
              let email = email else {
            completion(.failure(NSError(domain: "X-Lab", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        // Create a dictionary with both the uid and fcmToken
        let data: [String: Any] = ["uid": currentUserId,
                                   "firstName": firstName,
                                   "lastName": lastName,
                                   "phoneNumber": phoneNumber,
                                   "dateOfBirth": dateOfBirth,
                                   "gender": gender,
                                   "profileImgUrl": profileImgUrl,
                                   "email": email]
        // Set the document with the combined data
        userRef.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
        
    }
    
    // MARK: - Update Current UserName In Database
    
    func updateCurrentUserNameInDatabase(name: String?, completion: @escaping EscapingResultBoolErrorClosure) {
        guard let currentUserId = Auth.auth().currentUser?.uid, let name = name else {
            completion(.failure(NSError(domain: "CINEMAX", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in or invalid name"])))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        
        // Create a dictionary with the updated name
        let data: [String: Any] = ["name": name]
        
        // Set the document with the updated data
        userRef.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    
    // MARK: - Save Current User Image To FirebaseStorage
    
    func saveCurrentUserImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        if let uid = Auth.auth().currentUser?.uid {
            let profileImagesRef = storageRef.child("profile_images/\(uid)")
            
            // Get the existing image file name
            profileImagesRef.listAll { (result, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Delete existing files
                for item in result!.items {
                    item.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                    }
                }
                
                // Store the new image
                let imageFileName = "\(UUID().uuidString).jpg"
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let imageRef = profileImagesRef.child(imageFileName)
                    let uploadTask = imageRef.putData(imageData, metadata: nil) { metadata, error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            imageRef.downloadURL { url, error in
                                if let downloadURL = url {
                                    completion(.success(downloadURL))
                                    print(downloadURL)
                                } else {
                                    if let error = error {
                                        completion(.failure(error))
                                    }
                                }
                            }
                        }
                    }
                    
                    uploadTask.observe(.progress) { snapshot in
                        // You can handle progress updates if needed
                    }
                }
            }
        }
    }

    
    // MARK: - Save Current User Image To FirebaseDatabase
    
    func saveCurrentUserImageToFirebaseDatabase(url: String?, completion:@escaping(Result<Bool,Error>)->()){
        guard let profileImgUrl = url else {
            completion(.failure(NSError(domain: "CINEMAX", code: 0, userInfo: [NSLocalizedDescriptionKey: "Url error."])))
            return
        }
        let db = Firestore.firestore()
        if let currentUserId = Auth.auth().currentUser?.uid{
            let userRef = db.collection("users").document(currentUserId)
            // Create a dictionary with both the uid and fcmToken
            let data: [String: Any] = ["profileImgUrl": profileImgUrl]
            // Set the document with the combined data
            userRef.setData(data, merge: true) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
}
