//
//  FavoritesViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/9/20.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    private let artistTableView = UITableView()
    private var artists = [ArtistObject]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        displayNavigation()
    }
    
    func displayNavigation(){
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
       ]
        self.navigationItem.title = "Favorite Artists"
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    func buildTableView() {
        self.view.addSubview(artistTableView)
        artistTableView.translatesAutoresizingMaskIntoConstraints = true
        artistTableView.dataSource = self
        artistTableView.delegate = self
        artistTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        artistTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        artistTableView.frame = self.view.bounds
        
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.accessoryType = .disclosureIndicator
        
        let artist = artists[indexPath.row]
        cell.setArtist(artist: artist)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        
        let artistTopSongs = TopArtistSongsViewController()
        artistTopSongs.artist = artist
        artistTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(artistTopSongs, animated: true)
    }
    
    
}
