//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Roni Rozenblat on 3/28/15.
//  Copyright (c) 2015 DINA TECHNOLOGIES. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseResumeRecordButton: UIButton!
    @IBOutlet weak var resumeRecordingLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var pausedFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingLabel.text = "Tap to Record"
        
        // Hide the pauseResumeRecordButton until the user starts to record.
        pauseResumeRecordButton.hidden = true
        resumeRecordingLabel.hidden = true
      
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pauseRecordingAudio(sender: UIButton) {
        
        // Let the user know recodring has been paused and how to resume recording.
        recordingLabel.text = "recording has been paused"
        recordButton.enabled = true
        resumeRecordingLabel.hidden = false
        pauseResumeRecordButton.enabled = false
        
        // Pause Recording
        audioRecorder.pause()
        pausedFlag = true
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordingLabel.text = "recording in progress"
        recordingLabel.hidden = false
        stopButton.hidden = false
        
        // Disable the record button
        recordButton.enabled = false
        
        // Show the pause button to let the user pause the recording
        pauseResumeRecordButton.hidden = false
        pauseResumeRecordButton.enabled = true
        
        resumeRecordingLabel.hidden = true
        
        println("in recordAudio")
        
        // Don't execute if the recording has been previously paused.  We do this to keep adding to the same sound file.
        
        if (pausedFlag == false)
        {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        else
        {
            audioRecorder.record()
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
        if(flag)
        {
        recordedAudio = RecordedAudio(setFilePathUrl: recorder.url, setTitle: recorder.url.lastPathComponent)

        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingLabel.text = "Tap to Record"
        recordingLabel.hidden = false
        recordButton.enabled = true
        resumeRecordingLabel.hidden = true
        pauseResumeRecordButton.hidden = true
    }
}

