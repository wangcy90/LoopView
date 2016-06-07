//
//  LoopView.m
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

#import "LoopView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LoopView()<UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger centerImgIdx;
    NSTimer *_timer;
}

@property(nonatomic,strong)NSMutableArray *imageViews;

@property(nonatomic,assign,readwrite)BOOL isLoop;

@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame webImages:(NSArray *)webImages handler:(SelectIndexHandler)handler {
    return [self initWithFrame:frame images:webImages isWebImage:YES handler:handler];
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images handler:(SelectIndexHandler)handler {
    return [self initWithFrame:frame images:images isWebImage:NO handler:handler];
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images isWebImage:(BOOL)isWebImage handler:(SelectIndexHandler)handler {
    if (self = [super initWithFrame:frame]) {
        self.isWebImage = isWebImage;
        self.handler = handler;
        _images = images;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self.width);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [_scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.height.equalTo(_scrollView.height);
    }];
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _images.count;
    [self addSubview:_pageControl];
    
    [_pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-15);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.bottom);
    }];
    
    if (_images.count == 1) {
        
        _pageControl.hidden = YES;
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
        [contentView addSubview:imageView];
        
        [self setImage:_images.firstObject toImageView:imageView];
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(contentView);
            make.width.equalTo(self.width);
        }];
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imageView.right);
        }];
        
        _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
    }else if (_images.count > 1) {
        
        UIView *lastView;
        
        for (NSInteger i = 0; i < 3; i++) {
            
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
            [contentView addSubview:imageView];
            
            [self.imageViews addObject:imageView];
            
            if (_images.count < 3 && i == 2) {
                [self setImage:_images.firstObject toImageView:imageView];
            }else {
                [self setImage:_images[i] toImageView:imageView];
            }
            
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView ? lastView.right : contentView.left);
                make.top.bottom.equalTo(contentView);
                make.width.equalTo(self.width);
            }];
            
            lastView = imageView;
        }
        
        [contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.right);
        }];
        
        centerImgIdx = 1;
        
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        
        self.loopInterval = 3;

    }
}

#pragma mark - timer

- (void)startTimer {
    if (_images.count == 1) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.loopInterval target:self selector:@selector(fire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}

- (void)stopTimer {
    if (_timer) {
        if (_timer.valid) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)fire {
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    
    CGFloat width = self.frame.size.width;
    
    if (offsetX > 0 && offsetX != width) {
        offsetX = width;
    }
    
    [_scrollView setContentOffset:CGPointMake(offsetX + width, 0) animated:YES];
}

- (void)stopLoop {
    [self stopTimer];
}

- (void)resumeLoop {
    [self stopLoop];
    [self startTimer];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_images.count == 1) return;
    
    CGPoint point = scrollView.contentOffset;
    
    UIImageView *firstImageView = self.imageViews.firstObject;
    
    UIImageView *secondImageView = self.imageViews[1];
    
    UIImageView *thirdImageView = self.imageViews.lastObject;
    
    if (point.x >= self.frame.size.width * 2) {
        
        centerImgIdx++;
        
        if (centerImgIdx == _images.count) {
            centerImgIdx = 0;
        }
        
        NSInteger leftIdx = centerImgIdx - 1;
        
        if (centerImgIdx == 0) {
            leftIdx = _images.count - 1;
        }
        
        NSInteger rightIdx = centerImgIdx + 1;
        
        if (rightIdx == _images.count) {
            rightIdx = 0;
        }

        [self setImage:_images[leftIdx] toImageView:firstImageView];
        
        [self setImage:_images[centerImgIdx] toImageView:secondImageView];
        
        [self setImage:_images[rightIdx] toImageView:thirdImageView];
        
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        
    }else if (point.x <= 0) {
        
        centerImgIdx--;
        
        if (centerImgIdx < 0) {
            centerImgIdx = _images.count -1;
        }
        
        NSInteger leftIdx = centerImgIdx -1;
        
        if (centerImgIdx == 0) {
            leftIdx = _images.count - 1;
        }
        
        NSInteger rightIdx = centerImgIdx + 1;
        
        if (rightIdx == _images.count) {
            rightIdx = 0;
        }
        
        [self setImage:_images[leftIdx] toImageView:firstImageView];
        
        [self setImage:_images[centerImgIdx] toImageView:secondImageView];
        
        [self setImage:_images[rightIdx] toImageView:thirdImageView];
        
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        
    }
    
    _pageControl.currentPage = centerImgIdx;
    
}

- (void)setImage:(NSString *)image toImageView:(UIImageView *)imageView {
    if (self.isWebImage) {
        UIImage *placeholderImage;
        if (self.placeHolderName.length) {
            placeholderImage = [UIImage imageNamed:self.placeHolderName];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority];
    }else {
        [imageView setImage:[UIImage imageNamed:image]];
    }
}

#pragma mark - target actions

- (void)click:(UITapGestureRecognizer *)gesture {
    if (self.handler) {
        self.handler(_pageControl.currentPage);
    }
}

#pragma mark - setters

- (void)setLoopInterval:(NSTimeInterval)loopInterval {
    _loopInterval = loopInterval;
    [self stopTimer];
    [self startTimer];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    [self stopTimer];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self commonInit];
}

#pragma mark - getters

- (BOOL)isLoop {
    if (_timer) {
        return _timer.valid;
    }
    return NO;
}

- (NSString *)placeHolderName {
    if (!_placeHolderName) {
        _placeHolderName = @"";
    }
    return _placeHolderName;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray arrayWithCapacity:1];
    }
    return _imageViews;
}

@end
