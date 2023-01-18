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
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
    
    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(parent: self)
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






class ARCoordinator: NSObject, ARSCNViewDelegate{
    
    private let planeNodeIdentifier = "Plane"
    private let rewardNodeIdentifier = "Reward"
    
    private let parent: ARView
    private let reward: LandmarkReward?
    
    
    private var rewardAdded = false
    private var planeDetected = false
    
    init(parent: ARView) {
        self.parent = parent
        self.reward = parent.discoveredLandmark.landmark?.landmarkReward
        super.init()
        setupTapGesture()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let device = parent.arView.device,
            let planeGeometry = ARSCNPlaneGeometry(device: device)
        else {
            fatalError()
        }
        
        // Only allowing horizontal planes
        guard planeAnchor.alignment == .horizontal else {
            return
        }

        let planeNode = getPlaneNode(geometry: planeGeometry)
        node.addChildNode(planeNode)
        planeGeometry.update(from: planeAnchor.geometry)

        planeDetected = true
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNode(withName: "Plane", recursively: false),
            let planeGeometry = planeNode.geometry as? ARSCNPlaneGeometry
        else {
            return
        }

        planeGeometry.update(from: planeAnchor.geometry)
    }
}

// MARK: Gestures
extension ARCoordinator{
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        parent.arView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard !rewardAdded else {
            return
        }
        
        let sceneView = parent.arView
        
        let location = gesture.location(in: sceneView)

        guard
            let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
            let result = sceneView.session.raycast(query).first
        else {
            return
        }

        guard let rewardNode = getRewardNode(startingPosition: result.worldTransform) else {
            return
        }
        
        parent.arView.scene.rootNode.addChildNode(rewardNode)
        
        let animationAction = SCNAction.repeatForever(
            SCNAction.group([
                SCNAction.sequence([
                    SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 5),
                    SCNAction.move(by: SCNVector3(x: 0, y: -0.05, z: 0), duration: 5)
                ]),
                SCNAction.rotateBy(x: 0, y: (.pi*2), z: 0, duration: 10)
            ])
        )
        
        rewardNode.runAction(animationAction)
        
        rewardAdded = true
        stopPlaneDetection()
    }
}

// MARK: Coordinator helper functions
extension ARCoordinator{
    private func getRewardNode(startingPosition: simd_float4x4) -> SCNNode?{
        guard let landmarkReward = self.reward else {
            return nil
        }
        guard let reward = SCNScene(named: "RewardsCatalog.scnassets/\(landmarkReward.rawValue).scn")?.rootNode.childNode(withName: "Content", recursively: false) else {
            return nil
        }
        
        reward.name = rewardNodeIdentifier
        reward.simdWorldTransform = startingPosition
        reward.scale = landmarkReward.getScale()
        reward.simdWorldPosition.y += 0.01
        // Rotating the model
        let result = rotateModel(rewardModel: reward, rotateBy: landmarkReward.getRotation())
        
        return result
    }
    
    private func rotateModel(rewardModel: SCNNode, rotateBy: GLKQuaternion) -> SCNNode{
        let orientation = rewardModel.orientation
        var glQuaternion = GLKQuaternionMake(orientation.x, orientation.y, orientation.z, orientation.w)
        let multiplier = rotateBy
        glQuaternion = GLKQuaternionMultiply(glQuaternion, multiplier)
        
        rewardModel.orientation = SCNQuaternion(x: glQuaternion.x, y: glQuaternion.y, z: glQuaternion.z, w: glQuaternion.w)
        return rewardModel
    }
    
    private func getPlaneNode(geometry: ARSCNPlaneGeometry) -> SCNNode{
        let planeNode = SCNNode(geometry: geometry)
        planeNode.opacity = 0.4
        planeNode.name = planeNodeIdentifier

        let color: UIColor = .red
        planeNode.geometry?.firstMaterial?.diffuse.contents = color
        
        return planeNode
    }
    
    private func stopPlaneDetection() {
        let newConfiguration = ARWorldTrackingConfiguration()

        parent.arView.session.run(newConfiguration)
        
        removePlaneNodes()

        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
    private func removePlaneNodes() {
        parent.arView.scene.rootNode.enumerateChildNodes{ childNode,_  in
            if childNode.name == planeNodeIdentifier{
                childNode.removeFromParentNode()
            }
        }
    }
}
