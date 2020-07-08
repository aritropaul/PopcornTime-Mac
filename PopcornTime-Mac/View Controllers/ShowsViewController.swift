//
//  ShowsViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 06/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit

class ShowsViewController: UICollectionViewController {

    var shows = [Show]()
    var page = 1
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = .systemIndigo
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Shows")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        loadShows(atPage: page)
    }
    
    @objc func refresh() {
        loadShows(atPage: page)
    }
    
    func loadShows(atPage: Int) {
        ShowManager.shared.loadShows(page: atPage) { (result) in
            switch result {
            case .success(let shows):
                self.shows = shows
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
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
        return shows.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let show = shows[indexPath.item]
        if indexPath.item == shows.count - 5 {
            print(page)
            page = page + 1
            loadShows(atPage: page)
        }
        cell.moviePoster.kf.setImage(with: URL(string: show.images?.poster ?? ""))
        cell.moviePoster.layer.cornerRadius = 8
        cell.moviePoster.contentMode = .scaleAspectFit
        cell.titleLabel.text = show.title
        cell.yearLabel.text = (String(describing: show.numSeasons ?? 0)) + (show.numSeasons == 1 ? " Season" : " Seasons")
        return cell
    }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 150, height: 260)
  }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShow = shows[indexPath.item]
        ShowManager.shared.loadShow(withID: selectedShow.id ?? "") { (result) in
            switch result {
            case .success(let show):
                DispatchQueue.main.async {
                    let showVC : ShowDetailViewController = .instantiate(from: .main)
                    showVC.show = show
                    showVC.modalPresentationStyle = .fullScreen
                    self.present(showVC, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
