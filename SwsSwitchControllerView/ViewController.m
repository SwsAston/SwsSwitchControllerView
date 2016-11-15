//
//  ViewController.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "ViewController.h"
#import "SwsSwitchControllerView.h"
#import "TargetViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"Item1",@"I2",@"Item3",@"Item4",@"I5",@"Item6",@"Item7",@"Item8", nil];
    NSMutableArray *vcArray = [NSMutableArray arrayWithObjects:[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init],[[TargetViewController alloc] init], nil];
    
    SwsSwitchControllerView *switchView = [[SwsSwitchControllerView alloc]
                                           initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)
                                           titleArray:titleArray
                                           controllerArray:vcArray
                                           inVC:self];
    [self.view addSubview:switchView];
}

@end
