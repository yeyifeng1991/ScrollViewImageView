//
//  ViewController.m
//  ScrollSideShow
//
//  Created by YeYiFeng on 2018/3/23.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "ViewController.h"
#import "scrollSideShowView.h"
@interface ViewController ()<scrollSideShowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    scrollSideShowView * scrollShow = [[scrollSideShowView alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 300)];
    scrollShow.currentColor = [UIColor cyanColor];
    scrollShow.pageColor = [UIColor grayColor];
    scrollShow.imgArrays = @[
                            [UIImage imageNamed:@"1"],
                            [UIImage imageNamed:@"2"],
                            [UIImage imageNamed:@"3"],
                            [UIImage imageNamed:@"4"],
                            [UIImage imageNamed:@"5"]
                                  ];
    scrollShow.delegate = self;
    [self.view addSubview:scrollShow];

}

-(void)scrollViewWith:(scrollSideShowView * )scrollView andSelectImage:(NSInteger)index;
{
    NSLog(@"打印视图-- %@ 拿到索引 - %ld",scrollView,index);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
