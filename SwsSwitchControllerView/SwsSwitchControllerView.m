//
//  SwsOptionScrollView.m
//
//  Created by sws on 6/6/6.
//  Copyright © 666年 sws. All rights reserved.
//


#define Width  self.bounds.size.width
#define Height self.bounds.size.height

#define Title_Default_Color [UIColor blackColor]
#define Title_Seleted_Color [UIColor orangeColor]

#define Formula(tag)  (2 * ((CGFloat)tag) - 1) / 2 / Page_Num * Width

#define TitleView_Height  40
#define Title_Font        15
#define SliderView_Height 2
#define Space             0

#define Page_Num          5          // 最低为3
#define SliderView_Width_IsEqual NO

#import "SwsSwitchControllerView.h"

@interface SwsSwitchControllerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) NSMutableArray *titleWidthArray;
@property (nonatomic, strong) NSMutableArray *titleButtonArray;

@property (nonatomic, assign) CGFloat titleButtonWidth;

@property (nonatomic, strong) UIView *controllerView;
@property (nonatomic, strong) UIScrollView *controllerScrollView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *controllerArray;

@property (nonatomic, weak) id vc;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) NSInteger index;

@end

@implementation SwsSwitchControllerView

- (SwsSwitchControllerView *)initWithFrame:(CGRect)frame
                                titleArray:(NSMutableArray *)titleArray
                           controllerArray:(NSMutableArray *)controllerArray
                                      inVC:(id)vc {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleArray = titleArray;
        self.controllerArray = controllerArray;
        self.vc = vc;
        self.index = 0;
        [self initUI];
    }
    return self;
}

#pragma mark - InitUI
- (void)initUI {
    
    [self initTitleView];
    [self initControllerView];
}

#pragma mark - InitTitleView
- (void)initTitleView {
    
    // Title
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, TitleView_Height)];
    _titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleView];
    
    // TitleScrollView
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, TitleView_Height)];
    _titleScrollView.delegate = self;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    
    if (_titleArray.count <= Page_Num) {
        
        _titleButtonWidth = Width / _titleArray.count;
        _titleScrollView.bounces = NO;
    } else {
        
        _titleButtonWidth = Width / Page_Num;
    }
    
    _titleScrollView.contentSize = CGSizeMake(_titleButtonWidth * _titleArray.count, TitleView_Height);
    [_titleView addSubview:_titleScrollView];
    
    // TitleButtonArray
    _titleButtonArray = [NSMutableArray array];
    for (int i = 0; i < _titleArray.count; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * _titleButtonWidth, 0, _titleButtonWidth, TitleView_Height)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:Title_Font];
        [button setTitleColor:Title_Default_Color forState:UIControlStateNormal];
        [button setTitleColor:Title_Seleted_Color forState:UIControlStateSelected];
        button.tag = i + 1;
        [button addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:button];
        
        [_titleButtonArray addObject:button];
        
        if (1 == button.tag) {
            
            button.selected = YES;
            _selectedButton = button;
            button.userInteractionEnabled = NO;
        }
    }
    
    // TitleWidthArray
    _titleWidthArray = [NSMutableArray array];
    for (NSString *string in _titleArray) {
        
        CGFloat titleWidth = [self widthWithString:string andFontSize:Title_Font];
        [_titleWidthArray addObject:[NSString stringWithFormat:@"%lf", titleWidth]];
    }
    
    // Slider
    _sliderView = [[UIView alloc] init];
    _sliderView.backgroundColor = Title_Seleted_Color;
    if (SliderView_Width_IsEqual) {
        
        _sliderView.bounds = CGRectMake(0, TitleView_Height - SliderView_Height, Width / Page_Num, SliderView_Height);
    } else {
        
        _sliderView.bounds =CGRectMake(0, TitleView_Height - SliderView_Height, [_titleWidthArray[0] doubleValue], SliderView_Height);
    }
    
    if (_titleArray.count <= Page_Num) {
        
        _sliderView.center = CGPointMake((2 * ((CGFloat)1 ) - 1) / 2 / _titleArray.count * Width, TitleView_Height - SliderView_Height / 2);
    } else {
        
         _sliderView.center = CGPointMake((2 * ((CGFloat)1) - 1) / 2 / Page_Num * Width, TitleView_Height - SliderView_Height / 2);
    }
    [_titleView addSubview:_sliderView];
}

#pragma mark - initControllerView
- (void)initControllerView {
    
    _controllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TitleView_Height + Space, Width, Height - TitleView_Height - Space)];
    _controllerScrollView.delegate = self;
    _controllerScrollView.pagingEnabled = YES;
    _controllerScrollView.showsHorizontalScrollIndicator = NO;
    _controllerScrollView.showsVerticalScrollIndicator = NO;
    _controllerScrollView.contentSize = CGSizeMake(_controllerArray.count * Width, 0);
    [self addSubview:_controllerScrollView];
    
    for (int i = 0; i < _controllerArray.count; i ++) {
        
        UIViewController *controller = _controllerArray[i];
        controller.view.frame = CGRectMake(i * Width, 0, Width, _controllerScrollView.bounds.size.height);
        [_vc addChildViewController:controller];
        [((UIViewController *)_vc).view addSubview:controller.view];
        [_controllerScrollView addSubview:controller.view];
    }
}

