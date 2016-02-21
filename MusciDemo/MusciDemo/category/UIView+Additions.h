//
//  UIView+Additions.h
//  maidoumi
//
//  Created by 郭晓敏 on 14-3-28.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProgressViewTag 4335

@interface UIView (Additions)

//纵坐标和宽高不变，只修改横坐标，以下分别修改一项
-(void)setFrame_x:(CGFloat)x;
-(void)setFrame_y:(CGFloat)y;
-(void)setFrame_width:(CGFloat)width;
-(void)setFrame_height:(CGFloat)height;

-(void)setCenter_x:(CGFloat)x;
-(void)setCenter_y:(CGFloat)y;

-(CGFloat)getFrame_right;
-(CGFloat)getFrame_Bottom;

@property (nonatomic,assign) CGSize size;

-(CGPoint)origin;

-(void)setOrigin:(CGPoint)origin;

//展示ProgressHUD
-(void)showProgressHUDWithLabelText:(NSString *)labelText withAnimated:(BOOL)animated;

-(void)showProgressHUDWithLabelText:(NSString *)labelText withAnimated:(BOOL)animated isNeedTransform:(BOOL)isNeedTransform;

//展示ProgressHUD成功
-(void)showProgressHUDSuccessWithLabelText:(NSString *)labelText withAfterDelayHide:(NSTimeInterval)afterDelay;

//展示ProgressHUD
-(void)showProgressHUDNoActivityWithLabelText:(NSString *)labelText withAfterDelayHide:(NSTimeInterval)afterDelay;

//隐藏ProgressHUD
-(void)hideProgressHUDWithAnimated:(BOOL)animated;

-(BOOL)isShowProgressHUDing;

-(void)showLoadingWithLabelText:(NSString *)labelText;

-(void)showLoadingWithLabelText:(NSString *)labelText withIsNeedTransform:(BOOL)isNeedTransform;

-(void)hideLoading;

@end

@interface UILabel (Additions)

-(void)setSingleRowAutosizeLimitWidth:(float)limitWidth;

-(void)setAutoresizeWithLimitWidth:(float)limitWidth;
-(void)setAutoresizeWithLimitHeight:(float)limitHeight;
@end

@interface UIButton (Additions)

-(void)setAutoresizeWithLimitWidth:(float)limitWidth;

@end
