//
//  ViewController.swift
//  ARDice
//
//  Created by Lucas Dahl on 12/5/18.
//  Copyright © 2018 Lucas Dahl. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shows ar trying to detect a plane
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a 3D object (commented out so it can be used later If you want)
//        //let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        // Create a sphere
//        let sphere = SCNSphere(radius: 0.2)
//
//        // Create a material
//        let material = SCNMaterial()
//
//        // Select the color
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//
//        // Set the color to the 3D object
//        sphere.materials = [material]
//
//        // Create the node(node = points in 3D space)
//        let node = SCNNode()
//
//        // Set the position ( - for z is backwards(away from the user) and positive is forwards(towards the user))
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//
//        // Set the node to the 3D object
//        node.geometry = sphere
//
//        // Add the node into the scene
//        sceneView.scene.rootNode.addChildNode(node)
        
        // Add some light
        sceneView.autoenablesDefaultLighting = true
        
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // configure planeDetection (horzontal)
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Check if there was a touch
        if let touch = touches.first {
            
            // Find th etouch location
            let touchLocation = touch.location(in: sceneView)
            
            // Convert the 2D location into a 3D location
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // Check for a hit result
            if let hitResult = results.first {
                
                // Create a new 3D Object
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                // Create the dice node (recursively allows to include all the child nodes in the tree(file))
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    // Gice the diceNode a position
                    diceNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, z: hitResult.worldTransform.columns.3.y)
                    
                    // Add the node to the scene
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                } // End if let
                
            } // End if let
            
        } // end if let
        
    }
    
    // Detect the horizontal surface
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Check if the Anchor is a plane
        if anchor is ARPlaneAnchor {
            
            // Down cast into ARPlaneAnchor
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // Convert the dims of the anchor to a scene plan
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // Create a plane node
            let planeNode = SCNNode()
            
            // Set the nodes position
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            // Transform the planeNode and rotate 90 degrees
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            // Create a material so the user can see the plane and set the plane material
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            // Set the planeNode gemometry
            planeNode.geometry = plane
            
            // Add the node to the scene
            node.addChildNode(planeNode)
            
        } else {
            
            return
            
        }
        
    }
    
} // End class
