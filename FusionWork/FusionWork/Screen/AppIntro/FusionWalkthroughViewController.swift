//
//  FusionWalkthroughViewController.swift
//  FusionWork
//
//  Created by Hartzed Story on 28/5/25.
//

import UIKit

class FusionWalkthroughViewController: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageControl.currentPage = currentPage
        drawUI(currentPage: currentPage)
    }

    func configContent(currentPage: Int) {
        if currentPage == 0 {
            self.lblTitle.text = "Task & Subtask"
            self.lblDescription.text = "Smart. Simple. Seamless\nManaging your tasks has never been easier"
        } else if currentPage == 1 {
            self.lblTitle.text = "Notification"
            self.lblDescription.text = "Plan your time\nStay your work on track"
        } else if currentPage == 2 {
            self.lblTitle.text = "Visualized Chart"
            self.lblDescription.text = "Monitor work progress\nand elevate team efficiency with ease"
        } else {
            
        }
    }
    
    func drawUI(currentPage: Int) {
        pageControl.currentPage = currentPage
        configContent(currentPage: currentPage)
        if currentPage < 2 {
            btnNext.setImage(UIImage(named: "ic_intro_next"), for: .normal)
        } else {
            btnNext.setImage(UIImage(named: "ic_intro_done"), for: .normal)
        }
        self.scrollView.setContentOffset(CGPoint(x: Int(scrollView.frame.width) * currentPage, y: 0), animated: true)
    }
    
    @IBAction func nextOnTap(_ sender: Any) {
        if currentPage < 2 {
            currentPage += 1
            drawUI(currentPage: currentPage)
        } else {
            self.dismiss(animated: true)
        }
    }
}

extension FusionWalkthroughViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        self.currentPage = Int(round(scrollView.contentOffset.x / width))
        drawUI(currentPage: self.currentPage)
    }
}
