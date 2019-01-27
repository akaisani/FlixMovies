//
//  ViewController.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/14/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    var movies: [Movie] = []
    var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nowPlayingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startSpinner()
        self.extendedLayoutIncludesOpaqueBars = true
        self.fetchMovies()
    }
    
    // MARK: - Helpers
    func fetchMovies() {
        TMDBHelper.fetchMovies(for: self) { (nowplayingMovies, superheroMovies) in
            self.movies = nowplayingMovies
            guard let tabbar = self.tabBarController, let superheroNavigationController = tabbar.viewControllers?[1] as? UINavigationController, let superheroViewController = superheroNavigationController.topViewController as? SuperheroViewController else {return}
            superheroViewController.movies = superheroMovies
            DispatchQueue.main.async {
                // reload table view
                self.stopSpinner()
                self.nowPlayingTableView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - UIActivityIndicator Setup
    func startSpinner() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopSpinner() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        if identifier == "toDetailView" {
            guard let destinationVC = segue.destination as? DetailViewController, let selectedMovieIndexPath = nowPlayingTableView.indexPathForSelectedRow else {return}
            let movie = self.movies[selectedMovieIndexPath.row]
            destinationVC.movie = movie
        }
    }
}

// MARK: - UITableView Setup
extension NowPlayingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = self.movies[indexPath.row]
        cell.posterImageView.image = movie.posterImage
        cell.movieTitleLabel.text = movie.title
        cell.movieRatingLabel.text = movie.rating
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
}

extension NowPlayingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // selected a movie, move to detail view
        self.performSegue(withIdentifier: "toDetailView", sender: self)
    }
}
