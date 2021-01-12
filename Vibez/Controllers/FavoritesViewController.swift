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
    private var artists = [ArtistItem]()
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [VibezSoundz]()
    private let searchController = UISearchController()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        displayNavigation()
        configureSearchBar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteSongs()
    }
    
    func displayNavigation(){
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Top Selections"
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    private func buildTableView() {
        self.view.addSubview(artistTableView)
        artistTableView.translatesAutoresizingMaskIntoConstraints = true
        artistTableView.frame = self.view.bounds
        artistTableView.dataSource = self
        artistTableView.delegate = self
        artistTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        artistTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        artistTableView.backgroundColor = .black
        
    }
    
    private func fetchFavoriteSongs(){
        let token = UserDefaults.standard.string(forKey: "token")
        var tracks: [String]?
        tracks = UserDefaults.standard.stringArray(forKey: "favoriteSongs")
        
        if tracks != nil && !tracks!.isEmpty {
            apiClient.call(request: .getUserFavoriteTracks(ids: tracks!, token: token!, completion: { (playlist) in
                    switch playlist {
                    case .failure(let error):
                        print(error)
                    case .success(let playlist):
                        self.vibezSoundz = [VibezSoundz]()
                        
                        for track in playlist.tracks {
                            let newTrack = VibezSoundz(artistName: track.album.artists.first?.name,
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
        vibezSoundz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.backgroundColor = .clear
        cell.vibezRecord = vibezSoundz[indexPath.row]
        cell.setSong(song: vibezSoundz[indexPath.row], starButtonHidden: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension FavoritesViewController: UISearchBarDelegate {
    
    private func configureSearchBar(){
        
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Artists", "Songs"]
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.resignFirstResponder()
        let searchViewController = SearchViewController()
        searchViewController.searchDescription = searchBar.text
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 0:
            searchViewController.searchCaseType = .artist
        case 1:
            searchViewController.searchCaseType = .track
        default:
            searchViewController.searchCaseType = .artist
        }
        searchViewController.title = searchBar.text?.capitalized
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
