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
    
    // Properties
    var diceArray = [SCNNode]()

    // Outlets
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Shows ar trying to detect a plane
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
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
    
    //====================
    // MARK: - Dice render
    //====================

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Check if there was a touch
        if let touch = touches.first {
            
            // Find th etouch location
            let touchLocation = touch.location(in: sceneView)
            
            // Convert the 2D location into a 3D location
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // Check for a hit result
            if let hitResult = results.first {
                
                addDice(atLocation: hitResult)
                
            } // End if let
            
        } // end if let
        
    } // End touchBegan
    
    func addDice(atLocation location : ARHitTestResult) {
        
        // Create a new 3D Object
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        // Create the dice node (recursively allows to include all the child nodes in the tree(file))
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            // Gice the diceNode a position
            diceNode.position = SCNVector3(
                x: location.worldTransform.columns.3.x,
                y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                z: location.worldTransform.columns.3.z)
            
            // Appened th ecreated dice to the array
            diceArray.append(diceNode)
            
            // Add the node to the scene
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            // Roll the dice
            roll(dice: diceNode)
            
        }
        
    }
    
    //==================
    // MARK: - Roll Dice
    //==================
    
    // Roll the dice
    func roll(dice: SCNNode) {
        
        // Get a random numbers
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        // Run the numbers as an animation
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
        
    }
    
    func rollAll() {
        
        if !diceArray.isEmpty {
            
            for dice in diceArray {
                
                roll(dice: dice)
                
            }
            
        }
        
    }
    
    //==================
    // MARK: - IBActions
    //==================
    
    // Reroll butoon pressed
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        
        rollAll()
        
    }
    
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        // If the diceArray is not empty
        if !diceArray.isEmpty {
            
            for dice in diceArray {
                
                // Removes the dice
                dice.removeFromParentNode()
                
            }
            
        }
        
    }
    
    
    
    // Rolls the dice when the phon is shooken
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        rollAll()
        
    }
    
    //=================================
    // MARK: - ARSCNViewDelegateMethods
    //=================================
    
    
    // Detect the horizontal surface
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Check if the anchor is a ARPlaneAnchor
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        // Create the plane
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        
        // Add the node to the scene
        node.addChildNode(planeNode)
        
    }
    
    //================================
    // MARK: - Plane Rendering Methods
    //================================
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
        
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
        
        return planeNode
        
    }
    
} // End class



