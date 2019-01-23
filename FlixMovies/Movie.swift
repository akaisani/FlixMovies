//
//  Movie.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/14/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

class Movie {
    let id: String
    let title: String
    let overview: String
    let posterURL: String
    let backdropURL: String
    private var savedPosterImage: UIImage?
    private var ratingScore: Double
    
    let ratings = ["😭"," ⭐️", "⭐️⭐️", "⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️", "⭐️⭐️⭐️⭐️⭐️"]
    
    
    init(id: String, title: String, overview: String, posterURL: String, backdropURL: String, ratingScore: Double) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURL = posterURL
        self.ratingScore = ratingScore
        self.backdropURL = backdropURL
    }
    
    var posterImage: UIImage? {
        if let downloadedImage = savedPosterImage {
            return downloadedImage
        } else {
            guard let url = URL(string: posterURL) else {return nil}
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            savedPosterImage = image
            return image
        }
    }
    
    var rating: String {
        let ratingIndex = Int(ratingScore/2)
        return ratings[ratingIndex]
    }
    
}
