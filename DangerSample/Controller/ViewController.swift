//
//  ViewController.swift
//  DangerSample
//
//  Created by Miguel Pimentel on 12/07/20.
//  Copyright © 2020 Peppero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var sampleLabel: UILabel!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        helloWorld()
    }

    // MARK: - Private Methods

    private func helloWorld() {
        if true{
            sampleLabel.text = "Hello World!"
        }
    }
}


