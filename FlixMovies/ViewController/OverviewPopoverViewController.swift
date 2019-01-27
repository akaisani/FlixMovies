//
//  OverviewPopoverViewController.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/17/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

class OverviewPopoverViewController: UIViewController {

    var overviewText: String!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var overviewPopupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // setting text for overview textview
        self.overviewTextView.text = overviewText
        
        // setting up overview popupview
        self.overviewPopupView.layer.borderWidth = 2.0
        self.overviewPopupView.layer.borderColor = UIColor.white.cgColor
        self.overviewPopupView.layer.cornerRadius = 10
        self.overviewPopupView.layer.masksToBounds = true
    }
    
    @IBAction func exitPopupView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
