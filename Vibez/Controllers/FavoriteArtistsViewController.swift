//
//  FavoriteArtistsViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/10/20.
//

import Foundation
import UIKit

class FavoriteArtistsViewController: UIViewController {
    
    private let favoriteArtistsTableView = UITableView()
    private var artists = [ArtistItem]()
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorite Artists"
        
        fetchTableViewData()
        
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
    
    private func fetchTableViewData(){

        let token = (UserDefaults.standard.string(forKey: "token"))
        print(token!)
        apiClient.call(request: .getUserTopArtists(token: token!, completions: { (result) in
            switch result {
            case .success(let results):
                self.artists = results.items
                DispatchQueue.main.async {
                    self.buildArtistTableView()
                }
            case .failure(let error):
                print(error)
                print("got back completion; error")
            }
        }))
        
    }
    
    private func buildArtistTableView(){
        self.view.addSubview(favoriteArtistsTableView)
        favoriteArtistsTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteArtistsTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        favoriteArtistsTableView.frame = self.view.bounds
        favoriteArtistsTableView.dataSource = self
        favoriteArtistsTableView.delegate = self
        favoriteArtistsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        favoriteArtistsTableView.backgroundColor = .black
    }
    
}

extension FavoriteArtistsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        let artist = artists[indexPath.row]
        cell.setArtist(artist: artist)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        
        let destinationVC = TopArtistSongsViewController()
        destinationVC.artist = artist
        favoriteArtistsTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}

extension FavoriteArtistsViewController: UISearchBarDelegate {
    
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
