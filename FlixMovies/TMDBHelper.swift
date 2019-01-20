//
//  IDMBHelper.swift
//  FlixMovies
//
//  Created by Abid Amirali on 1/19/19.
//  Copyright © 2019 Abid Amirali. All rights reserved.
//

import UIKit

struct TMDBHelper {
    
    static func getMovieData(_ completion: @escaping ([[String: Any]]?, String?) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") else {return}
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
    
    
}
