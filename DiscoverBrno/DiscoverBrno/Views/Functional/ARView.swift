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
    
    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        
        let scene = SCNScene(named: "RewardsCatalog.scnassets/StartupScene.scn")!
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
        let node = SCNScene(named: "RewardsCatalog.scnassets/BrnoDragon.scn")?.rootNode.childNode(withName: "Content", recursively: false)
        
        if let reward = node{
            reward.position = SCNVector3(0,-0.3,-0.3) // Trochu dolu a od sebe
            reward.scale = SCNVector3(0.001, 0.001, 0.001)
            arView.scene.rootNode.addChildNode(reward)
        }
    }
    
    
    
    class Coordinator: NSObject, ARSCNViewDelegate{
        
    }
}
