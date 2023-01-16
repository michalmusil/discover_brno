//
//  LandmarkReward.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 16.01.2023.
//

import Foundation
import RealmSwift
import ARKit

enum LandmarkReward: String, CaseIterable, PersistableEnum{
    case brnoDragon = "BrnoDragon"
    case astronomicalClock = "AstronomicalClock"
    case peterAndPaulCathedral = "PeterAndPaulCathedral"
    case mahenTheatre = "MahenTheatre"
    case plagueColumn = "PlagueColumn"
    case spielbergCastle = "SpielbergCastle"
    
    
    func getScale() -> SCNVector3{
        switch self{
        case .brnoDragon:
            return SCNVector3(0.001, 0.001, 0.001)
        case .astronomicalClock:
            return SCNVector3(0.008, 0.008, 0.008)
        case .peterAndPaulCathedral:
            return SCNVector3(0.03, 0.03, 0.03)
        case .mahenTheatre:
            return SCNVector3(0.02, 0.02, 0.02)
        case .plagueColumn:
            return SCNVector3(0.001, 0.001, 0.001)
        case .spielbergCastle:
            return SCNVector3(0.01, 0.01, 0.01)
        }
    }
    
    func getTranslation() -> SCNVector3{
        switch self{
        case .brnoDragon:
            return SCNVector3(0,-0.3,-0.3)
        case .astronomicalClock:
            return SCNVector3(0,0,-0.3)
        case .peterAndPaulCathedral:
            return SCNVector3(0,0,-0.3)
        case .mahenTheatre:
            return SCNVector3(0,0,-0.3)
        case .plagueColumn:
            return SCNVector3(0,0,-0.3)
        case .spielbergCastle:
            return SCNVector3(0,0,-0.3)
        }
    }
}
