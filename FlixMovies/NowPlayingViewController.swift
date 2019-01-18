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
        fetchMovies()
    }
    
    @objc func fetchMovies() {
        getMovieData {
            (dataDictionaries) in
            self.movies.removeAll()
            let posterBaseURL = "https://image.tmdb.org/t/p/w780"
            for movieDictionary in dataDictionaries {
                guard let title = movieDictionary["title"] as? String, let overview = movieDictionary["overview"] as? String, let posterURL = movieDictionary["poster_path"] as? String, let ratingScore = movieDictionary["vote_average"] as? Double, let id = (movieDictionary["id"] as? Int) else {continue}
                let idString = String(id)
                let movie = Movie(id: idString, title: title, overview: overview, posterURL: posterBaseURL + posterURL, ratingScore: ratingScore)
                self.movies.append(movie)
            }
            
            let dispatchGroup = DispatchGroup()
            
            for movie in self.movies {
                dispatchGroup.enter()
                _ = movie.posterImage
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                // reload table view
                self.stopSpinner()
                self.nowPlayingTableView.reloadData()
            }
        }
    }
    
    func getMovieData(_ completion: @escaping ([[String: Any]]) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error loading data\n" + error!.localizedDescription)
                return
            }
            
            guard let data = data else {return}
            
            do {
                guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                let results = dataDictionary["results"] as! [[String: Any]]
                completion(results)
                
                
                
            } catch let error {
                AlertControllerHelper.presentAlert(for: self, withTitle: "Error", withMessage: "Error loading data\n" + error.localizedDescription)
                return
            }
            
        }
        
        task.resume()
        
        
    }
    
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
