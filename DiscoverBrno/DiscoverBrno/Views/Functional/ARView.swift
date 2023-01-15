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
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        
        let scene = SCNScene(named: "RewardsCatalog.scnassets/BrnoDragon.scn")
        let config = ARWorldTrackingConfiguration()
        
        if let scn = scene{
            arView.scene = scn
        }
        arView.showsStatistics = true
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate{
        
    }
}
