//
//  MHReactiveView.h
//  WeChat
//
//  Created by senba on 2017/9/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
/// A protocol which is adopted by views which are backed by view models.
@protocol MHReactiveView <NSObject>

@optional
/// Binds the given view model to the view.
///
/// viewModel - The view model
- (void)bindViewModel:(id)viewModel;



///
/// 传递indexPath,且告诉该组(section)有多少行（row）
///
/// @param indexPath the indexPath.
/// @param rows the group have rows count.
///
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;
@end
