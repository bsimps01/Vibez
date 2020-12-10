//
//  TopArtistSongsViewController.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/9/20.
//

import Foundation
import UIKit

class TopArtistSongsViewController: UIViewController {
    
    let apiClient = APIClient(configuration: URLSessionConfiguration.default)
    
    let artistSongsTableView = UITableView()
    
    var artist: ArtistObject! {
        didSet {
            fetchArtistTopSongs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchArtistTopSongs(){
        
    }
}
