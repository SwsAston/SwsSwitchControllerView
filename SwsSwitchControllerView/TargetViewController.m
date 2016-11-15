//
//  TargetViewController.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import "TargetViewController.h"

#define Random_Color  [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

@interface TargetViewController ()

@end

@implementation TargetViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = Random_Color;
}

@end
