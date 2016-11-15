//
//  SwsSwitchControllerView
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwsSwitchControllerView : UIView

/** SwsSwitchControllerView */
- (SwsSwitchControllerView *)initWithFrame:(CGRect)frame
                            titleArray:(NSMutableArray *)titleArray
                       controllerArray:(NSMutableArray *)controllerArray
                                  inVC:(id)vc ;

@end
