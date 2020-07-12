//
//  ViewController.swift
//  DangerSample
//
//  Created by Miguel Pimentel on 12/07/20.
//  Copyright © 2020 Peppero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        helloWorld()
    }

    private func helloWorld() {
        if true {
            print("Hello World")
            view.backgroundColor = .gray
        }
    }
}
