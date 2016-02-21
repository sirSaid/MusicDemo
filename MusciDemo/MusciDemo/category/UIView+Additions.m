//
//  UIView+Additions.m
//  maidoumi
//
//  Created by  郭晓敏-maidoumi on 14-3-28.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import "UIView+Additions.h"
#import "MBProgressHUD.h"
#import "UIView+HB.h"

#define kProgressHUDTag 4334

#define kProgressSubImageTag 4336
#define kProgressSubLabelTag 4337

@implementation UIView (Additions)

//纵坐标和宽高不变，只修改横坐标，以下分别修改一项
-(void)setFrame_x:(CGFloat)x
{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}
-(void)setFrame_y:(CGFloat)y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}
-(void)setFrame_width:(CGFloat)width
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}
-(void)setFrame_height:(CGFloat)height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

-(void)setCenter_y:(CGFloat)y
{
    [self setCenter:CGPointMake(self.center.x, y)];
}

-(void)setCenter_x:(CGFloat)x
{
    [self setCenter:CGPointMake(x, self.center.y)];
}

-(CGFloat)getFrame_right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)getFrame_Bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

-(CGSize)size
{
    return self.frame.size;
}

-(CGPoint)origin
{
    return self.frame.origin;
}

-(void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

-(void)showLoadingWithLabelText:(NSString *)labelText
{
    [self showLoadingWithLabelText:labelText withIsNeedTransform:NO];
}

-(void)showLoadingWithLabelText:(NSString *)labelText withIsNeedTransform:(BOOL)isNeedTransform
{
    UIView *view = [self viewWithTag:kProgressViewTag];
    view.hidden = NO;
    UIImageView *animatedImageView = (UIImageView *)[view viewWithTag:kProgressSubImageTag];
    UILabel *promptLabel = (UILabel *)[view viewWithTag:kProgressSubLabelTag];
    if (!view)
    {
        //根
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 110)];
        view.tag = kProgressViewTag;
        [self insertSubview:view atIndex:0];
        view.center = CGPointMake(self.width/2 - 130, self.height/2);
        
        if (isNeedTransform)
        {
            CGPoint point = view.center;
            view.transform = CGAffineTransformMakeRotation(M_PI/2);
            view.center = point;
        }
        
        //动画image
        if (!animatedImageView)
        {
            NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],[UIImage imageNamed:@"loading_2.png"], nil];
            animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 70, 70)];
            animatedImageView.animationImages = images;
            animatedImageView.animationDuration = 0.5;
            animatedImageView.animationRepeatCount = 0;
            animatedImageView.tag = kProgressSubImageTag;
            [view addSubview:animatedImageView];
        }
        
        //加载label
        if (!promptLabel)
        {
            promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 30)];
            [view addSubview:promptLabel];
            promptLabel.tag = kProgressSubLabelTag;
            promptLabel.textAlignment = NSTextAlignmentCenter;
            promptLabel.font = [UIFont systemFontOfSize:12];
            promptLabel.textColor = [UIColor darkGrayColor];
        }
    }
    [self insertSubview:view atIndex:0];
    [animatedImageView startAnimating];
    if (labelText)
    {
        promptLabel.text = labelText;
    }
    else
    {
        promptLabel.text = @"努力加载中...";
    }
}

-(void)hideLoading
{
    UIView *view = [self viewWithTag:kProgressViewTag];
    view.hidden = YES;
    UIImageView *animatedImageView = (UIImageView *)[view viewWithTag:kProgressSubImageTag];
    [animatedImageView stopAnimating];
}

//展示ProgressHUD成功
-(void)showProgressHUDSuccessWithLabelText:(NSString *)labelText withAfterDelayHide:(NSTimeInterval)afterDelay
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kProgressHUDTag];
    if (!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = kProgressHUDTag;
        [self addSubview:hud];
    }
    [self bringSubviewToFront:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = labelText;
    [hud show:YES];
    [hud hide:YES afterDelay:afterDelay];
}

//展示ProgressHUD
-(void)showProgressHUDNoActivityWithLabelText:(NSString *)labelText withAfterDelayHide:(NSTimeInterval)afterDelay
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kProgressHUDTag];
    if (!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = kProgressHUDTag;
        [self addSubview:hud];
    }
    [self bringSubviewToFront:hud];
    hud.customView = [[UIView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = labelText;
    [hud show:YES];
    [hud hide:YES afterDelay:afterDelay];
}

//展示ProgressHUD
-(void)showProgressHUDWithLabelText:(NSString *)labelText withAnimated:(BOOL)animated
{
    [self showProgressHUDWithLabelText:labelText withAnimated:animated isNeedTransform:NO];
}

-(void)showProgressHUDWithLabelText:(NSString *)labelText withAnimated:(BOOL)animated isNeedTransform:(BOOL)isNeedTransform
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kProgressHUDTag];
    if (!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = kProgressHUDTag;
        if (isNeedTransform)
        {
            hud.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
        [self addSubview:hud];
    }
    [self bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (!labelText)
    {
        labelText = @"加载中";
    }
    hud.labelText = labelText;
    [hud show:animated];
    [self performSelector:@selector(hideProgressHUDWithAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:20];
}

-(BOOL)isShowProgressHUDing
{
     MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kProgressHUDTag];
    if (hud)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//隐藏ProgressHUD
-(void)hideProgressHUDWithAnimated:(BOOL)animated
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kProgressHUDTag];
    if (hud)
    {
        [hud hide:animated];
        [hud removeFromSuperview];
    }
}
@end

@implementation UILabel (Additions)

-(void)setSingleRowAutosizeLimitWidth:(float)limitWidth
{
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(limitWidth, self.size.height)
                                                options:(NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)
                                             attributes:tdic
                                                context:nil].size;
    [self setFrame_width:size.width];
}

-(void)setAutoresizeWithLimitWidth:(float)limitWidth
{
//    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(limitWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    [self setSize:size];
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(limitWidth, MAXFLOAT)
                                                     options:(NSStringDrawingOptions)(
                                                                                      NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)
                                                  attributes:tdic
                                                     context:nil].size;
    
    [self setSize:CGSizeMake(size.width, size.height)];
}


-(void)setAutoresizeWithLimitHeight:(float)limitHeight
{

    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, limitHeight)
                                          options:(NSStringDrawingOptions)(
                                                                           NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)
                                       attributes:tdic
                                          context:nil].size;
    
    [self setSize:CGSizeMake(size.width, size.height)];
}


@end

@implementation UIButton (Additions)

-(void)setAutoresizeWithLimitWidth:(float)limitWidth
{
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil];
    CGSize size = [self.titleLabel.text boundingRectWithSize:CGSizeMake(limitWidth, 300)
                                          options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading)
                                       attributes:tdic
                                          context:nil].size;
    [self setSize:CGSizeMake(size.width+30, size.height+20)];
}

@end