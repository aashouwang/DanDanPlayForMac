//
//  ThirdPartySearchViewController.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface ThirdPartySearchViewController : NSViewController
/**
 *  番剧的 tableView
 */
@property (weak) IBOutlet NSTableView *shiBantableView;
/**
 *  分集的 tableView
 */
@property (weak) IBOutlet NSTableView *episodeTableView;

/**
 *  根据关键词刷新
 *
 *  @param keyWord           关键词
 *  @param completionHandler 回调
 */
- (void)refreshWithKeyWord:(NSString *)keyWord completion:(void(^)(NSError *error))completionHandler;
/**
 *  根据类型初始化
 *
 *  @param type 控制器类型
 *
 *  @return self
 */
- (instancetype)initWithType:(DanDanPlayDanmakuSource)type;
@end
