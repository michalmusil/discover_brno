//
//  ARView.swift
//  DiscoverBrno
//
//  Created by Michal Musil on 15.01.2023.
//

import Foundation
import SwiftUI
import ARKit

struct ARView: UIViewRepresentable{
    
    let arView = ARSCNView()
    
    let discoveredLandmark: DiscoveredLandmark
    
    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        
        let scene = SCNScene()
        let config = ARWorldTrackingConfiguration()
        
        arView.scene = scene
        arView.showsStatistics = true
        arView.session.run(config)
        
        addReward()
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    private func addReward(){
        guard let landmarkReward = discoveredLandmark.landmark?.landmarkReward else {
            return
        }
        if let reward = SCNScene(named: "RewardsCatalog.scnassets/\(landmarkReward.rawValue).scn")?.rootNode.childNode(withName: "Content", recursively: false){
            
            reward.position = landmarkReward.getTranslation()
            reward.scale = landmarkReward.getScale()
            arView.scene.rootNode.addChildNode(reward)
        }
    }
    
    
    
    class Coordinator: NSObject, ARSCNViewDelegate{
        
    }
}
