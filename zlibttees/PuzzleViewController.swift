//
//  PuzzleViewController.swift
//  zlibttees
//
//  Created by MaMingkun on 2017/2/4.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit

class PuzzleViewController: BaseViewController {

    let row = 10
    
    let col = 10
    
    var cubes = [[UIButton]]()
    
    var mainView: UIView!
    
    var colors: [[Bool]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        colors = Array(repeating: Array(repeating: false, count: col), count: row)
        
        prepareCubes()
        
        colors[4][3] = true
        colors[4][1] = true
        
        reloadColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareCubes() {
        mainView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.size.height)!, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        view.addSubview(mainView)
        
        let margin: CGFloat = 3.0
        
        let length = (UIScreen.main.bounds.size.width - (margin * CGFloat(col + 1))) / CGFloat(col)
        
        for i in 0..<row {
            
            var rows = [UIButton]()
            
            for j in 0..<col {
                
                let cube = UIButton(type: .custom)
                cube.frame = CGRect(x: (length + margin) * CGFloat(j) + margin, y: (length + margin) * CGFloat(i) + margin, width: length, height: length)
                cube.addTarget(self, action: #selector(btnOnClick(btn:)), for: .touchUpInside)
                cube.layer.borderWidth = 1.0
                mainView.addSubview(cube)
                rows.append(cube)
                
            }
            
            cubes.append(rows)
            
        }
    }
    
    func btnOnClick(btn: UIButton) {
        var br = -1, bc = -1
        
        for r in 0..<row {
            for c in 0..<col {
                let cube = cubes[r][c]
                if cube === btn {
                    br = r
                    bc = c
                }
            }
        }
        
        if br < 0 || bc < 0 {
            return
        }
        
        //        let currentColor = colors[br][bc]
        
        //中
        colors[br][bc] = !colors[br][bc]
        //上
        if br > 0 {
            colors[br - 1][bc] = !colors[br - 1][bc]
        }
        //下
        if br < row - 1 {
            colors[br + 1][bc] = !colors[br + 1][bc]
        }
        //左
        if bc > 0 {
            colors[br][bc - 1] = !colors[br][bc - 1]
        }
        //右
        if bc < col - 1 {
            colors[br][bc + 1] = !colors[br][bc + 1]
        }
        
        
        
        reloadColor()
        
    }
    
    func reloadColor() {
        DispatchQueue.global().async {
            for r in 0..<self.row {
                for c in 0..<self.col {
                    let cube = self.cubes[r][c]
                    let color = self.colors[r][c]
                    
                    DispatchQueue.main.async {
                        switch color {
                        case false:
                            cube.backgroundColor = UIColor.white
                        case true:
                            cube.backgroundColor = UIColor.black
                            //                        default:
                            //                            cube.backgroundColor = UIColor.white
                        }
                    }
                    
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
