//
//  LoopView.h
//  LoopView
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 15/12/29.
//  Copyright © 2015年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectIndexHandler) (NSInteger selectIndex);

IB_DESIGNABLE
@interface LoopView : UIView

@property(nonatomic,assign)NSTimeInterval loopInterval;//Default is 3

@property(nonatomic,assign)IBInspectable BOOL isWebImage;//Default to NO,if you use storyboard,you must set this value before set images

@property(nonatomic,strong)NSArray *images;

@property(nonatomic,copy)NSString *placeHolderName;

@property(nonatomic,copy)SelectIndexHandler handler;

- (instancetype)initWithFrame:(CGRect)frame webImages:(NSArray *)webImages handler:(SelectIndexHandler)handler;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images handler:(SelectIndexHandler)handler;

@end
