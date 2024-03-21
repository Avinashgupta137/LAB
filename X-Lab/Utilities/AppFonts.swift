//
//  AppFonts.swift
//  X-Lab
//
//  Created by IPS-177  on 16/02/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public final class AppFonts {
    static let shared = AppFonts()
    init(){
        if let appFont = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .appFont) {
            self.appFont = appFont
            appFontRelay.accept(appFont)
        }else{
            self.appFont = "ArialRoundedMTBold"
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .appFont, data: "ArialRoundedMTBold") { _ in}
        }
    }
    
    var appFont: String? {
        get {
            return appFontRelay.value
        }
        set {
            appFontRelay.accept(newValue)
        }
    }
    
    var appFontObservable: Observable<String?> {
        return appFontRelay.asObservable()
    }
    
    private let appFontRelay = BehaviorRelay<String?>(value: nil)
}
