//
//  MenuViewController.swift
//  PopcornTime-Mac
//
//  Created by Aritro Paul on 06/07/20.
//  Copyright © 2020 Aritro Paul. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var moviesVC = MoviesViewController.instantiate(from: .main)
    var showsVC = ShowsViewController.instantiate(from: .main)
    var watchVC = WatchListViewController.instantiate(from: .main)
    var searchVC = SearchViewController.instantiate(from: .main)
    
    var selectedIndex = 0
    
    var viewControllers = [UIViewController]()
    
    var menu = ["Movies", "Shows", "Watchlist","Search", "Downloads"]
    var menuIcons = ["film", "tv", "bookmark", "magnifyingglass", "icloud.and.arrow.down"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [moviesVC, showsVC, watchVC, searchVC]
        
        if let navVC = self.parent as? UINavigationController {
            if let splitVC = navVC.parent as? UISplitViewController {
                splitVC.primaryBackgroundStyle = .sidebar
                if let detailVC = splitVC.children[1] as? UINavigationController {
                    detailVC.viewControllers = [UIViewController()]
                    detailVC.viewControllers[0].title = ""
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView(tableView, didSelectRowAt: IndexPath(row: selectedIndex, section: 0))
        tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.titleLabel.text = menu[indexPath.row]
        cell.icon.image = UIImage(systemName: menuIcons[indexPath.row])
        cell.selectedView.layer.cornerRadius = 8
        cell.selectedView.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.isSelected = true
        cell.selectedView.backgroundColor = .systemIndigo
        selectedIndex = indexPath.row
        if let navVC = self.parent as? UINavigationController {
            if let splitVC = navVC.parent as? UISplitViewController {
                if let detailVC = splitVC.children[1] as? UINavigationController {
                    if indexPath.row < viewControllers.count {
                        detailVC.viewControllers = [viewControllers[indexPath.row]]
                        detailVC.viewControllers[0].title = cell.titleLabel.text
                    }
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.selectedView.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
