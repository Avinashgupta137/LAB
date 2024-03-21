//
//  OnboardingVC.swift
//  X-Lab
//
//  Created by IPS-177  on 08/02/24.
//

import UIKit
import FSPagerView
import CHIPageControl

protocol OnboardingVCProtocol: AnyObject {
    func goToSignInVC()
}


class OnboardingVC: UIViewController {
    
    var viewModel : OnboardingViewModelProtocol?
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "imageCell")
            pagerView.transformer = FSPagerViewTransformer(type: .invertedFerrisWheel)
        }
    }
    
    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    @IBOutlet weak var forwardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pagerView.delegate = self
        pagerView.dataSource = self
        
        forwardBtn.layer.cornerRadius = 0.5 * forwardBtn.bounds.size.width
        forwardBtn.clipsToBounds = true
        
        pageControl.numberOfPages = viewModel?.onboardScreenImg.count ?? 0
        pageControl.tintColor = UIColor(named: "AppBlue")
        pageControl.currentPageTintColor = .black
        pageControl.elementWidth = 30
    }
    
    @IBAction func forwardBtnTapped(_ sender: UIButton) {
        viewModel?.forwardButtonTapped()
        pagerView.scrollToItem(at: viewModel?.currentPageIndex ?? 0, animated: true)
        pageControl.set(progress: viewModel?.currentPageIndex ?? 0, animated: true)
    }
}

extension OnboardingVC : OnboardingVCProtocol {
    func goToSignInVC() {
        let signInVC = SignInVCBuilder.build(factory: NavigationFactory.build(rootView:))
        // Add a fade animation
        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            UIApplication.shared.keyWindow?.rootViewController = signInVC
        },completion: nil)
    }
}


extension OnboardingVC: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        let currentIndex = pagerView.currentIndex
        if currentIndex >= 0 && currentIndex < viewModel?.titleDesc.count ?? 0 {
            mainTitle.alpha = 0
            subTitle.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.mainTitle.text = self.viewModel?.titleDesc[currentIndex]
                self.subTitle.text = self.viewModel?.subTitle[currentIndex]
                self.mainTitle.alpha = 1
                self.subTitle.alpha = 1
            }, completion: nil)
        }
    }

    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel?.onboardScreenImg.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "imageCell", at: index) as! FSPagerViewCell
        cell.imageView?.image = UIImage(named:(viewModel?.onboardScreenImg[index])!)
        return cell
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pageControl.set(progress: pagerView.currentIndex, animated: true)        
    }
    
}
