//
//  ShowDetailViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 07/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var showBanner: UIImageView!
    @IBOutlet weak var showPoster: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var episodesTableView: UITableView!
    
    var show = ShowDetail()
    var seasons = [Int]()
    var episodes = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let seasonText = show.numSeasons == 1 ? " Season" : " Seasons"
        showBanner.kf.setImage(with: URL(string: show.images?.fanart ?? ""))
        showPoster.kf.setImage(with: URL(string: show.images?.banner ?? ""))
        showPoster.makeCard()
        titleLabel.text = show.title
        subtitleLabel.text = "\(show.year ?? "")  •  \(show.numSeasons ?? 0)" + seasonText
        synopsisLabel.text = show.synopsis
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        
        for episode in show.episodes! {
            if seasons.contains(episode.season ?? 0) {
                continue
            }
            else{
                seasons.append(episode.season ?? 0)
            }
        }
        
        seasons = seasons.sorted()
        self.episodesTableView.sectionHeaderHeight = 50
        
        for season in seasons {
            let episodesThisSeason = getEpisodes(inSeason: season)?.map({ (episode) -> Int in
                return (episode.episode ?? 0)
            })
            episodes.append(episodesThisSeason ?? [Int]())
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ShowDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func getEpisode(seasonNum: Int, episodeNum: Int) -> Episode? {
        return (show.episodes?.first(where: { (episode) -> Bool in
            return episode.season == seasonNum && episode.episode == episodeNum
        }))
    }
    
    func getEpisodes(inSeason seasonNum: Int) -> [Episode]? {
        return show.episodes?.filter({ (episode) -> Bool in
            return episode.season == seasonNum
        })
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return seasons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeTableViewCell
        let currentSeason = seasons[indexPath.section]
        let episodesThisSeason = episodes[indexPath.section]
        let currentEpisode = episodesThisSeason[indexPath.row]
        print(currentSeason, currentEpisode)
        if let episode = getEpisode(seasonNum: currentSeason, episodeNum: currentEpisode) {
            cell.title.text = episode.title
            cell.subtitle.text = "Season \(episode.season ?? 0) Episode \(episode.episode ?? 0)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Season \(seasons[section])"
        
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = headerView.bounds
        headerView.addSubview(blurredEffectView)
        
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}