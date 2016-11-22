//
//  ObjLoaderViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ObjLoaderViewController.h"
#import "OpenGLView.h"
#import "ObjLoaderModel.h"


@interface ObjLoaderViewController () <UITableViewDelegate,UITableViewDataSource>
{
    float *vertex;
    float *texture;
    
    
    int *indices;
    
    int *texIndices;
    
    Vet *objVertex;
    
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *vArray;

@property (nonatomic, strong) NSMutableArray *vtArray;

@property (nonatomic, strong) NSMutableArray *faceArray;

@property (nonatomic, strong) NSString *string;

@end

@implementation ObjLoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.vArray = [NSMutableArray arrayWithCapacity:0];
    self.vtArray = [NSMutableArray arrayWithCapacity:0];
    self.faceArray = [NSMutableArray arrayWithCapacity:0];
    [self.dataArray addObject:self.vArray];
    [self.dataArray addObject:self.vtArray];
    [self.dataArray addObject:self.faceArray];
    
    self.string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"obj"] encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",self.string);
    
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
    
    int vFaces[self.faceArray.count * 3];
    int tFaces[self.faceArray.count * 3];
    
    for (int i = 0; i < self.faceArray.count; i++) {
        NSString *sub = [self.faceArray[i] substringFromIndex:2];
        
        NSArray *sAr = [sub componentsSeparatedByString:@" "];
        
        if (sAr.count == 3) {
            
            for (int j = 0; j < sAr.count; j++) {
                
                NSString *s = sAr[j];
                NSArray *sAr2 = [s componentsSeparatedByString:@"/"];
                if (sAr2.count == 3) {
                    vFaces[i * 3 + j] = [sAr2[0] intValue];
                    tFaces[i * 3 + j] = [sAr2[1] intValue];
                }
                
            }
            
        }
        
    }
    
    indices = vFaces;
    texIndices = tFaces;
    
    long vCount = self.faceArray.count;
    
    Vet vtx[vCount];
    
    for (int i = 0; i < vCount; i++) {
        
        int index = indices[i] - 1;
        
        
        vtx[i].Position[0] = vertex[index * 3];
        vtx[i].Position[1] = vertex[index * 3 + 1];
        vtx[i].Position[2] = vertex[index * 3 + 2];
        
        int texIndex = texIndices[i] - 1;
        
        
        vtx[i].TexCoord[0] = texture[texIndex * 2];
        vtx[i].TexCoord[1] = texture[texIndex * 2 + 1];
        
    }
    
    objVertex = vtx;
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"vArray";
            break;
        case 1:
            title = @"vtArray";
            break;
        case 2:
            title = @"faceArray";
            break;
            
        default:
            break;
    }
    
    return [title stringByAppendingString:[NSString stringWithFormat:@"   %ld",[self.dataArray[section] count]]];
}

#pragma mark - getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
