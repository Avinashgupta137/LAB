//
//  SideMenuCell.swift
//  X-Lab
//
//  Created by IPS-177  on 09/02/24.
//

import UIKit
import RxSwift

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var imgIcone: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: RoundedCornerView!
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: Item) {
        imgIcone.image = UIImage(systemName:"\(item.icon)")
        lblName.text = item.name
    }
    
    func setupUI(){
        AppTheme.shared.appColor1Observable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] color in
                self?.mainView.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
        AppFonts.shared.appFontObservable
            .compactMap { $0 } // Filter out nil values
            .subscribe(onNext: { [weak self] fontName in
                if let font = UIFont(name: fontName, size: 16) {
                    self?.lblName.font = font
                }
            })
            .disposed(by: disposeBag)
    }
    
}
