//
//  MovieManager.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 06/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import Foundation
import Just

class MovieManager {
    static let shared = MovieManager()
    
    func loadMovies(page: Int, completion: @escaping(Result<[Movie], Error>)->Void) {
        Just.get(Endpoints.Movie.movies+String(page)) { (r) in
            if r.ok {
                let movies = try? JSONDecoder().decode([Movie].self, from: r.content ?? Data())
                completion(.success(movies ?? [Movie]()))
            }
            else {
                print(r.error)
                completion(.failure(r.error!))
            }
        }
    }
    
    func searchMovies(page: Int, keyword: String, completion: @escaping(Result<[Movie],Error>)->Void) {
        Just.get(Endpoints.Movie.movies+String(page)+Endpoints.Movie.search+keyword) { (r) in
            if r.ok {
                let movies = try? JSONDecoder().decode([Movie].self, from: r.content ?? Data())
                completion(.success(movies ?? [Movie]()))
            }
            else {
                print(r.error)
                completion(.failure(r.error!))
            }
        }
    }
    
}
