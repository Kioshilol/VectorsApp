import SpriteKit
import SwiftUI

class VectorsScene : SKScene {
    private let defaultLineHeight = 3.0
    
    private var vectorHelper: VectorHelperProtocol = CompositionRoot.shared.resolve(VectorHelperProtocol.self)
    
    private var previousCameraPoint = CGPoint.zero
    private var sceneCamera = SKCameraNode()
    private var pairs = [VectorNodePair]()
    
    var longPressTimer: Timer? = nil
    var longPressInProgress: Bool = false
    
    override func didMove(to view: SKView) {
        camera = sceneCamera;
        backgroundColor = UIColor.systemBackground;
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
        
        longPressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.longPressInProgress = true
            _ = self.vectorHelper.tryHandleVectorTouch(pair: selectedPair, location: location)
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        
        
        if (longPressInProgress) {
            var vectorToStick: VectorToStick?
            
            //TODO: improve, dont like this
            for pair in pairs {
                if (pair.node == vectorHelper.vectorToMove?.node) {
                    continue
                }
                
                if let stickPosition = vectorHelper.tryToStick(pair: pair, location: location) {
                    vectorToStick = VectorToStick(
                        node: pair.node,
                        position: stickPosition,
                        vector: pair.vector)
                }
            }
            
            if (vectorHelper.tryHandleVectorMove(
                location: location,
                previousLocation: previousLocation,
                vectorToStick: vectorToStick)) {
                return
            }
        }
        
        longPressTimer?.invalidate()

        camera?.position.x += -(location.x - previousLocation.x)
        camera?.position.y += -(location.y - previousLocation.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!longPressInProgress){
            longPressTimer?.invalidate()
            return
        }
       
        vectorHelper.handleMoveEnded()
        longPressInProgress = false
    }
    
    func initializeVectors(vectors: [VectorItemViewModel]) {
        vectors.forEach({ vector in
            drawVector(vector: vector)
        })
    }
    
    func vectorAction(uuid: UUID, action: VectorAction) {
        guard let selectedPair = pairs.first(where: { $0.vector.uuid == uuid} ) else {
            return
        }
        
        if (action == .select) {
            selectedPair.node.scaleLineHeight(
                duration: 1,
                startLineHeight: defaultLineHeight,
                endLineHeight: 6,
                increaseLineHeightAnimationDuration: 0.5,
                decreaseLineHeightAnimationDuration: 0.5)
            return
        }
        
        selectedPair.node.removeFromParent()
        pairs = pairs.filter({ $0.node != selectedPair.node })
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
