//
//  LinkUILabel.swift
//  X-Lab
//
//  Created by IPS-149 on 19/02/24.
//

import UIKit

@IBDesignable
class LinkUILabel: UILabel{
    
    @IBInspectable
    var url: String?{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tap)
        }
    }
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        // Tap serviceConditions handler
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    private func openUrl(urlString: String!) {
        var url = URL(string: urlString)!
        if(!urlString.starts(with: "http")){
            url = URL(string: "http://" + urlString)!
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onLabelClic(sender:UITapGestureRecognizer) {
        self.openUrl(urlString: url)
    }
}
