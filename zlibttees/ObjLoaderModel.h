//
//  ObjLoaderModel.h
//  zlibttees
//
//  Created by MaMingkun on 16/11/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    float Position[3];
    float TexCoord[2];
} Vet;

@interface ObjLoaderModel : NSObject
{
    @public
    Vet *objVertex;
    GLubyte *objIndices;
}
//@property (nonatomic, assign) Vet *objVertex;

//@property (nonatomic, assign) GLubyte *objIndices;

-(instancetype)initWithFileName:(NSString *)fileName;

@end
