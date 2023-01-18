//
//  DiscoverableLandmark.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 10.01.2023.
//

import Foundation
import RealmSwift

class DiscoverableLandmark: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var hint: String = ""
    @Persisted var imageAssetName: String = ""
    @Persisted var landmarkDescription: String = ""
    
    @Persisted var landmarkReward: LandmarkReward
    
    @Persisted var longitude: Double
    @Persisted var latitude: Double
    
    convenience init(name: String, hint: String, imageAssetName: String, landmarkDescription: String, landmarkReward: LandmarkReward, longitude: Double, latitude: Double) {
        self.init()
        self.name = name
        self.hint = hint
        self.imageAssetName = imageAssetName
        self.landmarkDescription = landmarkDescription
        self.landmarkReward = landmarkReward
        self.longitude = longitude
        self.latitude = latitude
    }
    
    static var sampleDiscoverable = DiscoverableLandmark(name: "Brno theatre", hint: "Just go with the wind and you will find youself on top of the very thing you are looking for", imageAssetName: "astronomicalClock", landmarkDescription: "bla bla bla bla bla qaqlikuj halikjrg hapior fghaiowr fghoaq hiuhaqweori fuhasoifl ehasdloif jhasdl fkjbnelwrkjgbnalskdj fnhalksjdfh nalkjsdhfnb laksjd gbhnflakjsrh gliasjd hfnlaksjdhg nflaikfsdgbhnliasurehf ljik", landmarkReward: .mahenTheatre, longitude: 49.3, latitude: 16.2)
    
}
