//
//  HomeViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/8/20.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [VibezSoundz]()
    private var top50TableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Top 50 Songs"
        //fetchTop50()
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
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
        
    }
    
    private func fetchTop50(){
        let top50 = "37i9dQZEVXbMDoHDwVN2tF"
        let token = UserDefaults.standard.string(forKey: "token")
        apiClient.call(request: .getArtistPlaylist(token: token!, playlistId: top50, completions: { (playlist) in
            switch playlist {
            case .failure(let error):
                print(error)
            case .success(let playlist):
                for track in playlist.tracks.items {
                    let newTrack = VibezSoundz(artist: track.track.artists.first?.name,
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
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.vibezRecord = vibezSoundz[indexPath.row]
        cell.setSong(song: vibezSoundz[indexPath.row], starButtonHidden: false)
        return cell
    }
    
    
}
