//
//  AppFontStyleCVCell.swift
//  X-Lab
//
//  Created by IPS-177  on 16/02/24.
//

import UIKit
import RxSwift

class AppFontStyleCVCell: UICollectionViewCell {
    
    var fontClosure : (()->())?
    private let disposeBag = DisposeBag()
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleLblView: RoundedCornerView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.titleLblView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        AppTheme.shared.appColor4Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.titleLbl.textColor = color
            })
            .disposed(by: disposeBag)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleLblDidTap))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func titleLblDidTap() {
        fontClosure?()
    }
    
}
