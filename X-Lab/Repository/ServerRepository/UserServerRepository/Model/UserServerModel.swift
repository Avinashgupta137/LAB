//
//  UserServerModel.swift
//  Cinemax
//
//  Created by IPS-161 on 01/02/24.
//

import Foundation

struct UserServerModel {
    var uid:String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var dateOfBirth: String?
    var gender: String?
    var email: String?
    var profileImgUrl: String?
    init( uid:String,
          firstName: String,
          lastName: String,
          phoneNumber: String,
          dateOfBirth: String,
          gender: String,
          email: String,
          profileImgUrl: String){
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.email = email
        self.profileImgUrl = profileImgUrl
    }
}
