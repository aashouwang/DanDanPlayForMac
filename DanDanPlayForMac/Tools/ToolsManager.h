//
//  ToolsManager.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/8/16.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface ToolsManager : NSObject
+ (NSString *)stringValueWithDanmakuSource:(DanDanPlayDanmakuSource)source;
+ (DanDanPlayDanmakuSource)enumValueWithDanmakuSourceStringValue:(NSString *)source;

+ (NSMutableArray *)userSentDanmaukuArrWithEpisodeId:(NSString *)episodeId;
+ (void)saveUserSentDanmakus:(NSArray *)sentDanmakus episodeId:(NSString *)episodeId;
@end
