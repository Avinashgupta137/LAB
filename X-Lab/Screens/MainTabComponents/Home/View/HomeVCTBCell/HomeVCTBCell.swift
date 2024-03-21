//
//  HomeVCTBCell.swift
//  X-Lab
//
//  Created by IPS-161 on 20/02/24.
//

import UIKit
import RxSwift

class HomeVCTBCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl1: UILabel!
    @IBOutlet weak var cellLbl2: UILabel!
    @IBOutlet weak var mainView: RoundedCornerView!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.mainView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        
        AppTheme.shared.appColor4Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.cellLbl1.textColor = color
                self?.cellLbl2.textColor = color
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 20) {
                    self?.cellLbl1.font = font
                }
                if let font = UIFont(name: fontName, size: 17) {
                    self?.cellLbl2.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}
