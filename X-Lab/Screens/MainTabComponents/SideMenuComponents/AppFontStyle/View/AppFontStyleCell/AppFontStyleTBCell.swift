//
//  AppFontStyleTBCell.swift
//  X-Lab
//
//  Created by IPS-177  on 16/02/24.
//

import UIKit

class AppFontStyleTBCell: UITableViewCell {
    
    @IBOutlet weak var fontStyleCollectionViewOutlet: UICollectionView!
    var dataSource = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fontStyleCollectionViewOutlet.delegate = self
        fontStyleCollectionViewOutlet.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(appFontSubTypes:[String]){
        DispatchQueue.main.async { [weak self] in
            self?.dataSource = appFontSubTypes
            self?.fontStyleCollectionViewOutlet.reloadData()
        }
    }
    
}

extension AppFontStyleTBCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppFontStyleCVCell", for: indexPath) as! AppFontStyleCVCell
        let cellData = dataSource[indexPath.row]
        // Use a specific font size, for example, 14
        if let font = UIFont(name: cellData, size: 17) {
            cell.titleLbl.text = cellData
            cell.titleLbl.font = font
        }
        cell.fontClosure = { [weak self] in
            AppFonts.shared.appFont = cellData
            UserdefaultRepositoryManager.storeUserInfoFromUserdefault(type: .appFont, data: cellData) { _ in}
        }
        return cell
    }
}
