//
//  ViewController.swift
//  Audio
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioRecorder: AVAudioRecorder?
    var currentURL: String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record)
        try? session.setActive(true, options: [])
    }
    
    private func newURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documents.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        
        currentURL = url.lastPathComponent
        return url
    }
    
    func startRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { bool in
                if bool { self.startRecording(); return }
            }
        case .granted:
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)!
            audioRecorder = try? AVAudioRecorder(url: newURL(), format: format)
            audioRecorder?.record()
        default:
            break
        }
    }
    
    @IBAction func recordingPressed(_ sender: Any) {
        recordButton.isSelected.toggle()
        if recordButton.isSelected {
            startRecording()
            recordButton.isEnabled = false
            recordButton.backgroundColor = .lightGray
            pauseButton.isHidden = false
            stopButton.isHidden = false
        }
    }
    
    @IBAction func recordingStopped(_ sender: Any) {
        audioRecorder?.stop()
        recordButton.isEnabled = false
        pauseButton.isEnabled = false
        recordButton.backgroundColor = .lightGray
        pauseButton.backgroundColor = .lightGray
    }
    
    @IBAction func recordingPaused(_ sender: Any) {
        if audioRecorder?.isRecording ?? false {
            audioRecorder?.pause()
            pauseButton.isSelected = true
        } else {
            audioRecorder?.record()
            pauseButton.isSelected = false
        }
    }
    
    @IBAction func done(_ sender: Any) {
        guard let url = currentURL, let title = textField.text else { return }
        var urls = UserDefaults.standard.array(forKey: "urls") as? [String] ?? []
        urls.append(url)
        UserDefaults.standard.set(urls, forKey: "urls")
        
        var titles = UserDefaults.standard.array(forKey: "titles") as? [String] ?? []
        titles.append(title)
        UserDefaults.standard.set(titles, forKey: "titles")
        dismiss(animated: true, completion: nil)
    }
    
}

