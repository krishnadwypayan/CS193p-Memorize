//
//  Pie.swift
//  MemorizeApp
//
//  Created by krkota on 13/07/21.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height)/2
        let startPoint = CGPoint(
            x: center.x + (radius * cos(CGFloat(startAngle.radians))),
            y: center.y + (radius * sin(CGFloat(startAngle.radians)))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        path.addLine(to: center)
        return path
    }
}
