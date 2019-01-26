//
//  SuperheroViewController.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/23/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //collection view setup
        let layout = moviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let width = (self.view.frame.size.width - layout.sectionInset.bottom * 2) / 2
        layout.itemSize = CGSize(width: width - layout.minimumInteritemSpacing, height: width * 1.25 )
        
        // Do any additional setup after loading the view.
        self.fetchMovies()
    }
    
    
    // MARK: - Helpers
    func fetchMovies() {
        let urlString = "https://api.themoviedb.org/3/movie/324857/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
        TMDBHelper.fetchMovies(for: self, from: urlString) { (movies) in
            self.movies = movies
            DispatchQueue.main.async {
                // reload table view
//                self.stopSpinner()
                self.moviesCollectionView.reloadData()
            }
        }
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        if identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailViewController, let selectedMovieIndexPath = self.moviesCollectionView.indexPathsForSelectedItems?.first else {return}
            let movie = self.movies[selectedMovieIndexPath.row]
            destinationVC.movie = movie
        }
    }
 

}


extension SuperheroViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieGridCell", for: indexPath) as! MovieGridCell
        let movie = self.movies[indexPath.row]
        cell.posterImageView.image = movie.posterImage
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 3.0
        return cell
    }
    
    
}

extension SuperheroViewController: UICollectionViewDelegate {

}

