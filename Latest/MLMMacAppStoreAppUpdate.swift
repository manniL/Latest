//
//  MLMMacAppStoreAppUpdate.swift
//  Latest
//
//  Created by Max Langer on 07.04.17.
//  Copyright © 2017 Max Langer. All rights reserved.
//

import Cocoa

class MLMMacAppStoreAppUpdate: MLMAppUpdate {

    var appStoreURL : URL?
    
    func parse(data: [String : Any]) {
        let version = Version()
        
        // Get newest version
        if let currentVersion = data["version"] as? String {
            version.newVersion = currentVersion
        }
        
        // Get release notes
        if var releaseNotes = data["releaseNotes"] as? String {
            releaseNotes = releaseNotes.replacingOccurrences(of: "\n", with: "<br>")
            version.releaseNotes = releaseNotes
        }
        
        // Get update date
        if let dateString = data["currentVersionReleaseDate"] as? String,
           let date = DateFormatter().date(from: dateString) {
            version.date = date
        }
        
        // Get App Store Link
        if var appURL = data["trackViewUrl"] as? String {
            appURL = appURL.replacingOccurrences(of: "https", with: "macappstore")
            self.appStoreURL = URL(string: appURL)
        }
        
        self.version = self.shortVersion
        self.currentVersion = version
        
        DispatchQueue.main.async(execute: {
            self.delegate?.checkerDidFinishChecking(self)
        })
    }
}
