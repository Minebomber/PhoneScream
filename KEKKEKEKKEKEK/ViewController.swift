//
//  ViewController.swift
//  KEKKEKEKKEKEK
//
//  Created by Code Day on 5/21/17.
//  Copyright © 2017 Code Day. All rights reserved.
//

import UIKit
import CoreMotion
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var faceView: UIImageView!
    
    let threshold = 1.55
    
    var shouldScream = false
    
    var motionManager: CMMotionManager!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let screamPath = Bundle.main.path(forResource: "scream", ofType: "aiff")
        let screamUrl = URL(fileURLWithPath: screamPath!)
        
        do { player = try AVAudioPlayer(contentsOf: screamUrl) } catch {}
        player?.volume = 1.0
        player?.numberOfLoops = -1
        var timeout = 0
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
            
            if (self.shouldScream) {
                if !(self.player?.isPlaying)! {self.player?.play()}
                self.faceView.image = #imageLiteral(resourceName: "screaming")
            } else {
                self.player?.pause()
                self.faceView.image = #imageLiteral(resourceName: "normal")
            }
            
            if ((data!.acceleration.x < -self.threshold) || (data!.acceleration.y < -self.threshold) || (data!.acceleration.z < -self.threshold)) {
                // falling
                
                timeout = 0
                
            } else {
                timeout += 1
            }
            
            self.shouldScream = timeout < 10
            NSLog(String(self.shouldScream))
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

