//
//  ViewController.m
//  ElasticViewAnimation
//
//  Created by xp_mac on 16/1/11.
//  Copyright © 2016年 xp_mac. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+DegressCenter.h"

@interface MainViewController ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic) CGFloat minimalHeight;
@property (nonatomic) CGFloat maxWaveHeight;
@property (nonatomic,strong) UIView *l3ControlPointView;
@property (nonatomic,strong) UIView *l2ControlPointView;
@property (nonatomic,strong) UIView *l1ControlPointView;
@property (nonatomic,strong) UIView *cControlPointView;
@property (nonatomic,strong) UIView *r1ControlPointView;
@property (nonatomic,strong) UIView *r2ControlPointView;
@property (nonatomic,strong) UIView *r3ControlPointView;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic) BOOL animating;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _minimalHeight = 50.0;   //原始状态的高度
    _maxWaveHeight = 100.0;  //最高状态的高度
    
    _animating = NO;
    self.view.userInteractionEnabled = YES;
    _displayLink.paused = YES;
    
    //矩形框
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, _minimalHeight);
    _shapeLayer.fillColor = [UIColor colorWithRed:91/255.0 green:144/255.0 blue:212/255.0 alpha:1.0].CGColor;
    _shapeLayer.actions = @{@"position":[NSNull null],@"bounds":[NSNull null],@"path":[NSNull null]};  //关闭隐式动画，防止带来延迟效果
    [self.view.layer addSublayer:_shapeLayer];
    
    //添加手势，可以改变frame的高度
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidMove:)];
    [self.view addGestureRecognizer:panG];
    
    _l3ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _l3ControlPointView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_l3ControlPointView];
    _l2ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _l2ControlPointView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_l2ControlPointView];
    _l1ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _l1ControlPointView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_l1ControlPointView];
    _cControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _cControlPointView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_cControlPointView];
    _r1ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _r1ControlPointView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_r1ControlPointView];
    _r2ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _r2ControlPointView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_r2ControlPointView];
    _r3ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    //    _r3ControlPointView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_r3ControlPointView];
    
    //布局控制点
    [self layoutControlPoints:_minimalHeight waveHeight:0.0 locationX:self.view.bounds.size.width/2];
    [self updateShapeLayer];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateShapeLayer)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) panGestureDidMove:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled) {
        
        CGFloat centerY = _minimalHeight;
        _animating = YES;
        
        //动画
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.57 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGPoint pointl3 = _l3ControlPointView.center;
            pointl3.y = centerY;
            _l3ControlPointView.center = pointl3;
            CGPoint pointl2 = _l2ControlPointView.center;
            pointl2.y = centerY;
            _l2ControlPointView.center = pointl2;
            CGPoint pointl1 = _l1ControlPointView.center;
            pointl1.y = centerY;
            _l1ControlPointView.center = pointl1;
            CGPoint pointc = _cControlPointView.center;
            pointc.y = centerY;
            _cControlPointView.center = pointc;
            CGPoint pointr1 = _r1ControlPointView.center;
            pointr1.y = centerY;
            _r1ControlPointView.center = pointr1;
            CGPoint pointr2 = _r2ControlPointView.center;
            pointr2.y = centerY;
            _r2ControlPointView.center = pointr2;
            CGPoint pointr3 = _r3ControlPointView.center;
            pointr3.y = centerY;
            _r3ControlPointView.center = pointr3;
            
        } completion:^(BOOL finished) {
            _animating = NO;
        }];
    }
    else
    {
        CGFloat maxF = [pan translationInView:self.view].y;
        CGFloat additionalHeight = MAX(maxF, 0);
        NSLog(@"=========%f",maxF);
        
        CGFloat waveHeight = MIN(additionalHeight * 0.6, _maxWaveHeight);
        CGFloat baseHeight = _minimalHeight + additionalHeight - waveHeight;
        
        CGFloat locationX = [pan translationInView:self.view].x + pan.view.center.x;  //视图上手指滑动的x坐标，也就是波浪的顶部
        NSLog(@"+++++++%f",locationX);
        
        if (maxF > 150) {
            
        }
        else
        {
            [self layoutControlPoints:baseHeight waveHeight:waveHeight locationX:locationX];
            [self updateShapeLayer];
        }
    }
}

- (void) layoutControlPoints:(CGFloat)baseHeight waveHeight:(CGFloat)waveHeight locationX:(CGFloat)locationX
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat minLeftX = MIN((locationX - width / 2.0) * 0.28, 0);
    CGFloat maxRightX = MAX(width + (locationX - width / 2.0) * 0.28, width);
    
    CGFloat leftPartWidth = locationX - minLeftX;
    CGFloat rightPartWidth = maxRightX - locationX;
    
    _l3ControlPointView.center = CGPointMake(minLeftX, baseHeight);
    _l2ControlPointView.center = CGPointMake(minLeftX + leftPartWidth*0.44, baseHeight);
    _l1ControlPointView.center = CGPointMake(minLeftX + leftPartWidth*0.71, baseHeight + waveHeight*0.64);
    _cControlPointView.center = CGPointMake(locationX, baseHeight + waveHeight*1.36);
    _r1ControlPointView.center = CGPointMake(maxRightX - rightPartWidth*0.71, baseHeight + waveHeight*0.64);
    _r2ControlPointView.center = CGPointMake(maxRightX - (rightPartWidth*0.44), baseHeight);
    _r3ControlPointView.center = CGPointMake(maxRightX, baseHeight);
}

- (void) updateShapeLayer
{
    _shapeLayer.path = [self currentPath];
}

- (CGPathRef )currentPath
{
    CGFloat width = self.view.bounds.size.width;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(0, [_l3ControlPointView usePresentationLayerIfPossible:_animating].y)];
    [bezierPath addCurveToPoint:[_l1ControlPointView usePresentationLayerIfPossible:_animating] controlPoint1:[_l3ControlPointView usePresentationLayerIfPossible:_animating] controlPoint2:[_l2ControlPointView usePresentationLayerIfPossible:_animating]];
    [bezierPath addCurveToPoint:[_r1ControlPointView usePresentationLayerIfPossible:_animating] controlPoint1:[_cControlPointView usePresentationLayerIfPossible:_animating] controlPoint2:[_r1ControlPointView usePresentationLayerIfPossible:_animating]];
    [bezierPath addCurveToPoint:[_r3ControlPointView usePresentationLayerIfPossible:_animating] controlPoint1:[_r1ControlPointView usePresentationLayerIfPossible:_animating] controlPoint2:[_r2ControlPointView usePresentationLayerIfPossible:_animating]];
    [bezierPath addLineToPoint:CGPointMake(width, 0.0)];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
