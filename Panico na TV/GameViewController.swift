//
//  GameViewController.swift
//  Panico na TV
//
//  Created by Danilo Araújo on 28/05/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: SKScene? = nil
    var leftRoom: Room?
    var rightRoom: Room?
    
    var hallwayScene: GameScene {
        get {
            scene as! GameScene
        }
    }
    
    var roomScene: RoomScene {
        get {
            scene as! RoomScene
        }
    }
    
    var walkAnimation: SKAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToHallway()
        setupWalkAnimation()
        
        let backgroundSound = SKAudioNode(fileNamed: "Background Music.mp3")
        self.scene!.addChild(backgroundSound)
        backgroundSound.run(SKAction.play())
        
        let pianoBackground = SKAudioNode(fileNamed: "Piano Background.mp3")
        self.scene!.addChild(pianoBackground)
        pianoBackground.run(SKAction.play())
    }
    
    func setupWalkAnimation(){
        var textures: [SKTexture] = []
        
        for i in 1...89 {
            let texture = SKTexture(imageNamed: "Hallway\(i).jpg")
            textures.append(texture)
        }
        
        self.walkAnimation = SKAction.animate(with: textures, timePerFrame: 0.01, resize: false, restore: true)
    }
    
    func goToHallway() {
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                sceneNode.name = "HallwayScene"
                self.scene = sceneNode
                
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    setupUpSwipeGestureRecognizer()
                    setupTapGestureRecognizer()
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
    
    func setupUpSwipeGestureRecognizer() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(moveCharacter))
        swipeRecognizer.direction = .up
        self.view?.addGestureRecognizer(swipeRecognizer)
        
        let swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeNavigation(sender:)))
        swipeRecognizerLeft.name = "left"
        swipeRecognizerLeft.direction = .left
        self.view?.addGestureRecognizer(swipeRecognizerLeft)
        
        let swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeNavigation(sender:)))
        swipeRecognizerRight.name = "right"
        swipeRecognizerRight.direction = .right
        self.view?.addGestureRecognizer(swipeRecognizerRight)
    }
    
    func setupTapGestureRecognizer(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectObject))
        self.view?.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func moveCharacter() {
        let rooms = Rooms.shared.getNextRooms()
        
        self.leftRoom = rooms.0
        self.rightRoom = rooms.1
        
        hallwayScene.hallway?.run(self.walkAnimation!)
    }
    
    @objc func swipeNavigation(sender: UIGestureRecognizer){
        
        if self.scene!.name == "HallwayScene" {
            hallwayScene.changeRoom(direction: sender.name!)
        } else {
            if sender.name! == "right" {
                self.roomScene.selectedObject = roomScene.selectedObject.next()
            } else {
                self.roomScene.selectedObject = roomScene.selectedObject.previous()
            }
        }
        
    }
    
    @objc func selectObject(){
        if self.scene!.name == "HallwayScene" {
            if leftRoom != nil && rightRoom != nil {
                
                let roomScene = hallwayScene.selectedRoom == "left" ? self.leftRoom!.roomScene : self.rightRoom!.roomScene
                roomScene.room?.isOpen = true
                
                if let view = self.view as! SKView? {
                    self.scene = roomScene
                    view.presentScene(roomScene)
                    view.ignoresSiblingOrder = true
                }
            }
        } else {
            switch roomScene.selectedObject {
            case .exit:
                goToHallway()
            case .firstObject:
                roomScene.subtitle.text = roomScene.firstObject.text
            case .secondObject:
                roomScene.subtitle.text = roomScene.secondObject?.text
            case .thirdObject:
                roomScene.subtitle.text = roomScene.thirdObject?.text
            }
        }

    }
}
