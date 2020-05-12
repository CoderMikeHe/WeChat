//
//  MHSearchOfficialAccountsDefaultCell.m
//  WeChat
//
//  Created by admin on 2020/5/12.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHSearchOfficialAccountsDefaultCell.h"
#import "MHSearchOfficialAccountsDefaultItemViewModel.h"
@interface MHSearchOfficialAccountsDefaultCell ()

/// viewModel
@property (nonatomic, readwrite, strong) MHSearchOfficialAccountsDefaultItemViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIView *kingGloryBgView;

@property (weak, nonatomic) IBOutlet UIView *cmhBgView;

@property (weak, nonatomic) IBOutlet UIImageView *kingGloryView;
@property (weak, nonatomic) IBOutlet UIImageView *cmhView;


@end


@implementation MHSearchOfficialAccountsDefaultCell

#pragma mark - Public Method
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SearchOfficialAccountsDefaultCell";
    MHSearchOfficialAccountsDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)bindViewModel:(MHSearchOfficialAccountsDefaultItemViewModel *)viewModel {
    self.viewModel = viewModel;
}


- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows {
    
}


#pragma mark - Private Method
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置圆角
    [self.kingGloryView zy_cornerRadiusAdvance:25.5f rectCornerType:UIRectCornerAllCorners];
    [self.cmhView zy_cornerRadiusAdvance:25.5f rectCornerType:UIRectCornerAllCorners];
    
    // 设置图片
    [self.kingGloryView yy_setImageWithURL:[NSURL URLWithString:@"https://bkimg.cdn.bcebos.com/pic/b2de9c82d158ccbf6c8162a7b790ab3eb13533faeb5f?x-bce-process=image/watermark,g_7,image_d2F0ZXIvYmFpa2U5Mg==,xp_5,yp_5"] placeholder:MHWebImagePlaceholder() options:MHWebImageOptionAutomatic completion:nil];
    
    [self.cmhView yy_setImageWithURL:[NSURL URLWithString:@"http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg"] placeholder:MHWebImagePlaceholder() options:MHWebImageOptionAutomatic completion:nil];
    
    @weakify(self);
    UITapGestureRecognizer *tapGr0 = [[UITapGestureRecognizer alloc] init];
    [self.kingGloryBgView addGestureRecognizer:tapGr0];
    [tapGr0.rac_gestureSignal subscribeNext:^(id x) {
        
        @strongify(self);
        [self.viewModel.officialAccountTapCommand execute:@0];
        
    }];
    
    UITapGestureRecognizer *tapGr1 = [[UITapGestureRecognizer alloc] init];
    [self.cmhBgView addGestureRecognizer:tapGr1];
    [tapGr1.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.officialAccountTapCommand execute:@1];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
