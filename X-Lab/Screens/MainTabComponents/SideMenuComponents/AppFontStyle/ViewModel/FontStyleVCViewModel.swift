//
//  FontStyleVCViewModel.swift
//  X-Lab
//
//  Created by IPS-177  on 16/02/24.
//

import Foundation
import UIKit

protocol FontStyleVCViewModelProtocol {
    func viewDidload()
    var dataSource : [FontStyleVCModel] { get set }
}

class FontStyleVCViewModel {
    var dataSource = [FontStyleVCModel]()
    weak var view : FontStyleVCProtocol?
    init(view : FontStyleVCProtocol){
        self.view = view
    }
}

extension FontStyleVCViewModel : FontStyleVCViewModelProtocol {
    func viewDidload(){
        view?.setupUI()
        updateUI()
    }
    
    private func updateUI(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.processFonts { data in
                DispatchQueue.main.async { [weak self] in
                    self?.dataSource = data
                    self?.view?.updateUI()
                }
            }
        }
    }
    
    private func processFonts(completion:@escaping([FontStyleVCModel])->()){
        var tempArrayForSection = [FontStyleVCModel]()
        let fontFamilyNames = UIFont.familyNames
        // Iterate through each font family
        for familyName in fontFamilyNames {
            var tempArrayForFonts = [String]()
            print("Font Family: \(familyName)")
            // Get the list of font names within each font family
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            // Print each font name
            for fontName in fontNames {
                tempArrayForFonts.append(fontName)
            }
            tempArrayForSection.append(FontStyleVCModel(appFontType: familyName, appFontSubTypes: tempArrayForFonts))
        }
        completion(tempArrayForSection)
    }
}
