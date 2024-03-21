//
//  AppThemesVCCollectionCell.swift
//  X-Lab
//
//  Created by IPS-161 on 15/02/24.
//

import UIKit

class AppThemesVCCollectionCell: UICollectionViewCell {
    
    var colorBtnPressedClosure : (()->())?
    @IBOutlet weak var colorBtn: RoundedCornerButton!
    
    @IBAction func colorBtnPressed(_ sender: RoundedCornerButton) {
        colorBtnPressedClosure?()
    }
    
    func configure(color:UIColor){
        let colorName = getColorName(for: color)
        colorBtn.setTitle(colorName, for: .normal)
        colorBtn.backgroundColor = color
    }
    
    func getColorName(for color: UIColor) -> String {
        switch color {
        case UIColor.appRed2:
            return "Red"
        case UIColor.appGreen2:
            return "Green"
        case UIColor.appBlue2:
            return "Blue"
        default:
            return "Unknown"
        }
    }
    
}
