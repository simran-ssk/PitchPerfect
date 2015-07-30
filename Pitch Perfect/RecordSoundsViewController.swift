//
//  RecrodSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Simran Khalsa on 7/20/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit
import AVFoundation

class RecodSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingText: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingText.text = "press mic to record!"
        stopButton.hidden = true
    }
    
  
    @IBAction func stopRecording(sender: AnyObject) {
        //Stop recording the users voice.
        recordButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func recordAudio(sender: UIButton) {
        //Record the users voice.
        recordButton.enabled = false
        stopButton.hidden = false
        recordingText.text = "recording..."
        println("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
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
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //save recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            //move to the next sceen, perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            recordingDidNotComplete()
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func recordingDidNotComplete(){
        let alert = UIAlertController(title: "Error", message: "Recording did not complete successfully", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

