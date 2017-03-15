//
//  Vertex.swift
//  metalTest
//
//  Created by MaMingkun on 2017/3/15.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

import UIKit

struct Vertex {
    
    var x, y, z: Float
    var r, g, b, a: Float
    var s, t: Float
    var nX, nY, nZ: Float
    
    
    
    func floatBuffer() -> [Float] {
        return [x, y, z, r, g, b, a ,s ,t, nX, nY, nZ]
    }
    
}
