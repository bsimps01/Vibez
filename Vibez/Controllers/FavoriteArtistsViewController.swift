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
    private var artists = [ArtistObject]()
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Favorite Artists"
        fetchTableViewData()
        
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
        
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    private func buildArtistTableView(){
        self.view.addSubview(favoriteArtistsTableView)
        favoriteArtistsTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteArtistsTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        favoriteArtistsTableView.frame = self.view.bounds
        favoriteArtistsTableView.dataSource = self
        favoriteArtistsTableView.delegate = self
        favoriteArtistsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func fetchTableViewData(){
        let token = (UserDefaults.standard.string(forKey: "token"))
        
        apiClient.call(request: .getFavoriteUserArtists(token: token!, completions: { (result) in
            switch result {
            case .failure(let error):
                print(error)
                print("got back completion; error")
            case .success(let results):
                self.artists = results.items
                DispatchQueue.main.async {
                    self.buildArtistTableView()
                }
            }
        }))
    }
    
}

extension FavoriteArtistsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        artists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.accessoryType = .disclosureIndicator
        
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
