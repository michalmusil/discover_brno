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
            return SCNVector3(0.002, 0.002, 0.002)
        case .astronomicalClock:
            return SCNVector3(0.006, 0.006, 0.006)
        case .peterAndPaulCathedral:
            return SCNVector3(0.00005, 0.00005, 0.00005)
        case .mahenTheatre:
            return SCNVector3(0.02, 0.02, 0.02)
        case .plagueColumn:
            return SCNVector3(0.001, 0.001, 0.001)
        case .spielbergCastle:
            return SCNVector3(0.01, 0.01, 0.01)
        }
    }
    
    func getRotation() -> GLKQuaternion{
        switch self{
        case .brnoDragon:
            return GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
        case .astronomicalClock:
            return GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
        case .peterAndPaulCathedral:
            return GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
        case .mahenTheatre:
            return GLKQuaternionMakeWithAngleAndAxis(0, 1, 0, 0)
        case .plagueColumn:
            return GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
        case .spielbergCastle:
            return GLKQuaternionMakeWithAngleAndAxis(-(.pi/2), 1, 0, 0)
        }
    }
}
