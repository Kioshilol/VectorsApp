import UIKit

extension CGMutablePath {
    func moveAndAddArrowHead(
        vectorStart: CGPoint,
        end : CGPoint,
        arrowLengthMultiplier: Float){
        
        let pathToDraw = CGMutablePath()
        let distance = hypotf(Float(vectorStart.x - end.x), Float(vectorStart.y - end.y))
        let pointerLineLength = CGFloat(distance * arrowLengthMultiplier)
        let arrowAngle = CGFloat(Double.pi / 6)
        
        let startEndAngle = atan((end.y - vectorStart.y) / (end.x - vectorStart.x)) +
        ((end.x - vectorStart.x) < 0 ? CGFloat(Double.pi) : 0)
        
        let arrowLine1 = CGPoint(
            x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle),
            y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        
        let arrowLine2 = CGPoint(
            x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle),
            y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        
        pathToDraw.move(to: end)
        pathToDraw.addLine(to: arrowLine1)
        pathToDraw.move(to: end)
        pathToDraw.addLine(to: arrowLine2)
        pathToDraw.move(to: end)
        
        self.addPath(pathToDraw)
    }
}
