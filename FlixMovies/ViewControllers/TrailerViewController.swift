//
//  TrailerViewController.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/27/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    
    var urlString: String!
    @IBOutlet weak var trailerWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let mediaURL:URL = URL(string: urlString) {
            let request:URLRequest = URLRequest(url: mediaURL);
            self.trailerWebView.load(request)
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
