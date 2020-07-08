//
//  MovieDetailViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 07/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit
import Kingfisher
import XCDYouTubeKit
import AVKit

class MovieDetailViewController: UIViewController {

    var movie = Movie()
    @IBOutlet weak var movieBannerView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var moviePosterView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieBannerView.kf.setImage(with: URL(string: movie.images?.fanart ?? ""))
        moviePosterView.kf.setImage(with: URL(string: movie.images?.banner ?? ""))
        moviePosterView.makeCard()
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        synopsisLabel.text = movie.synopsis
    }
    
    func setupYouTubeURL() {
        if movie.trailer == nil {
            youtubeButton.isHidden = true
        }
        else {
            let playerViewController = AVPlayerViewController()
            let id = movie.trailer?.components(separatedBy: "?v=")[1]
            XCDYouTubeClient.default().getVideoWithIdentifier(id) { (video, error) in
                if let video : XCDYouTubeVideo = video {
                    print(video.streamURL)
                    playerViewController.player = AVPlayer(url: video.streamURL)
                    playerViewController.player?.play()
                    self.present(playerViewController, animated: true)

                }
                else {
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    
    func showQualityOptions(completion: @escaping(String?)->Void) {
        let alert = UIAlertController(title: movie.title, message: "Select a quality", preferredStyle: .alert)
        if let keys = movie.torrents?.en?.keys {
            for key in keys {
                alert.addAction(UIAlertAction(title: key, style: .default, handler: { (action) in
                    completion(key)
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completion(nil)
        }))
        alert.modalPresentationStyle = .pageSheet
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func streamTapped(_ sender: Any) {
        showQualityOptions { (quality) in
            // TODO : Stream with selected quality
        }
    }
    
    @IBAction func downloadTapped(_ sender: Any) {
        showQualityOptions { (quality) in
            // TODO : Download with selected quality
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func watchTrailerTapped(_ sender: Any) {
        setupYouTubeURL()
    }
    

}
