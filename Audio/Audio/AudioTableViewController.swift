//
//  AudioTableViewController.swift
//  Audio
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import AVFoundation

class AudioTableViewController: UITableViewController {
    
    var titles: [String] { UserDefaults.standard.array(forKey: "titles") as? [String] ?? [] }
    var urls: [String] { UserDefaults.standard.array(forKey: "urls") as? [String] ?? [] }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AudioCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.url = urls[indexPath.row]
        cell.loadAudio()
        return cell
    }
}

class AudioCell: UITableViewCell {
    var url: String?
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    func loadAudio() {
        guard let urlString = url else { return }
        let url = createNewPath(urlString)
        print(url)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
        try? session.setActive(true, options: [])
    }
    
    private func createNewPath(_ path: String) -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destination = URL(fileURLWithPath: String(format: "%@/%@", documentsDirectory,path))
        return destination
    }
    
    @IBAction func playPressed(_ sender: Any) {
        playButton.isSelected.toggle()
        if playButton.isSelected {
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
    }
    
}
