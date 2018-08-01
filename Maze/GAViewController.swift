//
//  GAViewController.swift
//  Maze
//
//  Created by kawagishi on 2018/07/26.
//  Copyright © 2018年 juna Kawagishi. All rights reserved.
//

import UIKit

class GAViewController: UIViewController {
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var Label:UILabel!
    @IBOutlet var idenshi:UILabel!
    
    let num:Int = 20
    let ga_num:Int = 10
    var ga_Array = [[Int]]()
    var pawer:[Int] = []
    var count:Int = 1
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // デフォルト値
        userDefaults.register(defaults: ["DataStore": "default"])
        
        //第一遺伝子
        for _ in 0..<ga_num{
            var a:[Int] = []
            for _ in 0..<num {
                let rand = Int(arc4random_uniform(UInt32(4)))
                a.append(rand)
            }
            ga_Array.append(a)
        }
        print(ga_Array)
        Label.text = "第1世代の遺伝子たちができました"
        
        //遺伝子レベルの計算
        for k in 0..<ga_num{
            let p = estimate(tmp: ga_Array[k])
            pawer.append(p)
        }
        idenshi.text = "遺伝子レベル：" + String(pawer.max()!)
        
        //最大エリートを保存
        let i_max = pawer.index(of: pawer.max()!)
        print("check:",pawer,pawer.max()! ,i_max!)
        userDefaults.set(ga_Array[i_max!], forKey: "DataStore")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func make_GA(){
        var Ereat_Array = [[Int]]()
        var NextE = [[Int]]()
        
        //確率の分母
        var total_pawer = 0
        for p in pawer{
            total_pawer += (p+1)
        }
        
        //10個体選択
        for _ in 0..<ga_num{
            let r = Int(arc4random_uniform(UInt32(total_pawer)))
            var sum = 0
            for (index, pa) in pawer.enumerated(){
                sum += (pa+1)
                if sum>r{
                    NextE.append(ga_Array[index])
                    break
                }
            }
        }
        //print("ji:",NextE)
        
        //交叉
        for l in 0..<(ga_num/2){
            let ra = Int(arc4random_uniform(UInt32(100)))
            if ra < 95{
                let r1 = Int(arc4random_uniform(UInt32(20)))
                let r2 = Int(arc4random_uniform(UInt32(20-r1))) + r1
                var Child = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],]
                
                for m in 0..<num{
                    if r1 <= m && m <= r2{
                        Child[0][m] = NextE[2*l][m]
                        Child[1][m] = NextE[2*l+1][m]
                    }else{
                        Child[0][m] = NextE[2*l+1][m]
                        Child[1][m] = NextE[2*l][m]
                    }
                }
                for z in 0..<num{
                    NextE[2*l][z] = Child[0][z]
                    NextE[2*l+1][z] = Child[1][z]
                }
            }else{
                print("交叉なし")
            }
        }
        
        //突然変異
        let totsuzen = Int(arc4random_uniform(UInt32(100)))
        
        if totsuzen < 44 {
            for _ in 0..<3{
                var a:[Int] = []
                for _ in 0..<num {
                    let rand = Int(arc4random_uniform(UInt32(4)))
                    a.append(rand)
                }
                NextE.removeFirst()
                NextE.append(a)
            }
        }
        
        //エリート二体
        for _ in 0..<2 {
            var j = pawer.index(of: pawer.max()!)
            Ereat_Array.append(ga_Array[j!])
            pawer[j!] = -1
            j = pawer.index(of: pawer.max()!)
            //print(i,pawer,j!)
        }
        
        ga_Array.removeAll()
        for n in 0..<2{
            ga_Array.append(Ereat_Array[n])
        }
        for o in 0..<8{
            ga_Array.append(NextE[o])
        }
        
        count += 1
        Label.text = "第" + String(count) + "世代の遺伝子たちができました"
        
        //遺伝子レベルの計算
        pawer.removeAll()
        for k in 0..<ga_num{
            let p = estimate(tmp: ga_Array[k])
            pawer.append(p)
        }
        idenshi.text = "遺伝子レベル：" + String(pawer.max()!)
        
        //最大エリートを保存
        let i_max = pawer.index(of: pawer.max()!)
        print("check:",pawer,pawer.max()! ,i_max!)
        userDefaults.set(ga_Array[i_max!], forKey: "DataStore")
        
       
    }
    
    
    func estimate(tmp:[Int]) -> Int{
        var pw = 0
        var x = 0
        var y = 0
        
        for i in tmp{
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
            if ans == 0{
                break
            }else if ans == 1{
                pw += 1
            }else{
                pw += 50
                break
            }
        }
        return pw
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
        }
        return w
    }
    
    @IBAction func show(){
        //print(ga_Array)
        let i_max = pawer.index(of: pawer.max()!)
        print("save:",ga_Array[i_max!])
    }

}
