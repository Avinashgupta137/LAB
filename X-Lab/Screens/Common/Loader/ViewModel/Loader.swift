//
//  LoaderVCViewModel.swift
//  Cinemax
//
//  Created by IPS-161 on 31/01/24.
//

import UIKit
import NVActivityIndicatorView

class Loader: NSObject {
    static let shared = Loader()
    private var presentedLoaderVC: UIViewController?
    
    func showLoader(type: NVActivityIndicatorType,color: UIColor) {
        let storyboard = UIStoryboard.Common
        let loaderVC = storyboard.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            loaderVC.modalPresentationStyle = .overFullScreen
            loaderVC.type = type
            loaderVC.color = color
            viewController.present(loaderVC, animated: true, completion: nil)
            self.presentedLoaderVC = loaderVC
        }
    }
    
    func hideLoader() {
        if let loaderVC = presentedLoaderVC {
            loaderVC.dismiss(animated: true, completion: nil)
            presentedLoaderVC = nil // Reset the reference
        }
    }
    
}

//1. ballPulse    2. ballGridPulse    3. ballClipRotate    4. squareSpin
//5. ballClipRotatePulse    6. ballClipRotateMultiple    7. ballPulseRise    8. ballRotate
//9. cubeTransition    10. ballZigZag    11. ballZigZagDeflect    12. ballTrianglePath
//13. ballScale    14. lineScale    15. lineScaleParty    16. ballScaleMultiple
//17. ballPulseSync    18. ballBeat    19. lineScalePulseOut    20. lineScalePulseOutRapid
//21. ballScaleRipple    22. ballScaleRippleMultiple    23. ballSpinFadeLoader    24. lineSpinFadeLoader
//25. triangleSkewSpin    26. pacman    27. ballGridBeat    28. semiCircleSpin
//29. ballRotateChase    30. orbit    31. audioEqualizer    32. circleStrokeSpin
