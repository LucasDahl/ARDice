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
        
        // Create a 3D object
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        // Create a material
        let material = SCNMaterial()
        
        // Select the color
        material.diffuse.contents = UIColor.red
        
        // Set the color to the 3D object
        cube.materials = [material]
        
        // Create the node(node = points in 3D space)
        let node = SCNNode()
        
        // Set the position ( - for z is backwards(away from the user) and positive is forwards(towards the user))
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        // Set the node to the 3D object
        node.geometry = cube
        
        // Add the node into the scene
        sceneView.scene.rootNode.addChildNode(node)
        
        // Add some light
        sceneView.autoenablesDefaultLighting = true
        
        
        
           // This is Apple's default code
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
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
