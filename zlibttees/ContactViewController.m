//
//  ContactViewController.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactCell.h"
#import <Contacts/Contacts.h>
#import "MKActionSheet.h"

@interface ContactViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CNContactStore *contactStore;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contactStore = [[CNContactStore alloc] init];
    
    [self.view addSubview:self.tableView];
    [self setupConstraint];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupConstraint{
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_tableView)];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
}

-(void)loadData{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized) {
        [self loadContacts];
    }else if (status == CNAuthorizationStatusRestricted || status == CNAuthorizationStatusNotDetermined){
        __weak typeof(self) ws = self;
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                __strong typeof(ws) self = ws;
                [self loadContacts];
            }
        }];
    }
}

-(void)loadContacts{
    NSLog(@"loadData");
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[
                                                                                          [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                                                                                          [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStylePhoneticFullName],
                                                                                          CNContactImageDataKey,
                                                                                          CNContactPhoneNumbersKey,
                                                                                          CNContactEmailAddressesKey,
                                                                                          ]];
    
    NSError *error;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [self.contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"%@   %@",contact.familyName,contact.phoneticFamilyName);
        NSLog(@"%@",contact.organizationName);
        ContactInfo *info = [[ContactInfo alloc] init];
        info.givenName = contact.namePrefix;
        info.organizationName = contact.organizationName;
        info.familyName = contact.familyName;
        info.imageData = contact.imageData;
        info.phoneNumbers = contact.phoneNumbers;
        info.emailAddresses = contact.emailAddresses;
        [array addObject:info];
        
    }];
    NSLog(@"stop");
    self.dataArray = [array copy];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.info = self.dataArray[indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ContactCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKActionSheet *action = [[MKActionSheet alloc] initWithCompletion:^(MKActionSheet *actionSheet, NSInteger clickedIndex) {
        
    } cancelTitle:@"取消" otherTitles:@"确认",@"1", nil];
    [action show];
}

#pragma mark - getter

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
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
