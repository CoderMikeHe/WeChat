//
//  MHSearchTextCell.m
//  WeChat
//
//  Created by senba on 2018/2/28.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "MHSearchTextCell.h"
#import "MHSearchFriendsViewModel.h"

@interface MHSearchTextCell ()

/// searchLabel
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchFriendsViewModel *viewModel;
@end


@implementation MHSearchTextCell
#pragma mark - Public Method

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchTextCell";
    MHSearchTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [self mh_viewFromXib];
    return cell;
}

- (void)bindViewModel:(MHSearchFriendsViewModel *)viewModel{
    self.viewModel = viewModel;
    
    self.searchLabel.text = viewModel.searchText;
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakefromnib");
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