#pragma mark - ClickTitleButton
- (void)clickTitleButton:(UIButton *)sender {
    
    if (_selectedButton == sender) {
        
        return;
    }
    
    _selectedButton.userInteractionEnabled = YES;
    sender.userInteractionEnabled = NO;
    _selectedButton.selected = !_selectedButton.selected;
    sender.selected = !sender.selected;
    _selectedButton = sender;
    
    [_controllerScrollView setContentOffset:CGPointMake((sender.tag - 1) * Width, 0) animated:YES];
    
    __weak SwsSwitchControllerView *view = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [view calculateWithSender:sender vc:view];
    }];

    _index = sender.tag;
}

#pragma mark － 判断计算
- (void)calculateWithSender:(UIButton *)sender vc:(SwsSwitchControllerView *)view {
    
    if (!SliderView_Width_IsEqual) {
        
        view.sliderView.bounds = CGRectMake(0, 0, [view.titleWidthArray[sender.tag - 1] floatValue], SliderView_Height);
    }
    
    if (view.titleArray.count <= Page_Num) {
        
        view.sliderView.center = CGPointMake((2 * ((CGFloat)sender.tag + 1) - 1) / 2 / view.titleArray.count * Width, TitleView_Height - SliderView_Height / 2);
    } else {
        
        // 偶数
        if (Page_Num % 2 == /* DISABLES CODE */ (0)) {
            
            if (sender.tag <= Page_Num / 2) { // 屏幕左边 Page_Num的一半
                
                view.sliderView.center = CGPointMake(Formula(sender.tag), TitleView_Height - SliderView_Height / 2);
                [view.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if (sender.tag > view.titleArray.count -  Page_Num / 2) { // 屏幕右边 最大值 减去 Page_Num的一半
                
                view.sliderView.center = CGPointMake(Formula(sender.tag - (view.titleArray.count - Page_Num)), TitleView_Height - SliderView_Height / 2);
                
                [view.titleScrollView setContentOffset:CGPointMake((view.titleArray.count - Page_Num) * view.titleButtonWidth, 0) animated:YES];
            } else {
                
                if (sender.tag > view.index) { // 点右
                    
                    view.sliderView.center = CGPointMake(Formula(Page_Num / 2 + 1), TitleView_Height - SliderView_Height / 2);
                    if (sender.tag != Page_Num / 2 + 1) {
                        
                        [view.titleScrollView setContentOffset:CGPointMake((sender.tag - Page_Num / 2 - 1) * view.titleButtonWidth, 0) animated:YES];
                    }
                } else {  // 点左
                    
                    view.sliderView.center = CGPointMake(Formula(Page_Num / 2), TitleView_Height - SliderView_Height / 2);
                    if (sender.tag != Page_Num / 2) {
                        
                        [view.titleScrollView setContentOffset:CGPointMake((sender.tag - Page_Num / 2) * view.titleButtonWidth, 0) animated:YES];
                    }
                }
            }
        } else { // 奇数居中显示
            
            if (sender.tag <= (Page_Num + 1) / 2) { // 左
                
                view.sliderView.center = CGPointMake(Formula(sender.tag), TitleView_Height - SliderView_Height / 2);
                [view.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if (sender.tag >= view.titleArray.count -  (Page_Num + 1) / 2 + 1) { // 右
                
                view.sliderView.center = CGPointMake(Formula(sender.tag - (view.titleArray.count - Page_Num)), TitleView_Height - SliderView_Height / 2);
                
                [view.titleScrollView setContentOffset:CGPointMake((view.titleArray.count - Page_Num) * view.titleButtonWidth, 0) animated:YES];
            } else { // 中间
                
                view.sliderView.center = CGPointMake(Width / 2, TitleView_Height - SliderView_Height / 2);
                
                if (sender.tag > view.index) { // 点右
                    
                    if (sender.tag != (Page_Num + 1) / 2 - 1) {
                        
                        [view.titleScrollView setContentOffset:CGPointMake((sender.tag - (Page_Num - 1 ) / 2 - 1) * view.titleButtonWidth, 0) animated:YES];
                    }
                } else { // 点左
                    
                    [view.titleScrollView setContentOffset:CGPointMake((sender.tag - (Page_Num - 1) / 2 - 1) * view.titleButtonWidth, 0) animated:YES];
                }
            }
        }
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _titleScrollView) {
        
        return;
    }
    
    NSInteger xOff = scrollView.contentOffset.x / Width;
    UIButton *button = _titleButtonArray[xOff];
    [self clickTitleButton:button];
}

#pragma mark - String_Width
- (float)widthWithString:(NSString*)string andFontSize:(int)fontSize {
    
    CGSize size = CGSizeMake(MAXFLOAT, 0);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize detailSize = [string boundingRectWithSize:size
                                             options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return detailSize.width;
}

@end
