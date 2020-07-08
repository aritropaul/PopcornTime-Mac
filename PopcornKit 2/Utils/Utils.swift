//
//  Utils.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 06/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import Foundation

struct Endpoints {
    
    struct Movie {
        static let baseURL = "https://movies-v2.api-fetch.sh/"
        static let movies = baseURL + "movies/"
        static let movie = baseURL + "movie/"
        static let search = "?keywords="
    }
    
    struct Show {
        static let baseURL = "https://tv-v2.api-fetch.sh/"
        static let shows = baseURL + "shows/"
        static let show = baseURL + "show/"
        static let search = "?keywords="
    }
    
}
