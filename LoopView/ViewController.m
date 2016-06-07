//
//  ViewController.m
//  LoopView
//
//  email：chongyangfly@163.com
//  QQ：1909295866
//  github：https://github.com/wangcy90
//  blog：http://wangcy90.github.io
//
//  Created by WangChongyang on 16/6/7.
//  Copyright © 2016年 WangChongyang. All rights reserved.
//

#import "ViewController.h"
#import "LoopView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LoopView *loopView;

@property (strong, nonatomic)LoopView *loopView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *webImages = @[@"http://ww1.sinaimg.cn/mw690/7f9e9b4dgw1f4mpokyurpj20p00foq51.jpg",
                        @"http://ww2.sinaimg.cn/mw690/7f9e9b4dgw1f4mpolnfq0j20p00fewj5.jpg",
                        @"http://ww3.sinaimg.cn/mw690/7f9e9b4dgw1f4mpomwcg0j20p00fv0vs.jpg",
                        @"http://ww1.sinaimg.cn/mw690/7f9e9b4dgw1f4mpoprtymj20p00goq6l.jpg",
                        @"http://ww4.sinaimg.cn/mw690/7f9e9b4dgw1f4mpop2f9aj20p00godjm.jpg"];
    
    _loopView.images = webImages;
    
    _loopView.handler = ^(NSInteger selectIndex) {
        NSLog(@"web images selected at index ------> %@",@(selectIndex));
    };
    
    NSArray *images = @[@"image0.jpg",@"image1.jpg",@"image2.jpg",@"image3.jpg"];
    
    self.loopView1.images = images;
    
    self.loopView1.handler = ^(NSInteger selectIndex) {
        NSLog(@"local images selected at index ------ %@",@(selectIndex));
    };
    
    [self.view addSubview:self.loopView1];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loopView stopLoop];
    [self.loopView1 stopLoop];
}

#pragma mark - getters

- (LoopView *)loopView1 {
    if (!_loopView1) {
        _loopView1 = [[LoopView alloc]initWithFrame:CGRectMake(15, 300, 300, 150)];
    }
    return _loopView1;
}

@end
