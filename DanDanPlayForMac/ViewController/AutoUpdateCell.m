//
//  AutoUpdateCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/10.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AutoUpdateCell.h"
#import "UpdateNetManager.h"
#import "UpdateViewController.h"
#import "NSAlert+Tools.h"
#import "NSOpenPanel+Tools.h"

@interface AutoUpdateCell()
@property (weak) IBOutlet NSTextField *downLoadPathTextField;
@property (weak) IBOutlet NSButton *autoCheakUpdateInfoOnstartButton;

@end

@implementation AutoUpdateCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.downLoadPathTextField.placeholderString = [UserDefaultManager shareUserDefaultManager].autoDownLoadPath;
    self.autoCheakUpdateInfoOnstartButton.state = [UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart;
}

- (IBAction)clickChangeDirectoryButton:(NSButton *)sender {
    NSOpenPanel* openPanel = [NSOpenPanel chooseDirectoriesPanelWithTitle:@"选取下载目录" defaultURL:[NSURL fileURLWithPath:[UserDefaultManager shareUserDefaultManager].autoDownLoadPath]];
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton){
            NSString *path = openPanel.URL.path;
            self.downLoadPathTextField.placeholderString = path;
            [UserDefaultManager shareUserDefaultManager].autoDownLoadPath = path;
        }
    }];

}
- (IBAction)clickAutoCheakUpdateInfoAtStartButton:(NSButton *)sender {
    [UserDefaultManager shareUserDefaultManager].cheakDownLoadInfoAtStart = sender.state;
}

- (IBAction)clickCheakUpdateInfoButton:(NSButton *)sender {
    [UpdateNetManager latestVersionWithCompletionHandler:^(NSString *version, NSString *details, NSString *hash, NSError *error) {
        CGFloat curentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
        //判断当前版本是否比最新版本小
        if (curentVersion < [version floatValue]) {
            NSViewController *vc = NSApp.keyWindow.contentViewController;
            [vc presentViewControllerAsModalWindow:[[UpdateViewController alloc] initWithVersion:version details:details hash:hash]];
        }
        else {
            [[NSAlert alertWithMessageText:[DanDanPlayMessageModel messageModelWithType:DanDanPlayMessageTypeNoUpdateInfo].message informativeText:nil] runModal];
        }
    }];
}

@end
