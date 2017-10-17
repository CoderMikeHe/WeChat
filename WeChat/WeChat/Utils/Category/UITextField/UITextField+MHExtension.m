//
//  UITextField+MHExtension.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/9/6.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "UITextField+MHExtension.h"

@implementation UITextField (MHExtension)

- (void)mh_limitMaxLength:(NSInteger)maxLength
{
    /// 修改昵称
    @weakify(self);
    [[[RACSignal merge:@[RACObserve(self, text),self.rac_textSignal]] skip:0] subscribeNext:^(NSString * text) {
        @strongify(self);
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
        if (position) return ;
        if (text.length <= maxLength) return;
        
        //中文和emoj表情存在问题，需要对此进行处理
        NSRange range;
        NSUInteger inputLength = 0;
        for(int i =0 ; i < text.length && inputLength <= maxLength; i += range.length){
            range = [self.text rangeOfComposedCharacterSequenceAtIndex:i];
            inputLength += [text substringWithRange:range].length;
            if (inputLength > maxLength) self.text = [text substringWithRange:NSMakeRange(0, range.location)];
        }
    }];
}
@end
