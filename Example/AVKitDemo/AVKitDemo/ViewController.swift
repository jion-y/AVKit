//
//  ViewController.swift
//  AVKitDemo
//
//  Created by liuming on 2021/7/30.
//

import UIKit
import AVKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Thread-safe array
       do {
        let array = ThreadSafeArray<Int>()
           var iterations = 1000
           let start = Date().timeIntervalSince1970
        
           DispatchQueue.concurrentPerform(iterations: iterations) { index in
               let last = array.last ?? 0
               array.append(last + 1)
               
           DispatchQueue.global().sync {
               iterations -= 1
               
                   // Final loop
                   guard iterations <= 0 else { return }
                   let message = String(format: "Safe loop took %.3f seconds, count: %d.",
                       Date().timeIntervalSince1970 - start,
                       array.count)
                   print(message)
           }
           }
       }
    }
}

