//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Roni Rozenblat on 4/8/15.
//  Copyright (c) 2015 DINA TECHNOLOGIES. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    // Initialize class properties
    init(setFilePathUrl extFilePathUrl: NSURL!, setTitle extTitle: String! ) {
        filePathUrl = extFilePathUrl
        title = extTitle
    }
}