//
//  IDMBHelper.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/19/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

struct TMDBHelper {
    
    private static func getMovieData(from urlString: String, _ completion: @escaping ([[String: Any]]?, String?) -> Void) {
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, "Error loading data\n" + error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "Error loading data")
                return
            }
            
            do {
                guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                let results = dataDictionary["results"] as! [[String: Any]]
                completion(results, nil)
                
            } catch let error {
                completion(nil, "Error loading data\n" + error.localizedDescription)
                return
            }
            
        }
        
        task.resume()
    }
    
    static func getMovieHomepage(for movieID: String, completion: @escaping (URL?, String?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US") else {return}
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, "Error loading data\n" + error!.localizedDescription)
                return
            } else if let data = data {
                do {
                    guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                    guard let homepageString = dataDictionary["homepage"] as? String, let homepageURL = URL(string: homepageString) else {
                        completion(nil, "No homepage is available for this movie.")
                        return
                    }
                    
                    completion(homepageURL, nil)
                    
                } catch let error {
                    completion(nil, "Error loading data\n" + error.localizedDescription)
                    return
                }
            }
        }
        task.resume()
    }
    
    static func getSuperheroMovies(_ completion: @escaping ([[String: Any]]?, String?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/324857/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1") else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, "Error loading data\n" + error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "Error loading data")
                return
            }
            
            do {
                guard let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {return}
                let results = dataDictionary["results"] as! [[String: Any]]
                completion(results, nil)
                
            } catch let error {
                completion(nil, "Error loading data\n" + error.localizedDescription)
                return
            }
            
        }
        
        task.resume()
    }
    
    
    private static func reteriveMovieData(for viewController: UIViewController, dataDictionaries: [[String: Any]]?, error errorMessage: String?) -> [Movie] {
        var movies = [Movie]()
        guard let dataDictionaries = dataDictionaries else {
            //                self.stopSpinner()
            AlertControllerHelper.presentAlert(for: viewController, withTitle: "Error", withMessage: errorMessage!)
            return movies
        }
        let posterBaseURL = "https://image.tmdb.org/t/p/w780"
        for movieDictionary in dataDictionaries {
            guard let title = movieDictionary["title"] as? String, let overview = movieDictionary["overview"] as? String, let posterURL = movieDictionary["poster_path"] as? String, let backdropURL = movieDictionary["backdrop_path"] as? String, let ratingScore = movieDictionary["vote_average"] as? Double, let id = (movieDictionary["id"] as? Int) else {continue}
            let idString = String(id)
            let movie = Movie(id: idString, title: title, overview: overview, posterURL: posterBaseURL + posterURL, backdropURL: posterBaseURL + backdropURL, ratingScore: ratingScore)
            movies.append(movie)
        }
        return movies
    }
    
    static func fetchMovies(for viewController: UIViewController, _ completion: @escaping ([Movie], [Movie]) -> Void) {
        let nowplayingURLString = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let superheroURLString = "https://api.themoviedb.org/3/movie/324857/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"
        var nowplayingMovies: [Movie] = []
        var superheroMovies: [Movie] = []
        self.getMovieData(from: nowplayingURLString) {
            (nowplayingDataDictionaries, nowplayingErrorMessage) in
            nowplayingMovies = self.reteriveMovieData(for: viewController, dataDictionaries: nowplayingDataDictionaries, error: nowplayingErrorMessage)
            // fetching superhero movies
            
            self.getMovieData(from: superheroURLString, { (superheroDataDictionaries, superheroErrorMessage) in
                superheroMovies = self.reteriveMovieData(for: viewController, dataDictionaries: superheroDataDictionaries, error: superheroErrorMessage)

                let nowplayingDispatchGroup = DispatchGroup()
                
                for movie in nowplayingMovies {
                    nowplayingDispatchGroup.enter()
                    _ = movie.posterImage
                    nowplayingDispatchGroup.leave()
                }
                nowplayingDispatchGroup.notify(queue: .main) {
                    let superheroDispatchGroup = DispatchGroup()
                    
                    for movie in superheroMovies {
                        superheroDispatchGroup.enter()
                        _ = movie.posterImage
                        superheroDispatchGroup.leave()
                    }
                    superheroDispatchGroup.notify(queue: .main) {
                        completion(nowplayingMovies, superheroMovies)
                    }
                }
                
            })
            
            
        }
        
    }
    
}
