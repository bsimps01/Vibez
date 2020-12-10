//
//  TopArtistSongsViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/9/20.
//

import Foundation
import UIKit

class TopArtistSongsViewController: UIViewController {
    
    private let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    private var vibezSoundz = [VibezSoundz]()
    private let artistSongsTableView = UITableView()
    
    var artist: ArtistObject! {
        didSet {
            fetchArtistTopSongs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Top Choices"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
       ]
        let logoffButton = UIBarButtonItem(title: "Log Off", style: .plain, target: self, action: #selector(logoffButtonTapped))
        self.navigationItem.rightBarButtonItem = logoffButton
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    func fetchArtistTopSongs(){
        let token = (UserDefaults.standard.string(forKey: "token"))

        apiClient.call(request: .getFavoriteUserSongs(token: token!, completions: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tracks):
                    
                    for track in tracks.items {
                        let newTrack = VibezSoundz(artist: track.artists.first?.name,
                                                   id: track.id,
                                                   title: track.name,
                                                   previewURL: track.previewUrl,
                                                   images: track.album!.images)
                        self.vibezSoundz.append(newTrack)
                    }
                    
                    DispatchQueue.main.async {
                        self.configureSongsTableView()
                    }
                }
            }))
        }
    private func configureSongsTableView(){
        self.view.addSubview(artistSongsTableView)
        artistSongsTableView.dataSource = self
        artistSongsTableView.delegate = self

    }
}

extension TopArtistSongsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vibezSoundz.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        
        let song = vibezSoundz[indexPath.row]
        cell.setSong(song: song, starButtonHidden: true)
        cell.vibezRecord = song
        
        return cell
    }
    
    
    
    
}
