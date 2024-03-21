//
//  AppTheme.swift
//  X-Lab
//
//  Created by IPS-161 on 15/02/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

public final class AppTheme {
    
    static let shared = AppTheme()
    init() {
        if let appColor = UserdefaultRepositoryManager.fetchUserInfoFromUserdefault(type: .appColor) {
            appThemeColor = getAppColor(appColor: appColor)
        } else {
            appThemeColor = UIColor.appBlue2!
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .appColor, data: "appBlue2") { _ in }
        }
        appColor1Relay.accept(processColorsForAppColor1(color: appThemeColor!))
        appColor2Relay.accept(processColorsForAppColor2(color: appThemeColor!))
        appColor3Relay.accept(processColorsForAppColor3(color: appThemeColor!))
        appColor4Relay.accept(processColorsForAppColor4(color: appThemeColor!))
    }

    
    private let appColor1Relay = BehaviorRelay<UIColor?>(value: UIColor.appBlue1)
    private let appColor2Relay = BehaviorRelay<UIColor?>(value: UIColor.appBlue2)
    private let appColor3Relay = BehaviorRelay<UIColor?>(value: UIColor.appBlue3)
    private let appColor4Relay = BehaviorRelay<UIColor?>(value: UIColor.appBlue4)
    
    
    var appThemeColor : UIColor? {
        willSet(newValue){
            appColor1 = newValue
            appColor2 = newValue
            appColor3 = newValue
            appColor4 = newValue
        }
    }
    
    var appColor1Observable: Observable<UIColor?> {
        return appColor1Relay.asObservable()
    }
    
    var appColor2Observable: Observable<UIColor?> {
        return appColor2Relay.asObservable()
    }
    
    var appColor3Observable: Observable<UIColor?> {
        return appColor3Relay.asObservable()
    }
    
    var appColor4Observable: Observable<UIColor?> {
        return appColor4Relay.asObservable()
    }
    
    var appColor1: UIColor? {
        get {
            return appColor1Relay.value
        }
        set {
            appColor1Relay.accept(processColorsForAppColor1(color: newValue!))
        }
    }
    
    var appColor2: UIColor? {
        get {
            return appColor2Relay.value
        }
        set {
            appColor2Relay.accept(processColorsForAppColor2(color: newValue!))
        }
    }
    
    var appColor3: UIColor? {
        get {
            return appColor3Relay.value
        }
        set {
            appColor3Relay.accept(processColorsForAppColor3(color: newValue!))
        }
    }
    
    var appColor4: UIColor? {
        get {
            return appColor4Relay.value
        }
        set {
            appColor4Relay.accept(processColorsForAppColor4(color: newValue!))
        }
    }
    
    
    
    private func processColorsForAppColor1(color:UIColor) -> UIColor {
        switch color {
        case.appRed2!:
            return UIColor.appRed1!
        case.appGreen2!:
            return UIColor.appGreen1!
        case.appBlue2!:
            return UIColor.appBlue1!
        default:
            return UIColor.black
        }
    }
    
    
    private func processColorsForAppColor2(color:UIColor) -> UIColor {
        switch color {
        case.appRed2!:
            return UIColor.appRed2!
        case.appGreen2!:
            return UIColor.appGreen2!
        case.appBlue2!:
            return UIColor.appBlue2!
        default:
            return UIColor.black
        }
    }
    
    
    private func processColorsForAppColor3(color:UIColor) -> UIColor {
        switch color {
        case.appRed2!:
            return UIColor.appRed3!
        case.appGreen2!:
            return UIColor.appGreen3!
        case.appBlue2!:
            return UIColor.appBlue3!
        default:
            return UIColor.black
        }
    }
    
    
    private func processColorsForAppColor4(color:UIColor) -> UIColor {
        switch color {
        case.appRed2!:
            return UIColor.appRed4!
        case.appGreen2!:
            return UIColor.appGreen4!
        case.appBlue2!:
            return UIColor.appBlue4!
        default:
            return UIColor.black
        }
    }
    
    private func getAppColor(appColor: String) -> UIColor {
        switch appColor {
        case "appRed2":
            return UIColor.appRed2!
        case "appGreen2":
            return UIColor.appGreen2!
        case "appBlue2":
            return UIColor.appBlue2!
        default:
            return UIColor.appBlue2!
        }
    }
    
}
