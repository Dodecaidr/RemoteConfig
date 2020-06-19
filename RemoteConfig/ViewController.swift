//
//  ViewController.swift
//  RemoteConfig
//
//  Created by Илья Лобков on 19/06/2020.
//  Copyright © 2020 Илья Лобков. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var remoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        
        startButton.layer.cornerRadius = 12
        startButton.clipsToBounds = true
        //        startButton.backgroundColor = .red
        
        let ciColor = CIColor(string: "1.0 1.0 1.0 1.0")
        let uiColor = UIColor(ciColor: ciColor)
        startButton.backgroundColor = uiColor
        
        let setings = RemoteConfigSettings()
        setings.minimumFetchInterval = 0
        remoteConfig.configSettings = setings
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error != nil {
                print (error?.localizedDescription as Any)
            } else {
                if status != .error {
                    if let stringURL = self.remoteConfig["background_image_stringURL"].stringValue {
                        DispatchQueue.main.async {
                            self.imageView.load(stringURL: stringURL)
                        }
                    }
                    if let titleButtonColor = self.remoteConfig["background_title_button"].stringValue {
                        let ciColor = CIColor(string: titleButtonColor)
                        let uiColor = UIColor(ciColor: ciColor)
                        DispatchQueue.main.async {
                            self.startButton.setTitleColor(uiColor, for: .normal)
                        }
                    }
                    if let backgroundButtonColor = self.remoteConfig["background_button_color"].stringValue {
                        let ciColor = CIColor(string: backgroundButtonColor)
                        let uiColor = UIColor(ciColor: ciColor)
                        DispatchQueue.main.async {
                            self.startButton.backgroundColor = uiColor}
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func load(stringURL: String) {
        if let url = URL(string: stringURL) {
            if let data = try? Data(contentsOf: url)  {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
}
