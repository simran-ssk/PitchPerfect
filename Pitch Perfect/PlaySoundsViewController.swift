//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Simran Khalsa on 7/26/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var engine:AVAudioEngine!
    var audioFile:AVAudioFile!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Play"
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        engine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    @IBAction func playSoundSlow(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    
    @IBAction func playSoundsFast(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        //playAudioWithVariablePitch(-1000)
        reverbEffect(50.0)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        engine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        engine.attachNode(changePitchEffect)
        
        engine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        engine.connect(changePitchEffect, to: engine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func reverbEffect(wetDryMix: Float){
        
        stopAllAudio()
        
        var audioNode = AVAudioPlayerNode()
        engine.attachNode(audioNode)
        
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverb.wetDryMix = wetDryMix
        engine.attachNode(reverb)
        
        engine.connect(audioNode, to: reverb, format: nil)
        engine.connect(reverb, to: engine.outputNode, format: nil)
        
        audioNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        
        audioNode.play()
    }
    
    
    func playAudioWithRate(someRate: Float){
        
        stopAllAudio()
        audioPlayer.rate = someRate
        audioPlayer.play()
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        stopAllAudio()
        
    }
    
    func stopAllAudio(){
        audioPlayer.stop()
        engine.stop()
        engine.reset()
        audioPlayer.currentTime = 0.0
    }
    
    
}
