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
        
        
        // Create a new 3D Object
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        // Create the dice node (recursively allows to include all the child nodes in the tree(file))
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            // Gice the diceNode a position
            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
            
            // Add the node to the scene
            sceneView.scene.rootNode.addChildNode(diceNode)
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
