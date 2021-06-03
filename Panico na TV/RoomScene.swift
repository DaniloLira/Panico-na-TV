//
//  FirstRoomScene.swift
//  Panico na TV
//
//  Created by Danilo Araújo on 31/05/21.
//

import SpriteKit


class RoomScene: SKScene {
    var room: Room? = nil
    var selectedObject: SelectObject = .exit {
        didSet {
            switch selectedObject {
            case .firstObject:
                removeObjectBorders()
                firstObject.drawBorder(color: .red, width: 5)
            case .secondObject:
                removeObjectBorders()
                secondObject.drawBorder(color: .red, width: 5)
            case .thirdObject:
                removeObjectBorders()
                thirdObject.drawBorder(color: .red, width: 5)
            default:
                removeObjectBorders()
                exit.fontColor = .red
            }
        }
    }
    var firstObject: SceneObject
    var secondObject: SceneObject
    var thirdObject: SceneObject
    var exit: SKLabelNode = SKLabelNode(text: "Sair do quarto")
    
    var background: SKSpriteNode
    var subtitle: SKLabelNode = SKLabelNode(text: "Olá, estou testando")
    
    public init(firstObject: SceneObject, secondObject: SceneObject, thirdObject: SceneObject, backgroundName: String) {
        let frame = CGRect(x:0, y:0, width: 1024, height: 576)
        
        self.firstObject = firstObject
        self.secondObject = secondObject
        self.thirdObject = thirdObject
        self.background = SKSpriteNode(imageNamed: backgroundName)
        
        super.init(size: frame.size)
        self.scaleMode = .aspectFill
        self.setupStyle()
        self.setupChildNodes()
    }
    
    override func sceneDidLoad() {
        if let hasAnimation = firstObject.animation {
            secondObject.isHidden = true
            thirdObject.isHidden = true
            firstObject.run(hasAnimation)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupChildNodes() {
        self.addChild(background)
        self.addChild(firstObject)
        self.addChild(secondObject)
        self.addChild(thirdObject)
        self.addChild(subtitle)
        self.addChild(exit)
    }
    
    func setupStyle(){
        background.scale(to: CGSize(width: 1024, height: 576))
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        
        self.subtitle.position = CGPoint(x: frame.midX, y: 100)
        self.subtitle.text = self.firstObject.text //CÓDIGO TEMPORARIO
        self.subtitle.fontSize = 30
        self.subtitle.fontColor = .white
        self.subtitle.zPosition = 3
        
        self.exit.position = CGPoint(x: 100, y: 500)
        self.exit.fontSize = 30
        self.exit.fontColor = .white
        self.exit.zPosition = 4
    }
    
    func removeObjectBorders() {
        self.firstObject.removeAllChildren()
        self.secondObject.removeAllChildren()
        self.thirdObject.removeAllChildren()
        self.exit.fontColor = .white
    }
}


class SceneObject: SKSpriteNode {
    var text: String
    var animation: SKAction? = nil
    init(text: String, imageName: String, pos: CGPoint, size: CGSize, animation: SKAction? = nil) {
        let texture = SKTexture(imageNamed: imageName)
        self.text = text
        self.animation = animation
        super.init(texture: texture, color: .black, size: size)
        self.position = pos
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SceneObject {
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rectOf: size)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = width
        shapeNode.zPosition = 101
        shapeNode.name = "Border"
        self.zPosition = 100
        addChild(shapeNode)
    }
}


enum SelectObject: CaseIterable{
    case exit, firstObject, secondObject, thirdObject
}

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next >= all.endIndex ? idx : next]
    }
    
    func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.startIndex : previous]
    }
    
}
