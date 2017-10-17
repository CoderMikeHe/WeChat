//
//  MHCommonViewModel.m
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommonViewModel.h"

@implementation MHCommonViewModel

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    /// 选中cell的命令
    /// UI Test
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        MHCommonGroupViewModel *groupViewModel = self.dataSource[indexPath.section] ;
        MHCommonItemViewModel *itemViewModel = groupViewModel.itemViewModels[indexPath.row];
        
        if (itemViewModel.operation) {
            /// 有操作执行操作
            itemViewModel.operation();
        }else if(itemViewModel.destViewModelClass){
            /// 没有操作就跳转VC
            Class viewModelClass = itemViewModel.destViewModelClass;
            MHViewModel *viewModel = [[viewModelClass alloc] initWithServices:self.services params:@{MHViewModelTitleKey:itemViewModel.title}];
            [self.services pushViewModel:viewModel animated:YES];
        }
        return [RACSignal empty];
    }];
}


@end
