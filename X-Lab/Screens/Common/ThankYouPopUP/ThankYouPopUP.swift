//
//  ThankYouPopUP.swift
//  X-Lab
//
//  Created by IPS-177  on 22/02/24.
//

import UIKit

class ThankYouPopUP: UIViewController {

    @IBOutlet weak var popGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.popGif.loadGif(name: "PartyPop")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+4){
            self.dismiss(animated: true)
        }
    }
    

}
