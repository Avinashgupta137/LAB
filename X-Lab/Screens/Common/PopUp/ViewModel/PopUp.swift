//
//  PopUp.swift
//  X-Lab
//
//  Created by IPS-149 on 09/02/24.
//

import Foundation
import UIKit

public final class PopUpVCBuilder {
    static func buildPopUp(delegate: PopUpDelegate, popUpTitle: String,popUpSubtitle:String, okBtnValue: String,closeBtnValue: String,hideOkBtn: Bool , hideCloseBtn: Bool) -> UIViewController{
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        controller.delegate = delegate // Set HomeVC as delegate
        controller.modalPresentationStyle = .overCurrentContext
        controller.setValues(popUpTitle: popUpTitle,
                             popUpSubtitle: popUpSubtitle,
                             okBtnValue: okBtnValue,
                             closeBtnValue: closeBtnValue,
                             hideOkBtn: hideOkBtn, hideCloseBtn: hideCloseBtn)
        return controller
    }
}



