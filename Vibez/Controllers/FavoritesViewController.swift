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
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [VibezSoundz]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        displayNavigation()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteSongs()
    }
    
    func displayNavigation(){
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Top Selections"
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    private func buildTableView() {
        self.view.addSubview(artistTableView)
        artistTableView.translatesAutoresizingMaskIntoConstraints = true
        artistTableView.dataSource = self
        artistTableView.delegate = self
        artistTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        artistTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        artistTableView.frame = self.view.bounds
        
    }
    
    private func fetchFavoriteSongs(){
        let token = UserDefaults.standard.string(forKey: "token")
        var tracks: [String]?
        tracks = UserDefaults.standard.stringArray(forKey: "favoriteSongs")
         
        if tracks != nil && !tracks!.isEmpty {
            apiClient.call(request: .getFavoriteUserSongs(ids: tracks!, token: token!, completions: { (playlist) in
                    switch playlist {
                    case .failure(let error):
                        print(error)
                    case .success(let playlist):
                        self.vibezSoundz = [VibezSoundz]()
                        
                        for track in playlist.tracks {
                            let newTrack = VibezSoundz(artist: track.album.artists.first?.name,
                                                       id: track.id,
                                                       title: track.name,
                                                       previewURL: track.previewUrl,
                                                       images: track.album.images!)
                            self.vibezSoundz.append(newTrack)
                        }
                        
                        DispatchQueue.main.async {
                            self.buildTableView()
                            self.artistTableView.reloadData()
                        }
                    }
                }))
        } else {
            artistTableView.removeFromSuperview()
        }
    }
}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vibezSoundz.count
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

    }
    
    
}
