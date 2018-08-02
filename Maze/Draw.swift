//
//  draw.swift
//  Maze
//
//  Created by kawagishi on 2018/08/02.
//  Copyright © 2018年 juna Kawagishi. All rights reserved.
//

import UIKit

class Draw: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var x1 = 0, y1 = 0, x2 = 0, y2 = 0
    
    func setRect(x1:Int, y1:Int, x2:Int, y2:Int){
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.close()
        path.lineWidth = 5.0 // 線の太さ
        UIColor.brown.setStroke() // 色をセット
        path.stroke()
    }
}
    
