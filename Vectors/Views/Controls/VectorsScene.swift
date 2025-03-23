import SpriteKit
import SwiftUI

class VectorsScene : SKScene{
    
    private let defaultLineHeight = 3.0
    
    private var vectorHandler: VectorHandlerProtocol = CompositionRoot.shared.resolve(VectorHandlerProtocol.self)
    
    private var previousCameraPoint = CGPoint.zero
    private var sceneCamera = SKCameraNode()
    private var pairs = [VectorNodePair]()
    
    override func didMove(to view: SKView) {
        
        camera = sceneCamera;
        
        backgroundColor = UIColor.systemBackground;
        
        drawVector(vector: VectorItemViewModel(startX: 0, endX: 200, startY: 0, endY: 0, name: "qwe"))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        guard let touchedNode = touchedNodes.first as? SKShapeNode else {
            return
        }
    
        guard let selectedPair = pairs.first(where: { $0.node == touchedNode} ) else {
            return
        }
        
        _ = vectorHandler.tryHandleVectorTouch(pair: selectedPair, location: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        if (vectorHandler.tryHandleVectorMove(location: location, previousLocation: previousLocation)) {
            return
        }

        camera?.position.x += -(location.x - previousLocation.x)
        camera?.position.y += -(location.y - previousLocation.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        vectorHandler.handleMoveEnded()
    }
    
    func selectVector(id: ObjectIdentifier){
        guard let selectedPair = pairs.first(where: { $0.vector.id == id} ) else {
            return
        }
        
        selectedPair.node.scaleLineHeight(
            duration: 1,
            startLineHeight: defaultLineHeight,
            endLineHeight: 6,
            increaseLineHeightAnimationDuration: 0.5,
            decreaseLineHeightAnimationDuration: 0.5)
    }
    
    func drawVector(vector: VectorItemViewModel){
        
        let shapeNode = SKShapeNode()
        let pathToDraw = CGMutablePath()
        
        let startPoint = CGPoint(x: vector.startX, y: vector.startY)
        let endPoint = CGPoint(x: vector.endX, y: vector.endY)
        pathToDraw.move(to: startPoint)
        pathToDraw.addLine(to: endPoint)
        pathToDraw.moveAndAddArrowHead(
            vectorStart: startPoint,
            end: endPoint,
            arrowLengthMultiplier: 0.12)
        
        shapeNode.path = pathToDraw
        shapeNode.strokeColor = vector.color
        shapeNode.lineWidth = defaultLineHeight
        
        addChild(shapeNode)
        pairs.append(VectorNodePair(vector: vector, node: shapeNode))
    }
}
