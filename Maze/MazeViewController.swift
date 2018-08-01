//
//  ViewController.swift
//  Maze
//
//  Created by kawagishi on 2018/07/13.
//  Copyright © 2018年 juna Kawagishi. All rights reserved.
//

import UIKit
import CoreMotion

class MazeViewController: UIViewController {
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    //player
    var playerView: UIView!
    var startView: UIView!
    var goalView: UIView!
    
    //Screen size
    let screenSize = UIScreen.main.bounds.size
    
    //Maze map
    let maze = [
        [2,0,0,0,1,0],
        [1,0,1,0,0,0],
        [0,0,1,1,1,0],
        [1,0,1,0,0,1],
        [1,0,0,0,1,0],
        [0,0,1,0,0,0],
        [0,1,1,0,1,0],
        [0,0,0,0,1,3],
        [0,0,1,0,0,0],
        [1,0,1,1,1,1],
        ]
    
    //wall
    var wallRectArray = [CGRect]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //------------------------
        // Setting Maze
        //------------------------
        let cellWidth = screenSize.width / CGFloat(maze[0].count)
        let cellHeight = screenSize.height / CGFloat(maze.count)
        
        let cellOffsetX = screenSize.width / CGFloat(maze[0].count*2)
        let cellOffsetY = screenSize.height / CGFloat(maze.count*2)
        
        for y in 0 ..< maze.count {
            for x in 0 ..< maze[y].count{
                switch maze[y][x] {
                case 1: //wall
                    let wallView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    wallView.backgroundColor = UIColor.black
                    view.addSubview(wallView)
                    wallRectArray.append(wallView.frame)
                case 2: //start
                    startView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    startView.backgroundColor = UIColor.green
                    view.addSubview(startView)
                case 3: //goal
                    goalView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    goalView.backgroundColor = UIColor.red
                    view.addSubview(goalView)
                default:
                    break
                }
            }
        }
        
        //------------------------
        // a
        //------------------------
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth/6, height: cellHeight/6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        self.view.addSubview(playerView)
        
        var check_array = [Int]()
        check_array = userDefaults.object(forKey: "DataStore") as! [Int]
        print(check_array)
        
        estimate(tmp: check_array)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------
    // Additional function
    //------------------------
    func creatView(x: Int, y: Int, width:CGFloat, height:CGFloat, offsetX:CGFloat, offsetY:CGFloat) -> UIView {
        let rect = CGRect(x:0, y:0, width:width, height:height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: CGFloat(offsetX + width * CGFloat(x)), y: CGFloat(offsetY + height * CGFloat(y)))
        view.center = center
        
        return view
    }
    
    func estimate(tmp:[Int]){
        
    }
    
    func Wall(x:Int, y:Int) -> Int{
        var w = 0
        
        if x<0 || y<0 || 9<x || 5<y {
            w = 0
        }else if maze[x][y] == 1 {
            w = 0
        }else if maze[x][y] == 0 || maze[x][y] == 2{
            w = 1
        }else if maze[x][y] == 3 {
            w = 2
            print(goalView.center)
        }
        return w
    }
    
    func draw(_ rect: CGRect, x1:Int, y1:Int, x2:Int, y2:Int) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.lineWidth = 5.0 // 線の太さ
        UIColor.brown.setStroke() // 色をセット
        path.stroke()
    }
    

}
