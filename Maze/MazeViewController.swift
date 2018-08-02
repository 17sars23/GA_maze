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
        
        estimate(tmp: check_array, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
        
        var timer: Timer!
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeView),userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------
    // Additional function
    //------------------------
    @objc func changeView() {
        self.performSegue(withIdentifier: "toBack", sender: nil)
    }
    
    func creatView(x: Int, y: Int, width:CGFloat, height:CGFloat, offsetX:CGFloat, offsetY:CGFloat) -> UIView {
        let rect = CGRect(x:0, y:0, width:width, height:height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: CGFloat(offsetX + width * CGFloat(x)), y: CGFloat(offsetY + height * CGFloat(y)))
        view.center = center
        
        return view
    }
    
    func estimate(tmp:[Int], width:CGFloat, height:CGFloat, offsetX:CGFloat, offsetY:CGFloat){
        let draw : Draw = Draw(frame:CGRect(x:0,y:0,width:screenSize.width,height:screenSize.height))
        var x = 0, x_pre = 0, x_now = 0
        var y = 0, y_pre = 0, y_now = 0
        
        for i in tmp{
            x_pre = x
            y_pre = y
            x_pre = Int(offsetX + width * CGFloat(x_pre))
            y_pre = Int(offsetY + height * CGFloat(y_pre))
            //let p1 = CGPoint(x: CGFloat(offsetX + width * CGFloat(x_pre)), y: CGFloat(offsetY + height * CGFloat(y_pre)))

            switch i{
            case 0:
                y -= 1
            case 1:
                x += 1
            case 2:
                y += 1
            case 3:
                x -= 1
            default:
                break
            }
            
            let ans = Wall(x: y, y: x)
            while(ans == 2){
                //width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY
                x_now = Int(offsetX + width * CGFloat(x))
                y_now = Int(offsetY + height * CGFloat(y))
                draw.setRect(x1: x_pre, y1: y_pre, x2: x_now, y2: y_now)
            }
        }
        
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
            //print(goalView.center)
        }
        return w
    }
    
    
    

}
