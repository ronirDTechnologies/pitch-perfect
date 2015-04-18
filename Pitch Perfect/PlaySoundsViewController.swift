//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Roni Rozenblat on 4/3/15.
//  Copyright (c) 2015 DINA TECHNOLOGIES. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var echoAudioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
   
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        echoAudioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl , error: nil)
        
        // Enable rate in order to adjust rate later on.
        audioPlayer.enableRate = true
        echoAudioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Code taken from the UDacity Forums
    @IBAction func playEchoSound(sender: UIButton) {
        
        // Play the recorded audio with echo effect, by creating a copy of the audioPlayer variable and play it twice back to back
        
       resetAudioPlayer()
       resetAudioEngine()
       audioPlayer.play()
        
        let delay:NSTimeInterval = 0.5
        var playtime:NSTimeInterval
        playtime = echoAudioPlayer.deviceCurrentTime + delay
        
        echoAudioPlayer.stop()
        echoAudioPlayer.currentTime = 0
        echoAudioPlayer.volume = 0.8
        echoAudioPlayer.playAtTime(playtime)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        // Make sure all audio is stopped
        resetAudioPlayer()
        resetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    @IBAction func playRabbitSound(sender: UIButton) {
        
        resetAudioPlayer()
        resetAudioEngine()
        
        // Setting the audio player to this rate will make the audio sound fast
        audioPlayer.rate = 2.0
        
        var didPlay = audioPlayer.play()
        
        if didPlay == true
        {
            println("SOUND SUCCESSFULLY PLAYED")
        }
        else
        {
            println("SOUND FAILED TO PLAY")
        }
    }
    @IBAction func playSnailSound(sender: AnyObject) {
        

            resetAudioPlayer()
            resetAudioEngine()
        
            // Setting the audio player to this rate will make the audio sound slow
            audioPlayer.rate = 0.5
        
            var didPlay = audioPlayer.play()
            
            if didPlay == true
            {
                println("SOUND SUCCESSFULLY PLAYED")
            }
            else
            {
                println("SOUND FAILED TO PLAY")
            }
    }

    @IBAction func stopSound(sender: UIButton) {
        resetAudioPlayer()
        resetAudioEngine()  
    }
    
    // Will stop and then reset the audioPlayer to the beginning of the sound
    func resetAudioPlayer()
    {
        audioPlayer.stop()
        echoAudioPlayer.stop()
        audioPlayer.currentTime = 0.0
        echoAudioPlayer.currentTime = 0.0
        
        // Return the rate to 1.0 to ensure the sound sounds normal
        audioPlayer.rate = 1.0
        echoAudioPlayer.rate = 1.0
    }
    
    // Will stop and then reset the audioEngine to eliminate the overlap bug
    func resetAudioEngine()
    {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
