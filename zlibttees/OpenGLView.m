//
//  OpenGLView.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/9.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "OpenGLView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "CC3GLMatrix.h"

#define TEX_COORD_MAX 4

const Vertex Vertices[] = {
    // Front
    {{1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, -1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, -1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Left
    {{-1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Right
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Top
    {{1, 1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, -1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

const Vertex Vertices2[] = {
    {{0.5, -0.5, 0.01}, {1, 1, 1, 1}, {1, 1}},
    {{0.5, 0.5, 0.01}, {1, 1, 1, 1}, {1, 0}},
    {{-0.5, 0.5, 0.01}, {1, 1, 1, 1}, {0, 0}},
    {{-0.5, -0.5, 0.01}, {1, 1, 1, 1}, {0, 1}},
};

const GLubyte Indices2[] = {
    1, 0, 2, 3
};

@interface OpenGLView ()

{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuff;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    float _currentRotation;
    GLuint _floor_Texture;
    GLuint _fishTexture;
    GLuint _texCoordSlot;
    GLuint _textureUniform;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    GLuint _vertexBuffer2;
    GLuint _indexBuffer2;
}

@end

@implementation OpenGLView

- (void)dealloc
{
    [EAGLContext setCurrentContext:nil];
    _context = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self setupLayer];
    [self setupContext];
    [self setupDepthBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self compileShaders];
    [self setupVBOs];
    [self setupDisplayLink];
    _floor_Texture = [self setupTexture:@"tile_floor"];
    _fishTexture = [self setupTexture:@"item_powerup_fish"];
}

-(void)setupLayer{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

-(void)setupContext{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"Fail to initialize OpenGL ES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Fail to set current Opengl ES context");
        exit(1);
    }
    
}

-(void)setupRenderBuffer{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

-(void)setupFrameBuffer{
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuff);
}

-(void)setupDepthBuffer{
    glGenRenderbuffers(1, &_depthRenderBuff);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuff);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
}

-(void)compileShaders{
    GLuint vertexShader = [self compileShader:@"SimpleVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandler = glCreateProgram();
    glAttachShader(programHandler, vertexShader);
    glAttachShader(programHandler, fragmentShader);
    glLinkProgram(programHandler);
    
    GLint linkSuccess;
    glGetProgramiv(programHandler, GL_LINK_STATUS, &linkSuccess);
    
    if (linkSuccess == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(programHandler, sizeof(message), 0, &message[0]);
        
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSException *exception = [NSException exceptionWithName:messageString reason:messageString userInfo:nil];
        [exception raise];
    }
    
    glUseProgram(programHandler);
    
    _positionSlot = glGetAttribLocation(programHandler, "Position");
    _colorSlot = glGetAttribLocation(programHandler, "SourceColor");
    
    _projectionUniform = glGetUniformLocation(programHandler, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandler, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(programHandler, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandler, "Texture");
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
}

-(void)setupVBOs{
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vertexBuffer2);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
    
    //    GLuint vertexBuffer;
    //    glGenBuffers(1, &vertexBuffer);
    //    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    //    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    //
    //    GLuint indexBuffer;
    //    glGenBuffers(1, &indexBuffer);
    //    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    //    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

-(GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    __autoreleasing NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!shaderString) {
        NSLog(@"Error loading shader: %@",error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    
    GLint shaderStringLength = (GLint)[shaderString length];
    
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, &message[0]);
        
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSException *exception = [NSException exceptionWithName:messageString reason:messageString userInfo:nil];
        [exception raise];
        
    }
    
    return shaderHandle;
}

-(void)render:(CADisplayLink *)displayLink{
    
    _currentRotation += displayLink.duration * 90;
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glClearColor(0, 104/255.0, 55/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_DEPTH_TEST);
    
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2.0 andTop:h/2.0 andNear:4 andFar:10];
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(sin(CACurrentMediaTime()), 0, -7)];
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *) (sizeof(float) * 7));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _floor_Texture);
    glUniform1i(_textureUniform, 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer2);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _fishTexture);
    glUniform1i(_textureUniform, 0);
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float) * 7));
    
    glDrawElements(GL_TRIANGLE_STRIP, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
    
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
}

-(void)setupDisplayLink{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(GLuint)setupTexture:(NSString *)fileName{
    
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    NSAssert(spriteImage != nil, @"图片不能为空");
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D,0 ,GL_RGBA ,(GLsizei)width ,(GLsizei)height ,0 ,GL_RGBA , GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
    return texName;
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
