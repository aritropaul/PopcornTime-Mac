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
import PopcornTorrent

class MovieDetailViewController: UIViewController {

    var movie = Movie()
    @IBOutlet weak var movieBannerView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var button2160p: UIButton!
    @IBOutlet weak var button1080p: UIButton!
    @IBOutlet weak var button720p: UIButton!
    @IBOutlet weak var moviePosterView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieBannerView.kf.setImage(with: URL(string: movie.images?.fanart ?? ""))
        moviePosterView.kf.setImage(with: URL(string: movie.images?.banner ?? ""))
        moviePosterView.makeCard()
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        synopsisLabel.text = movie.synopsis
        setupTorrentButtons()
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
    
    
    func setupTorrentButtons() {
        if let _720p = movie.torrents?.en?["720p"] {
            //
        }
        else {
            button720p.isHidden = true
        }
        if let _1080p = movie.torrents?.en?["1080p"] {
            //
        }
        else {
            button1080p.isHidden = true
        }
        if let _2160p = movie.torrents?.en?["2160p"] {
            //            
        }
        else {
            button2160p.isHidden = true
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func watchTrailerTapped(_ sender: Any) {
        setupYouTubeURL()
    }
    
    @IBAction func _720pTapped(_ sender: Any) {
        if let _720p = movie.torrents?.en?["720p"] {
            let playerViewController = AVPlayerViewController()
            print(_720p.url)
            let streamer = PTTorrentStreamer()
            streamer.startStreaming(
                fromFileOrMagnetLink: _720p.url!,
                progress: { (status) in
                print(status)
            }, readyToPlay: { (file, path) in
                print(file)
            }, failure: { (error) in
                print(error)
            })
            print(streamer)
        }
    }
    
    @IBAction func _1080pTapped(_ sender: Any) {
        if let _1080p = movie.torrents?.en?["1080p"] {
            print(_1080p.url)
        }
    }
    
    @IBAction func _2160pTapped(_ sender: Any) {
        if let _2160p = movie.torrents?.en?["2160p"] {
            print(_2160p.url)
        }
    }
}
