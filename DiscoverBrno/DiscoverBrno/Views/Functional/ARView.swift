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
        let config = setUpConfiguration()
        
        arView.scene = scene
        arView.debugOptions = [.showFeaturePoints]
        arView.showsStatistics = true
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    
    
    
    
    class Coordinator: NSObject, ARSCNViewDelegate{
        
        private let parent: ARView
        
        private var hasAddedModel = false
        
        init(parent: ARView) {
            self.parent = parent
        }
        
        @MainActor
        private func getRewardNode(startingPosition: SCNVector3) -> SCNNode?{
            guard let landmarkReward = parent.discoveredLandmark.landmark?.landmarkReward else {
                return nil
            }
            guard let reward = SCNScene(named: "RewardsCatalog.scnassets/\(landmarkReward.rawValue).scn")?.rootNode.childNode(withName: "Content", recursively: false) else {
                return nil
            }
            reward.position = startingPosition
            reward.scale = landmarkReward.getScale()
            return reward
        }
        
        
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            // Create a mesh to visualize the estimated shape of the plane.
            guard
                !hasAddedModel,
                let planeAnchor = anchor as? ARPlaneAnchor,
                let device = parent.arView.device,
                let planeGeometry = ARSCNPlaneGeometry(device: device)
            else {
                return
            }
            
            planeGeometry.update(from: planeAnchor.geometry)

            let startingPosition = SCNVector3(planeAnchor.center)
            DispatchQueue.main.sync {
                guard let rewardNode = getRewardNode(startingPosition: startingPosition) else {
                    return
                }
                parent.arView.scene.rootNode.addChildNode(rewardNode)
                
                hasAddedModel = true
            }
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard
                let planeAnchor = anchor as? ARPlaneAnchor,
                let planeNode = node.childNode(withName: "Plane", recursively: false),
                let planeGeometry = planeNode.geometry as? ARSCNPlaneGeometry
            else {
                return
            }

            // Update ARSCNPlaneGeometry to the anchor's new estimated shape.
            planeGeometry.update(from: planeAnchor.geometry)
        }
    }
}


// MARK: Helper functions
extension ARView{
    
    private func setUpConfiguration() -> ARWorldTrackingConfiguration{
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        return config
    }
    
}
