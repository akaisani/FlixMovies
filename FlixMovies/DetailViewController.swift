//
//  DetailViewController.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/17/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    var movie: Movie!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = movie.title
        self.backgroundImageView.image = movie.posterImage
        self.posterImageView.image = movie.posterImage
        self.ratingLabel.text = movie.rating
        self.overviewLabel.text = movie.overview
        self.moreInfoButton.layer.borderColor = UIColor.white.cgColor
        self.moreInfoButton.layer.borderWidth = 2.0
        self.moreInfoButton.layer.cornerRadius = 25
    }
    

    @IBAction func learnMoreButtonPressed(_ sender: Any) {
        TMDBHelper.getMovieHomepage(for: movie.id) { (homepageURL, errorMessage) in
            guard let homepageURL = homepageURL else  {
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: errorMessage!)
                return
            }
            
            // creating safari view controller
            DispatchQueue.main.async {
                let safariVC = SFSafariViewController(url: homepageURL)
                safariVC.delegate = self
                safariVC.preferredBarTintColor = UIColor.darkGray
                self.present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let identifier  = segue.identifier else {return}
        
        if identifier == "toOverviewPopover" {
            guard let destinationVC = segue.destination as? OverviewPopoverViewController else {return}
            destinationVC.overviewText = movie.overview
        }
        
    }

}


extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
