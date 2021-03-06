//
//  HomeViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/8/20.
//

import Foundation
import UIKit
import AuthenticationServices

class HomeViewController: UIViewController {
    
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [VibezSoundz]()
    private var top50TableView = UITableView()
    let logoImageView = UIImageView()
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Top 50 Songs"
        //fetchTop50()

        let logoffButton = UIBarButtonItem(title: "Log off", style: .plain, target: self, action: #selector(logOffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        configureSearchBar()
    }
    
    @objc func logOffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTop50()
    }
    
    private func configureTop50TableView(){
        self.view.addSubview(top50TableView)
        top50TableView.translatesAutoresizingMaskIntoConstraints = false
        top50TableView.dataSource = self
        top50TableView.delegate = self
        top50TableView.frame = self.view.bounds
        top50TableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        top50TableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        top50TableView.backgroundColor = .black
        
    }
    
    func logoPlacement(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "VibezLogo")
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    }
    
    private func fetchTop50(){
        let top50 = "37i9dQZEVXbMDoHDwVN2tF"
        let token = UserDefaults.standard.string(forKey: "token")
    
        apiClient.call(request: .getPlaylist(token: token!, playlistId: top50, completions: { (playlist) in
            switch playlist {
            case .failure(let error):
                print(error)
            case .success(let playlist):
                for track in playlist.tracks.items {
                    let newTrack = VibezSoundz(artistName: track.track.artists.first?.name,
                                               id: track.track.id,
                                               title: track.track.name,
                                               previewURL: track.track.previewUrl,
                                               images: track.track.album!.images)
                    self.vibezSoundz.append(newTrack)
                }
                
                DispatchQueue.main.async {
                    self.configureTop50TableView()
                }
            }
        }))
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vibezSoundz.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.backgroundColor = UIColor.clear
        cell.vibezRecord = vibezSoundz[indexPath.row]
        cell.setSong(song: vibezSoundz[indexPath.row], starButtonHidden: false)
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    
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
