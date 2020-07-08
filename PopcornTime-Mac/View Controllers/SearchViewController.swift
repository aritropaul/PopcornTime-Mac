//
//  SearchViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 08/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController {
    
    var page = 1
    var movies = [Movie]()
    var shows = [Show]()
    var searchText = ""
    var scope = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 150)
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scope == 0 ? movies.count : shows.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        if scope == 0 {
            loadMovieCell(cell: cell, indexPath: indexPath)
        }
        else {
            loadShowCell(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func loadShowCell(cell: MovieCollectionViewCell, indexPath: IndexPath) {
        let show = shows[indexPath.item]
        if indexPath.item == shows.count - 5 {
            page = page + 1
            search(ofType: .show, keyword: searchText, page: page)
        }
        cell.moviePoster.kf.setImage(with: URL(string: show.images?.poster ?? ""))
        cell.moviePoster.layer.cornerRadius = 8
        cell.moviePoster.contentMode = .scaleAspectFit
        cell.titleLabel.text = show.title
        cell.yearLabel.text = (String(describing: show.numSeasons ?? 0)) + (show.numSeasons == 1 ? " Season" : " Seasons")
    }
    
    func loadMovieCell(cell: MovieCollectionViewCell, indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        if indexPath.item == movies.count - 5 {
            print(page)
            page = page + 1
            search(ofType: .movie, keyword: searchText, page: page)
        }
        cell.moviePoster.kf.setImage(with: URL(string: movie.images?.poster ?? ""))
        cell.moviePoster.layer.cornerRadius = 8
        cell.moviePoster.contentMode = .scaleAspectFit
        cell.titleLabel.text = movie.title
        cell.yearLabel.text = movie.year

    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath) as! SearchHeaderView
    }
    
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.scope = selectedScope
        let scope : Type = searchBar.selectedScopeButtonIndex == 0 ? .movie : .show
        search(ofType: scope, keyword: searchText, page: 1)
        print(selectedScope)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        let scope : Type = searchBar.selectedScopeButtonIndex == 0 ? .movie : .show
        search(ofType: scope, keyword: searchText, page: 1)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.layer.borderColor = UIColor.clear.cgColor
    }
    
    func search(ofType type: Type, keyword: String, page: Int) {
        switch type {
        case .movie :
            MovieManager.shared.searchMovies(page: page, keyword: keyword) { (result) in
                switch result {
                case .success(let movies):
                    if self.page == 1 {
                        self.movies = movies
                    }
                    else {
                        self.movies += movies
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .show:
            ShowManager.shared.searchShow(page: page, keyword: keyword) { (result) in
                switch result {
                case .success(let shows):
                    if self.page == 1 {
                        self.shows = shows
                    }
                    else {
                        self.shows += shows
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
