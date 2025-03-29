import UIKit
import SpriteKit

final class VectorHelper: VectorHelperProtocol {
    private var vectorManager: VectorManagerProtocol = CompositionRoot.shared.resolve(VectorManagerProtocol.self)
    
    private let selectedVectorAlpha = 0.2
    private let defaultVectorAlpha = 1.0
    private var verticalThreshold = 0.0
    private var horizontalThreshold = 0.0
    private var stickThreshold = 0.0
    private var rightAngleThreshold = 0.0
    
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
    
    //TODO: refactor calculations
    func tryHandleVectorMove(location: CGPoint, previousLocation: CGPoint, vectorToStick: VectorToStick? = nil) -> Bool {
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
            if (vectorToMove!.position == .start) {
                start = CGPoint(x: vectorToMove!.vector.endX, y: vectorToMove!.vector.endY)
                
                if (!tryToCreateRightAngle(position: .start)) {
                    if (!tryStickVector()) {
                        
                        if (vectorToMove?.vector.stickedVector?.stickedVectorPosition == .start){
                            vectorToMove?.vector.stickedVector?.vector.stickedVector = nil
                            vectorToMove?.vector.stickedVector = nil
                        }
                        
                        tryToSetVerticalPoint()
                        tryToSetHorizontalPoint()
                    }
                }
                else {
                    setupRightAngle()
                }
            
                vectorStart = end;
                arrowHeadPoint = CGPoint(x: vectorToMove!.vector.endX, y: vectorToMove!.vector.endY)
            } else {
                start = CGPoint(x: vectorToMove!.vector.startX, y: vectorToMove!.vector.startY)
                vectorStart = start;
                
                if (!tryToCreateRightAngle(position: .end)) {
                    if (!tryStickVector()) {
                        if (vectorToMove?.vector.stickedVector?.stickedVectorPosition == .end) {
                            vectorToMove?.vector.stickedVector?.vector.stickedVector = nil
                            vectorToMove?.vector.stickedVector = nil
                        }
                        
                        tryToSetVerticalPoint()
                        tryToSetHorizontalPoint()
                    }
                }
                else {
                    setupRightAngle()
                }
               
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
    
        
        func setupRightAngle() {
            let dx = vectorToMove!.vector.stickedVector!.vector.endX - vectorToMove!.vector.stickedVector!.vector.startX
            let dy = vectorToMove!.vector.stickedVector!.vector.endY - vectorToMove!.vector.stickedVector!.vector.startY
            
            let direction = CGVector(dx: dx, dy: dy)
            
            let perpendicularDirection = CGVector(dx: -direction.dy, dy: direction.dx)
            
            if (vectorToMove!.vector.stickedVector!.stickPosition == .start){
                setupEndPoint(
                    x: vectorToMove!.vector.stickedVector!.vector.startX,
                    y: vectorToMove!.vector.stickedVector!.vector.startY)

            }
            else {
                setupEndPoint(
                    x: vectorToMove!.vector.stickedVector!.vector.endX,
                    y: vectorToMove!.vector.stickedVector!.vector.endY)
            }
            
            func setupEndPoint(x: CGFloat, y: CGFloat) {
                let length = CGFloat(hypotf(
                    Float(location.x - x),
                    Float(location.y - y)))
                
                let normalizedPerpendicular = CGVector(
                    dx: perpendicularDirection.dx * length / sqrt(perpendicularDirection.dx * perpendicularDirection.dx + perpendicularDirection.dy * perpendicularDirection.dy),
                    dy: perpendicularDirection.dy * length / sqrt(perpendicularDirection.dx * perpendicularDirection.dx + perpendicularDirection.dy * perpendicularDirection.dy))
                
                end = CGPoint(
                    x: x - normalizedPerpendicular.dx,
                    y: y - normalizedPerpendicular.dy)
            }
        }
        
        func tryToCreateRightAngle(position: VectorPosition) -> Bool {
            if (vectorToMove!.vector.stickedVector == nil) {
                return false
            }
            
            if (vectorToMove!.vector.stickedVector!.stickedVectorPosition == vectorToMove!.position) {
                return false
            }
            
            let vector1 = CGVector(
                dx: vectorToMove!.vector.stickedVector!.vector.endX - vectorToMove!.vector.stickedVector!.vector.startX,
                dy: vectorToMove!.vector.stickedVector!.vector.endY - vectorToMove!.vector.stickedVector!.vector.startY)
            
            var vector2: CGVector
            if (position == .start){
                vector2 = CGVector(
                    dx: location.x - vectorToMove!.vector.endX,
                    dy: location.y - vectorToMove!.vector.endY)
            } else {
                vector2 = CGVector(
                    dx: location.x - vectorToMove!.vector.startX,
                    dy: location.y - vectorToMove!.vector.startY)
            }
            
            let dotProduct = vector1.dx * vector2.dx + vector1.dy * vector2.dy
            
            let magnitude1 = sqrt(vector1.dx * vector1.dx + vector1.dy * vector1.dy)
            let magnitude2 = sqrt(vector2.dx * vector2.dx + vector2.dy * vector2.dy)
            
            let cosineTheta = dotProduct / (magnitude1 * magnitude2)
            var angle = acos(cosineTheta)
            angle = angle * 180 / .pi
            
            print(angle)
            
            if (angle >= 90 - rightAngleThreshold && angle <= 90 + rightAngleThreshold) {
                return true
            }
            
            return false
        }
            
        func tryToSetVerticalPoint() {
            if (end.x >= start.x - verticalThreshold && end.x <= start.x + verticalThreshold) {
                end = CGPoint(x: start.x, y: end.y)
            }
        }
        
        func tryToSetHorizontalPoint() {
            if (end.y >= start.y - horizontalThreshold && end.y <= start.y + horizontalThreshold) {
                end = CGPoint(x: end.x, y: start.y)
            }
        }
        
        func tryStickVector() -> Bool {
            if (vectorToStick == nil) {
                return false
            }
            
            switch vectorToStick!.stickPosition {
            case .start:
                end = CGPoint(x: vectorToStick!.vector.startX, y: vectorToStick!.vector.startY)
            case .center:
                break
            case .end:
                end = CGPoint(x: vectorToStick!.vector.endX, y: vectorToStick!.vector.endY)
                vectorToMove?.vector.stickedVector = vectorToStick
            case .none:
                break
            }
            
            vectorToMove!.vector.stickedVector = vectorToStick
            vectorToStick!.vector.stickedVector = VectorToStick(
                stickedVectorPosition: vectorToStick!.stickPosition,
                position: vectorToMove!.position,
                vector: vectorToMove!.vector)
            
            return true
        }
    }
    
    //TODO: refactor update vector
    func handleMoveEnded() {
        if (vectorToMove == nil) {
            return
        }
        
        var cachedStickedVectorUuid: UUID?
        vectorManager.updateVector(
            uuid: vectorToMove!.vector.uuid,
            updateAction: { vector in
                vector.startX = self.vectorToMove!.vector.startX
                vector.endX = self.vectorToMove!.vector.endX
                vector.startY = self.vectorToMove!.vector.startY
                vector.endY = self.vectorToMove!.vector.endY
                
                if (self.vectorToMove!.vector.stickedVector != nil) {
                    vector.stickedPosition = self.vectorToMove!.vector.stickedVector!.stickedVectorPosition.rawValue
                    vector.stickedVectorPosition = self.vectorToMove!.vector.stickedVector!.stickPosition.rawValue
                    vector.stickedVectorUuid = self.vectorToMove!.vector.stickedVector!.vector.uuid
                }
                else {
                    cachedStickedVectorUuid = vector.stickedVectorUuid
                    vector.stickedPosition = 0
                    vector.stickedVectorPosition = 0
                    vector.stickedVectorUuid = nil
                }
            })
        
        if (vectorToMove!.vector.stickedVector != nil) {
            vectorManager.updateVector(
                uuid: vectorToMove!.vector.stickedVector!.vector.uuid,
                updateAction: { vector in
                    vector.startX = self.vectorToMove!.vector.stickedVector!.vector.startX
                    vector.endX = self.vectorToMove!.vector.stickedVector!.vector.endX
                    vector.startY = self.vectorToMove!.vector.stickedVector!.vector.startY
                    vector.endY = self.vectorToMove!.vector.stickedVector!.vector.endY
                    
                    vector.stickedPosition = self.vectorToMove!.vector.stickedVector!.stickPosition.rawValue
                    vector.stickedVectorPosition = self.vectorToMove!.vector.stickedVector!.stickedVectorPosition.rawValue
                    vector.stickedVectorUuid = self.vectorToMove!.vector.uuid
                })
        }
        else {
            if (cachedStickedVectorUuid != nil) {
                vectorManager.updateVector(
                    uuid: cachedStickedVectorUuid!,
                    updateAction: { vector in
                        vector.stickedPosition = 0
                        vector.stickedVectorPosition = 0
                        vector.stickedVectorUuid = nil
                    })
            }
        }
        
        vectorToMove?.node.alpha = defaultVectorAlpha;
        vectorToMove = nil
    }
    
    func requestUpdateVectorSettings() {
        verticalThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.verticalThresholdKey) as? CGFloat ?? 0
        horizontalThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.horizontalThresholdKey) as? CGFloat ?? 0
        stickThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.stickThresholdKey) as? CGFloat ?? 0
        rightAngleThreshold = userDefaults.value(
            forKey: Constants.UserDefaultKeys.rightAngleThresholdKey) as? CGFloat ?? 0
    }
    
    func tryToStick(pair: VectorNodePair, location: CGPoint) -> VectorPosition {
        let distanceToStart = hypotf(
            Float(location.x - pair.vector.startX),
            Float(location.y - pair.vector.startY))
        if (CGFloat(abs(distanceToStart)) <= stickThreshold) {
            return .start
        }
        
        let distanceToEnd = hypotf(
            Float(location.x - pair.vector.endX),
            Float(location.y - pair.vector.endY))
        if (CGFloat(abs(distanceToEnd)) <= stickThreshold) {
            return .end
        }
        
        return .none
    }
}
