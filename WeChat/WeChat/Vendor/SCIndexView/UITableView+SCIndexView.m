
#import "UITableView+SCIndexView.h"
#import <objc/runtime.h>
#import "SCIndexView.h"

@interface SCWeakProxy : NSObject
@property (nonatomic, weak) id target;
@end
@implementation SCWeakProxy
@end

@interface UITableView () <SCIndexViewDelegate>

@property (nonatomic, strong) SCIndexView *sc_indexView;

@end

@implementation UITableView (SCIndexView)

#pragma mark - Swizzle Method

+ (void)load
{
    [self swizzledSelector:@selector(SCIndexView_layoutSubviews) originalSelector:@selector(layoutSubviews)];
}

+ (void)swizzledSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector
{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)SCIndexView_layoutSubviews {
    [self SCIndexView_layoutSubviews];
    
    if (!self.sc_indexView) {
        return;
    }
    if (self.superview && !self.sc_indexView.superview) {
        [self.superview addSubview:self.sc_indexView];
    }
    else if (!self.superview && self.sc_indexView.superview) {
        [self.sc_indexView removeFromSuperview];
    }
    if (!CGRectEqualToRect(self.sc_indexView.frame, self.frame)) {
        self.sc_indexView.frame = self.frame;
    }
    [self.sc_indexView refreshCurrentSection];
}

#pragma mark - SCIndexViewDelegate

- (void)indexView:(SCIndexView *)indexView didSelectAtSection:(NSUInteger)section
{
    if (self.sc_indexViewDelegate && [self.delegate respondsToSelector:@selector(tableView:didSelectIndexViewAtSection:)]) {
        [self.sc_indexViewDelegate tableView:self didSelectIndexViewAtSection:section];
    }
}

- (NSUInteger)sectionOfIndexView:(SCIndexView *)indexView tableViewDidScroll:(UITableView *)tableView
{
    if (self.sc_indexViewDelegate && [self.delegate respondsToSelector:@selector(sectionOfTableViewDidScroll:)]) {
        return [self.sc_indexViewDelegate sectionOfTableViewDidScroll:self];
    } else {
        return SCIndexViewInvalidSection;
    }
}

#pragma mark - Public Methods

- (void)sc_refreshCurrentSectionOfIndexView {
    [self.sc_indexView refreshCurrentSection];
}

#pragma mark - Private Methods

- (SCIndexView *)createIndexView {
    SCIndexView *indexView = [[SCIndexView alloc] initWithTableView:self configuration:self.sc_indexViewConfiguration];
    indexView.translucentForTableViewInNavigationBar = self.sc_translucentForTableViewInNavigationBar;
    indexView.startSection = self.sc_startSection;
    indexView.delegate = self;
    return indexView;
}

#pragma mark - Getter and Setter

- (SCIndexView *)sc_indexView
{
    return objc_getAssociatedObject(self, @selector(sc_indexView));
}

- (void)setSc_indexView:(SCIndexView *)sc_indexView
{
    if (self.sc_indexView == sc_indexView) return;
    
    objc_setAssociatedObject(self, @selector(sc_indexView), sc_indexView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SCIndexViewConfiguration *)sc_indexViewConfiguration
{
    SCIndexViewConfiguration *sc_indexViewConfiguration = objc_getAssociatedObject(self, @selector(sc_indexViewConfiguration));
    if (!sc_indexViewConfiguration) {
        sc_indexViewConfiguration = [SCIndexViewConfiguration configuration];
    }
    return sc_indexViewConfiguration;
}

- (void)setSc_indexViewConfiguration:(SCIndexViewConfiguration *)sc_indexViewConfiguration
{
    if (self.sc_indexViewConfiguration == sc_indexViewConfiguration) return;
    
    objc_setAssociatedObject(self, @selector(sc_indexViewConfiguration), sc_indexViewConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SCTableViewSectionIndexDelegate>)sc_indexViewDelegate
{
    SCWeakProxy *weakProxy = objc_getAssociatedObject(self, @selector(sc_indexViewDelegate));
    return weakProxy.target;
}

- (void)setSc_indexViewDelegate:(id<SCTableViewSectionIndexDelegate>)sc_indexViewDelegate
{
    if (self.sc_indexViewDelegate == sc_indexViewDelegate) return;
    
    SCWeakProxy *weakProxy = [SCWeakProxy new];
    weakProxy.target = sc_indexViewDelegate;
    objc_setAssociatedObject(self, @selector(sc_indexViewDelegate), weakProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sc_translucentForTableViewInNavigationBar
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(sc_translucentForTableViewInNavigationBar));
    return number.boolValue;
}

- (void)setSc_translucentForTableViewInNavigationBar:(BOOL)sc_translucentForTableViewInNavigationBar
{
    if (self.sc_translucentForTableViewInNavigationBar == sc_translucentForTableViewInNavigationBar) return;
    
    objc_setAssociatedObject(self, @selector(sc_translucentForTableViewInNavigationBar), @(sc_translucentForTableViewInNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.sc_indexView.translucentForTableViewInNavigationBar = sc_translucentForTableViewInNavigationBar;
}

- (NSArray<NSString *> *)sc_indexViewDataSource
{
    return objc_getAssociatedObject(self, @selector(sc_indexViewDataSource));
}

- (void)setSc_indexViewDataSource:(NSArray<NSString *> *)sc_indexViewDataSource
{
    if (self.sc_indexViewDataSource == sc_indexViewDataSource) return;
    objc_setAssociatedObject(self, @selector(sc_indexViewDataSource), sc_indexViewDataSource.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (sc_indexViewDataSource.count > 0) {
        if (!self.sc_indexView) {
            self.sc_indexView = [self createIndexView];
            [self.superview addSubview:self.sc_indexView];
        }
        self.sc_indexView.dataSource = sc_indexViewDataSource.copy;
        self.sc_indexView.hidden = NO;
    }
    else {
        self.sc_indexView.hidden = YES;
    }
}

- (NSUInteger)sc_startSection {
    NSNumber *number = objc_getAssociatedObject(self, @selector(sc_startSection));
    return number.unsignedIntegerValue;
}

- (void)setSc_startSection:(NSUInteger)sc_startSection {
    if (self.sc_startSection == sc_startSection) return;
    
    objc_setAssociatedObject(self, @selector(sc_startSection), @(sc_startSection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.sc_indexView.startSection = sc_startSection;
}

@end
