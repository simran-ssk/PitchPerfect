//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Simran Khalsa on 7/27/15.
//  Copyright (c) 2015 Simran Khalsa. All rights reserved.
//

import Foundation

class RecordedAudio{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    
}