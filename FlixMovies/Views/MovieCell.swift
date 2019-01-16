//
//  MovieCell.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/16/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.bannerView.backgroundColor
        super.setSelected(selected, animated: animated)

        if selected {
            self.bannerView.backgroundColor = color
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = self.bannerView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            self.bannerView.backgroundColor = color
        }
    }
}
