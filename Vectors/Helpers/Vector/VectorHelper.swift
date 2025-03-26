import UIKit
import SpriteKit

final class VectorHelper: VectorHelperProtocol {
    private var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    
    private let selectedVectorAlpha = 0.2
    private let defaultVectorAlpha = 1.0
    private var minimalVerticalThreshold = 0.0
    private var minimalHorizontalThreshold = 0.0
    
    private let userDefaults: UserDefaults
    
    var vectorToMove: VectorToMove?
    
    init() {
        userDefaults = UserDefaults.standard
        requestUpdateVectorSettings()
    }
    
    func tryHandleVectorTouch(pair: VectorNodePair, location: CGPoint) -> Bool {
        let touchedNode = pair.node
        touchedNode.alpha = selectedVectorAlpha
        
        let selectedVector = pair.vector
        let centerPoint = CGPoint(
            x: (selectedVector.startX + selectedVector.endX) / 2,
            y: (selectedVector.startY + selectedVector.endY) / 2)
        
        let points = [
            VectorPosition.start: hypotf(
                Float(location.x - selectedVector.startX),
                Float(location.y - selectedVector.startY)),
            VectorPosition.center: hypotf(
                Float(location.x - centerPoint.x),
                Float(location.y - centerPoint.y)),
            VectorPosition.end: hypotf(
                Float(location.x - selectedVector.endX),
                Float(location.y - selectedVector.endY))
        ]
        
        let minElement = points.min(by: { $0.value < $1.value} )!
        vectorToMove = VectorToMove(
            node: touchedNode,
            position: minElement.key,
            vector: selectedVector)
        return true
    }
    
    func tryHandleVectorMove(location: CGPoint, previousLocation: CGPoint) -> Bool {
        guard (vectorToMove != nil) else{
            return false
        }
        
        let pathToDraw = CGMutablePath()
        
        let start: CGPoint
        let arrowHeadPoint: CGPoint
        let vectorStart: CGPoint
        var end: CGPoint
        
        if (vectorToMove!.position == .center) {
            let xDiff = location.x - previousLocation.x
            let yDiff = location.y - previousLocation.y
            
            vectorStart = CGPoint(x: vectorToMove!.vector.startX + xDiff, y: vectorToMove!.vector.startY + yDiff)
            start = vectorStart
            arrowHeadPoint = CGPoint(x: vectorToMove!.vector.endX + xDiff, y: vectorToMove!.vector.endY + yDiff)
            end = arrowHeadPoint
        } else {
            end = CGPoint(x: location.x, y: location.y)
            if (vectorToMove!.position == .start){
                start = CGPoint(x: vectorToMove!.vector.endX, y: vectorToMove!.vector.endY)
                tryToSetVerticalPoint()
                tryToSetHorizontalPoint()
                vectorStart = end;
                arrowHeadPoint = CGPoint(x: vectorToMove!.vector.endX, y: vectorToMove!.vector.endY)
            } else {
                start = CGPoint(x: vectorToMove!.vector.startX, y: vectorToMove!.vector.startY)
                vectorStart = start;
                tryToSetVerticalPoint()
                tryToSetHorizontalPoint()
                arrowHeadPoint = end
            }
        }
        
        pathToDraw.move(to: start)
        pathToDraw.addLine(to: end)
        pathToDraw.moveAndAddArrowHead(
            vectorStart: vectorStart,
            end: arrowHeadPoint,
            arrowLengthMultiplier: 0.12)
        
        vectorToMove?.node.path = pathToDraw
        vectorToMove?.vector.changeCoordinates(
            startX: vectorStart.x,
            endX: arrowHeadPoint.x,
            startY: vectorStart.y,
            endY: arrowHeadPoint.y)
        return true
        
        func tryToSetVerticalPoint() {
            if (end.x >= start.x - minimalVerticalThreshold && end.x <= start.x + minimalVerticalThreshold){
                end = CGPoint(x: start.x, y: end.y)
            }
        }
        
        func tryToSetHorizontalPoint() {
            if (end.y >= start.y - minimalHorizontalThreshold && end.y <= start.y + minimalHorizontalThreshold){
                end = CGPoint(x: end.x, y: start.y)
            }
        }
    }
    
    func handleMoveEnded(){
        if (vectorToMove == nil) {
            return
        }
        
        vectorManager.updateVector(
            uuid: vectorToMove!.vector.uuid,
            startX: vectorToMove!.vector.startX,
            endX: vectorToMove!.vector.endX,
            startY: vectorToMove!.vector.startY,
            endY: vectorToMove!.vector.endY)
        
        vectorToMove?.node.alpha = defaultVectorAlpha;
        vectorToMove = nil
    }
    
    func requestUpdateVectorSettings() {
        minimalVerticalThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.minimalVerticalThresholdKey) as? CGFloat ?? 0
        minimalHorizontalThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.minimalHorizontalThresholdKey) as? CGFloat ?? 0
    }
}
