//
//  PopUpVC.swift
//  X-Lab
//
//  Created by IPS-149 on 09/02/24.
//

import UIKit

protocol PopUpDelegate: AnyObject {
    func didTapOKButton()
    func didTapCloseButton()
}

class PopUpVC: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var popView: UIView!
    
    var isOkbuttonHidden: Bool?
    var isClosebuttonHidden: Bool?
    var okBtnTitle: String?
    var closeBtnTitle: String?
    var titleTxt: String?
    var subTitleTxt: String?
    weak var delegate: PopUpDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popView.layer.cornerRadius = 20
        popView.layer.masksToBounds = true
        okBtn.isHidden = isOkbuttonHidden ?? false
        closeBtn.isHidden = isClosebuttonHidden ?? false
        okBtn.setTitle(okBtnTitle, for: .normal)
        closeBtn.setTitle(closeBtnTitle, for: .normal)
        titleLabel.text = titleTxt
        subTitleLabel.text = subTitleTxt
    }
    
    // MARK: - Actions
    
    @IBAction func okBtnTapped(_ sender: UIButton) {
        delegate?.didTapOKButton()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        delegate?.didTapCloseButton()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Function to set values
    
    func setValues(popUpTitle: String?, popUpSubtitle: String?, okBtnValue: String?, closeBtnValue: String?, hideOkBtn: Bool?, hideCloseBtn: Bool?, okBtnTitleValue: String? = nil, closeBtnTitleValue: String? = nil) {
        titleTxt = popUpTitle
        subTitleTxt = popUpSubtitle
        okBtnTitle = okBtnTitleValue ?? okBtnValue
        closeBtnTitle = closeBtnTitleValue ?? closeBtnValue
        isOkbuttonHidden = hideOkBtn
        isClosebuttonHidden = hideCloseBtn
    }
}
