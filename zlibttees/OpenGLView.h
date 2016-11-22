//
//  OpenGLView.h
//  zlibttees
//
//  Created by MaMingkun on 16/11/9.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

@interface OpenGLView : UIView

@end
