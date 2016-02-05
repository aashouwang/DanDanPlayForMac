//
//  BiliBiliSearchViewModel.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/5.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "BiliBiliSearchViewModel.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
#import "ShiBanModel.h"
#import "DanMuNetManager.h"

@implementation BiliBiliSearchViewModel
{
    NSArray <BiliBiliSearchDataModel *>*_shiBanViewArr;
    NSArray <BiliBiliShiBanDataModel *>*_infoArr;
    NSURL *_coverURL;
    NSString *_shiBanTitle;
    NSString *_shiBanDetail;
}

- (NSInteger)shiBanArrCount{
    return _shiBanViewArr.count;
}

- (NSInteger)infoArrCount{
    return _infoArr.count;
}

- (NSString *)shiBanTitleForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].title:@"";
}

- (NSString *)seasonIDForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].isBangumi? _shiBanViewArr[row].seasonID:_shiBanViewArr[row].aid:@"";
}

- (NSString *)aidForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].aid:nil;
}

- (NSString *)episodeTitleForRow:(NSInteger)row{
    return (row < _infoArr.count)?[NSString stringWithFormat: @"%ld. %@", (long)row + 1,_infoArr[row].title]:@"";
}

- (BOOL)isShiBanForRow:(NSInteger)row{
    return (row < _shiBanViewArr.count)?_shiBanViewArr[row].isBangumi:NO;
}

- (NSURL *)coverImg{
    return _coverURL;
}

- (NSString *)shiBanTitle{
    return _shiBanTitle;
}

- (NSString *)shiBanDetail{
    return _shiBanDetail;
}



- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete{
    if (!keyWord) {
        complete(nil);
        return;
    }
    
    [SearchNetManager searchBiliBiliWithParameters:@{@"keyword": keyWord} completionHandler:^(BiliBiliSearchModel *responseObj, NSError *error) {
        //移除掉不是番剧 但是seasonID又不为空的对象
        NSMutableArray *tempArr = [responseObj.result mutableCopy];
        [responseObj.result enumerateObjectsUsingBlock:^(BiliBiliSearchDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isBangumi && obj.seasonID){
                [tempArr removeObject: obj];
            }
        }];
        
        _shiBanViewArr = tempArr;
        _infoArr = nil;
        _coverURL = nil;
        _shiBanTitle = nil;
        _shiBanDetail = nil;
        complete(error);
    }];
}

- (void)refreshWithSeasonID:(NSString*)SeasonID completionHandler:(void(^)(NSError *error))complete{
    if (!SeasonID) {
        complete(nil);
        return;
    }
    
    [SearchNetManager searchBiliBiliSeasonInfoWithParameters:@{@"seasonID": SeasonID} completionHandler:^(BiliBiliShiBanModel *responseObj, NSError *error) {
        _infoArr = responseObj.episodes;
        _coverURL = responseObj.cover;
        _shiBanTitle = responseObj.title?responseObj.title:@"";
        _shiBanDetail = responseObj.detail?responseObj.detail:@"";
        complete(error);
    }];
}

- (void)downDanMuWithRow:(NSInteger)row completionHandler:(void(^)(NSError *error))complete{
    NSString *danMuKuID = [self danMuKuIDForRow: row];
    if (!danMuKuID) {
        complete(nil);
        return;
    }
    
    [DanMuNetManager downThirdPartyDanMuWithParameters:@{@"danmuku":danMuKuID, @"provider":@"bilibili"} completionHandler:^(id responseObj, NSError *error) {
        //通知关闭列表视图控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disMissViewController" object:self userInfo:responseObj];
        //通知开始播放
        [[NSNotificationCenter defaultCenter] postNotificationName:@"danMuChooseOver" object:self userInfo:responseObj];
        complete(responseObj);
    }];
}


#pragma mark - 私有方法

- (NSString *)danMuKuIDForRow:(NSInteger)row{
    return (row < _infoArr.count)?_infoArr[row].danmuku:@"";
}

@end
