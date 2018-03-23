//
//  scrollSideShowView.h
//  ScrollSideShow
//
//  Created by YeYiFeng on 2018/3/23.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import <UIKit/UIKit.h>
@class scrollSideShowView;
@protocol scrollSideShowViewDelegate<NSObject>
-(void)scrollViewWith:(scrollSideShowView * )scrollView andSelectImage:(NSInteger)index;
@end
@interface scrollSideShowView : UIView
@property(nonatomic,assign)id<scrollSideShowViewDelegate>delegate;
@property (nonatomic,copy) NSArray * imgArrays;//图片数组
@property(nonatomic,strong) UIColor * currentColor;
@property(nonatomic,strong) UIColor * pageColor;

@end
