//
//  AppThemesVCViewModel.swift
//  X-Lab
//
//  Created by IPS-161 on 14/02/24.
//

import Foundation
import UIKit

protocol AppThemesVCViewModelProtocol {
    func viewDidload()
    var colorsArray:[UIColor] { get set }
}

class AppThemesVCViewModel {
    var colorsArray = [UIColor.appRed2!,UIColor.appGreen2!,UIColor.appBlue2!]
    weak var view : AppThemesVCProtocol?
    init(view : AppThemesVCProtocol){
        self.view = view
    }
}

extension AppThemesVCViewModel : AppThemesVCViewModelProtocol {
    func viewDidload(){
        DispatchQueue.main.async { [weak self] in
            self?.view?.setupUI()
            self?.view?.setupCollectionView()
        }
    }
}
