//
//  MoviesViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 06/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var movies = [Movie]()
    var page = 1
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = .systemIndigo
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Movies")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        
    }
    
    @objc func refresh() {
        page = 1
        loadMovies(atPage: page)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMovies(atPage: page)
    }
    
    
    func loadMovies(atPage: Int) {
        refreshControl.beginRefreshing()
        MovieManager.shared.loadMovies(page: atPage) { (result) in
            switch result {
            case .success(let movies):
                if self.page == 1 {
                 self.movies = movies
                }
                else {
                    self.movies += movies
                }
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                self.refreshControl.endRefreshing()
                print(error)
            }
        }
    }
    

    /*
    // MARK:- Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:- UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.item]
        if indexPath.item == movies.count - 5 {
            print(page)
            page = page + 1
            loadMovies(atPage: page)
        }
        cell.moviePoster.kf.setImage(with: URL(string: movie.images?.poster ?? ""))
        if cell.moviePoster.image == nil {
            cell.moviePoster.image = UIImage(named: "Empty-Movie")
            cell.moviePoster.contentMode = .scaleAspectFill
        }
        cell.moviePoster.layer.cornerRadius = 8
        cell.moviePoster.contentMode = .scaleAspectFit
        cell.titleLabel.text = movie.title
        cell.yearLabel.text = movie.year
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 260)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let movieVC : MovieDetailViewController = .instantiate(from: .main)
        movieVC.movie = movie
        movieVC.modalPresentationStyle = .fullScreen
        self.present(movieVC, animated: true)
    }
    
}
