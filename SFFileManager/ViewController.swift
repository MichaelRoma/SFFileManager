//
//  ViewController.swift
//  SFFileManager
//
//  Created by Mykhailo Romanovskyi on 22.03.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        
        guard let uPath = path else { return }
        print(uPath)
        myLabel.text = uPath
    }


}

