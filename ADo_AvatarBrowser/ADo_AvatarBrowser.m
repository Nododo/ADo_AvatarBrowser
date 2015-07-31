//
//  ADo_AvatarBrowser.m
//  Weibo
//
//  Created by 杜 维欣 on 15/7/30.
//  Copyright (c) 2015年 Rednovo. All rights reserved.
//

#import "ADo_AvatarBrowser.h"

#define maxScale 2.0
#define minScale 1.0
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ADo_AvatarBrowser ()<UIScrollViewDelegate,UIActionSheetDelegate>
@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,assign)CGFloat currentScale;
@property (nonatomic,assign)CGRect oldFrame;



@end



@implementation ADo_AvatarBrowser
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)orignImage view:(UIView *)orignView;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentScale = 1.0;
        self.alpha = 0;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        scrollView.userInteractionEnabled = YES;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.maximumZoomScale = maxScale;//最大倍率（默认倍率）
        scrollView.minimumZoomScale = minScale;//最小倍率（默认倍率）
        scrollView.decelerationRate = 1.0;//减速倍率（默认倍率）
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.oldFrame = [orignView convertRect:orignView.bounds toView:window];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.oldFrame];
        imageView.userInteractionEnabled = YES;
        imageView.image = orignImage;
        [self.scrollView addSubview:imageView];
        self.imageView = imageView;
        
        UITapGestureRecognizer *doubelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
        doubelGesture.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubelGesture];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
        [self.scrollView addGestureRecognizer: tap];
        
        [tap requireGestureRecognizerToFail:doubelGesture];
        [window addSubview:self];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePicture:)];
        longPress.minimumPressDuration = 1.0;
        [tap requireGestureRecognizerToFail:longPress];
        [self.scrollView  addGestureRecognizer:longPress];
    }
    
    return self;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale == 0) {
        return;
    }
    self.currentScale = scale;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    
}

-(void)doubleGesture:(UIGestureRecognizer *)sender
{
    //当前倍数等于最大放大倍数
    //双击默认为缩小到原图
    if (self.currentScale <= maxScale && self.currentScale > minScale) {
        self.currentScale = minScale;
        [self.scrollView setZoomScale:self.currentScale animated:YES];
        return;
    }
    //当前等于最小放大倍数
    //双击默认为放大到最大倍数
    if (self.currentScale == minScale) {
        self.currentScale = maxScale;
        [self.scrollView setZoomScale:self.currentScale animated:YES];
        return;
    }
    
}

- (void)show
{
    float imageW = self.imageView.image.size.width;
    float imageH = self.imageView.image.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake(0 , (kScreenHeight - imageH * kScreenWidth / imageW) /2, kScreenWidth, imageH * kScreenWidth/imageW);
        self.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.alpha = 0;
        self.scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)savePicture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片" , nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.superview];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector ( image:didFinishSavingWithError:contextInfo:) , nil ) ;
    }

}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (error) {
        
    }else
    {
        
    }
    
    
}

- (void)dealloc
{
    
}
@end
