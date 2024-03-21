//
//  String+Extensions.swift
//  X-Lab
//
//  Created by IPS-161 on 08/02/24.
//

import Foundation

public extension String {
    
    func isEmailValid() -> Bool {
        let regex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let pattern = NSPredicate(format: "SELF MATCHES %@", regex)
        return pattern.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool {
        // Check if password length is at least 6 characters
        guard self.count >= 6 else {
            return false
        }
        
        // Check if password contains at least one alphabet, one integer, and one symbol
        let alphabetSet = CharacterSet.letters
        let digitSet = CharacterSet.decimalDigits
        let symbolSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\",.<>?/")
        
        let containsAlphabet = self.rangeOfCharacter(from: alphabetSet) != nil
        let containsDigit = self.rangeOfCharacter(from: digitSet) != nil
        let containsSymbol = self.rangeOfCharacter(from: symbolSet) != nil
        
        return containsAlphabet && containsDigit && containsSymbol
    }
    
    func isPhoneNumberValid() -> Bool {
        let numericCharacters = CharacterSet.decimalDigits
        let isNumeric = self.unicodeScalars.allSatisfy { numericCharacters.contains($0) }
        return isNumeric && self.count >= 7 && self.count <= 10
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[a-zA-Z]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
}
