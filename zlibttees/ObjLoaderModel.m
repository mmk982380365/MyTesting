//
//  ObjLoaderModel.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ObjLoaderModel.h"

@interface ObjLoaderModel ()
{
    float *vertex;
    float *texture;
    
    
//    int *indices;
    
    int *texIndices;
    
//    Vet *objVertex;
    
}

@property (nonatomic, strong) NSMutableArray *vArray;

@property (nonatomic, strong) NSMutableArray *vtArray;

@property (nonatomic, strong) NSMutableArray *faceArray;

@property (nonatomic, strong) NSString *string;

@end

@implementation ObjLoaderModel

- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        
        self.string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"obj"] encoding:NSUTF8StringEncoding error:nil];
        
        NSAssert(self.string != nil, @"err");
        
        self.vArray = [NSMutableArray arrayWithCapacity:0];
        self.vtArray = [NSMutableArray arrayWithCapacity:0];
        self.faceArray = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *array = [self.string componentsSeparatedByString:@"\n"];
        
        for (NSString *str in array) {
            if ([str rangeOfString:@"v "].location != NSNotFound) {
                [self.vArray addObject:str];
            }else if ([str rangeOfString:@"vt "].location != NSNotFound) {
                [self.vtArray addObject:str];
            }else if ([str rangeOfString:@"f "].location != NSNotFound) {
                [self.faceArray addObject:str];
            }
        }
        
        float vArr[self.vArray.count * 3];
        for (int i = 0; i < self.vArray.count; i++) {
            NSString *sub = [self.vArray[i] substringFromIndex:2];
            
            NSArray *sAr = [sub componentsSeparatedByString:@" "];
            if (sAr.count == 3) {
                vArr[i * 3] = [sAr[0] floatValue];
                vArr[i * 3 + 1] = [sAr[1] floatValue];
                vArr[i * 3 + 2] = [sAr[2] floatValue];
            }
            
        }
        
        vertex = vArr;
        
        float vtArr[self.vtArray.count * 2];
        
        for (int i = 0; i < self.vtArray.count; i++) {
            NSString *sub = [self.vtArray[i] substringFromIndex:3];
            
            NSArray *sAr = [sub componentsSeparatedByString:@" "];
            if (sAr.count == 2) {
                vtArr[i * 2] = [sAr[0] floatValue];
                vtArr[i * 2 + 1] = [sAr[1] floatValue];
            }
            
            
        }
        
        texture = vtArr;
        
//        GLubyte vFaces[self.faceArray.count * 3];
        
        objIndices = malloc(sizeof(GLubyte) * self.faceArray.count * 3);
        
        
        
        int tFaces[self.faceArray.count * 3];
        
        for (int i = 0; i < self.faceArray.count; i++) {
            NSString *sub = [self.faceArray[i] substringFromIndex:2];
            
            NSArray *sAr = [sub componentsSeparatedByString:@" "];
            
            if (sAr.count == 3) {
                
                for (int j = 0; j < sAr.count; j++) {
                    
                    NSString *s = sAr[j];
                    NSArray *sAr2 = [s componentsSeparatedByString:@"/"];
                    if (sAr2.count == 3) {
                        objIndices[i * 3 + j] = (GLubyte)[sAr2[0] intValue];
                        tFaces[i * 3 + j] = [sAr2[1] intValue];
                    }
                    
                }
                
            }
            
        }
        
//        objIndices = vFaces;
        texIndices = tFaces;
        
        long vCount = self.faceArray.count;
        
//        Vet vtx[vCount];
        
        
        objVertex = malloc(sizeof(Vet) * vCount);
        
        for (int i = 0; i < vCount; i++) {
            
            int index = objIndices[i] - 1;
            
            
            objVertex[i].Position[0] = vertex[index * 3];
            objVertex[i].Position[1] = vertex[index * 3 + 1];
            objVertex[i].Position[2] = vertex[index * 3 + 2];
            
            int texIndex = texIndices[i] - 1;
            
            
            objVertex[i].TexCoord[0] = texture[texIndex * 2];
            objVertex[i].TexCoord[1] = texture[texIndex * 2 + 1];
            
        }
        
        
//        objVertex = vtx;
        
    }
    return self;
}

@end
