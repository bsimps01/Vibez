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
    
    var artist: ArtistItem! {
        didSet {
            fetchArtistTopSongs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func logoffButtonTapped() {
        self.view.window!.rootViewController = LoginViewController()
    }
    
    func fetchArtistTopSongs(){
        let token = (UserDefaults.standard.string(forKey: "token"))

        apiClient.call(request: .getArtistTopTracks(id: artist.id, token: token!, completions:{ (result) in
                switch result {
                case .success(let tracks):
                    
                    for track in tracks.tracks {
                        let newTrack = VibezSoundz(artistName: track.album.artists.first?.name,
                                                   id: track.id,
                                                   title: track.name,
                                                   previewURL: track.previewUrl,
                                                   images: track.album.images!)
                        self.vibezSoundz.append(newTrack)
                    }
                    
                    DispatchQueue.main.async {
                        self.title = self.artist.name
                        self.configureSongsTableView()
                    }
                case .failure(let error):
                    print(error)
                }
            }))
        }
    
    private func configureSongsTableView(){
        self.view.addSubview(artistSongsTableView)
        artistSongsTableView.translatesAutoresizingMaskIntoConstraints = false
        artistSongsTableView.dataSource = self
        artistSongsTableView.delegate = self
        artistSongsTableView.register(ArtistTableCell.self, forCellReuseIdentifier: "ArtistTableCell")
        artistSongsTableView.frame = self.view.bounds
        artistSongsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        artistSongsTableView.backgroundColor = .black

    }
}

extension TopArtistSongsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vibezSoundz.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableCell") as! ArtistTableCell
        cell.backgroundColor = .clear
        let song = vibezSoundz[indexPath.row]
        cell.vibezRecord = song
        cell.setSong(song: song, starButtonHidden: false)
        
        return cell
    }
    
    
    
    
}
