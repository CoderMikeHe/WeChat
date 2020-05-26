
#import "SCIndexView.h"

#define kSCIndexViewSpace (self.configuration.indexItemHeight + self.configuration.indexItemsSpace)
#define kSCIndexViewMargin ((self.bounds.size.height - kSCIndexViewSpace * self.dataSource.count) / 2)
#define kSCIndexViewInsetTop (self.translucentForTableViewInNavigationBar ? UIApplication.sharedApplication.statusBarFrame.size.height + 44 : 0)

static NSTimeInterval kAnimationDuration = 0.25;

// 根据section值获取CATextLayer的中心点y值
static inline CGFloat SCGetTextLayerCenterY(NSUInteger position, CGFloat margin, CGFloat space)
{
    return margin + (position + 1.0 / 2) * space;
}

// 根据y值获取CATextLayer的section值
static inline NSInteger SCPositionOfTextLayerInY(CGFloat y, CGFloat margin, CGFloat space)
{
    CGFloat position = (y - margin) / space - 1.0 / 2;
    if (position <= 0) return 0;
    NSUInteger bigger = (NSUInteger)ceil(position);
    NSUInteger smaller = bigger - 1;
    CGFloat biggerCenterY = SCGetTextLayerCenterY(bigger, margin, space);
    CGFloat smallerCenterY = SCGetTextLayerCenterY(smaller, margin, space);
    return biggerCenterY + smallerCenterY > 2 * y ? smaller : bigger;
}

@interface SCIndexView ()

@property (nonatomic, strong) CAShapeLayer *searchLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *subTextLayers;
@property (nonatomic, strong) UILabel *indicator;
@property (nonatomic, weak) UITableView *tableView;

// 触摸索引视图
@property (nonatomic, assign, getter=isTouchingIndexView) BOOL touchingIndexView;

/** 触感反馈 */
@property (nonatomic, strong) UIImpactFeedbackGenerator *generator NS_AVAILABLE_IOS(10_0);

@end

@implementation SCIndexView

#pragma mark - Life Cycle

- (instancetype)initWithTableView:(UITableView *)tableView configuration:(SCIndexViewConfiguration *)configuration
{
    if (self = [super initWithFrame:tableView.frame]) {
        _tableView = tableView;
        _currentSection = NSUIntegerMax;
        _configuration = configuration;
        _translucentForTableViewInNavigationBar = YES;
        
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = kSCIndexViewSpace;
    CGFloat margin = kSCIndexViewMargin;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (self.searchLayer) {
        self.searchLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, SCGetTextLayerCenterY(0, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        self.searchLayer.cornerRadius = self.configuration.indexItemHeight / 2;
        self.searchLayer.contentsScale = UIScreen.mainScreen.scale;
        self.searchLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
    }
    
    NSInteger deta = self.searchLayer ? 1 : 0;
    for (int i = 0; i < self.subTextLayers.count; i++) {
        CATextLayer *textLayer = self.subTextLayers[i];
        NSUInteger section = i + deta;
        textLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, SCGetTextLayerCenterY(section, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
    }
    [CATransaction commit];
}

#pragma mark - Public Methods

- (void)refreshCurrentSection {
    [self onActionWithScroll];
}

#pragma mark - 

- (void)configSubLayersAndSubviews
{
    BOOL hasSearchLayer = [self.dataSource.firstObject isEqualToString:UITableViewIndexSearch];
    NSUInteger deta = 0;
    if (hasSearchLayer) {
        self.searchLayer = [self createSearchLayer];
        [self.layer addSublayer:self.searchLayer];
        deta = 1;
    } else if (self.searchLayer) {
        [self.searchLayer removeFromSuperlayer];
        self.searchLayer = nil;
    }
    
    NSInteger countDifference = self.dataSource.count - deta - self.subTextLayers.count;
    if (countDifference > 0) {
        for (int i = 0; i < countDifference; i++) {
            CATextLayer *textLayer = [CATextLayer layer];
            [self.layer addSublayer:textLayer];
            [self.subTextLayers addObject:textLayer];
        }
    } else {
        for (int i = 0; i < -countDifference; i++) {
            CATextLayer *textLayer = self.subTextLayers.lastObject;
            [textLayer removeFromSuperlayer];
            [self.subTextLayers removeObject:textLayer];
        }
    }
    
    CGFloat space = kSCIndexViewSpace;
    CGFloat margin = kSCIndexViewMargin;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (hasSearchLayer) {
        self.searchLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, SCGetTextLayerCenterY(0, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        self.searchLayer.cornerRadius = self.configuration.indexItemHeight / 2;
        self.searchLayer.contentsScale = UIScreen.mainScreen.scale;
        self.searchLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
    }
    
    for (int i = 0; i < self.subTextLayers.count; i++) {
        CATextLayer *textLayer = self.subTextLayers[i];
        NSUInteger section = i + deta;
        textLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, SCGetTextLayerCenterY(section, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        textLayer.string = self.dataSource[section];
        textLayer.fontSize = self.configuration.indexItemHeight * 0.8;
        textLayer.cornerRadius = self.configuration.indexItemHeight / 2;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        textLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
        textLayer.foregroundColor = self.configuration.indexItemTextColor.CGColor;
    }
    [CATransaction commit];
    
    if (self.subTextLayers.count == 0) {
        self.currentSection = NSUIntegerMax;
    } else if (self.currentSection == NSUIntegerMax) {
        self.currentSection = self.searchLayer ? SCIndexViewSearchSection : 0;
    } else {
        self.currentSection = self.subTextLayers.count - 1;
    }
}

- (void)configCurrentSection
{
    NSInteger currentSection = SCIndexViewInvalidSection;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionOfIndexView:tableViewDidScroll:)]) {
        currentSection = [self.delegate sectionOfIndexView:self tableViewDidScroll:self.tableView];
        if ((currentSection >= 0 && currentSection != SCIndexViewInvalidSection)
            || currentSection == SCIndexViewSearchSection) {
            self.currentSection = currentSection;
            return;
        }
    }
    
    NSInteger firstVisibleSection = self.tableView.indexPathsForVisibleRows.firstObject.section;
    CGFloat insetTop = kSCIndexViewInsetTop;
    for (NSInteger section = firstVisibleSection; section < self.tableView.numberOfSections; section++) {
        CGRect sectionFrame = [self.tableView rectForSection:section];
        if (sectionFrame.origin.y + sectionFrame.size.height - self.tableView.contentOffset.y > insetTop) {
            currentSection = section;
            break;
        }
    }
    
    BOOL selectSearchLayer = NO;
    if (currentSection == 0 && self.searchLayer && currentSection < self.tableView.numberOfSections) {
        CGRect sectionFrame = [self.tableView rectForSection:currentSection];
        selectSearchLayer = (sectionFrame.origin.y - self.tableView.contentOffset.y - insetTop) > 0;
    }
    
    if (selectSearchLayer) {
        currentSection = SCIndexViewSearchSection;
    }
    else {
        currentSection = currentSection - self.startSection;
    }
    
    self.currentSection = currentSection;
}

#pragma mark - Event Response

- (void)onActionWithDidSelect
{
    if ((self.currentSection < 0 && self.currentSection != SCIndexViewSearchSection)
        || self.currentSection >= (NSInteger)self.subTextLayers.count) {
        return;
    }
    
    CGFloat insetTop = kSCIndexViewInsetTop;
    if (self.currentSection == SCIndexViewSearchSection) {
        [self.tableView setContentOffset:CGPointMake(0, -insetTop) animated:NO];
    } else {
        NSInteger currentSection = self.currentSection + self.startSection;
        if (currentSection >= 0 && currentSection < self.tableView.numberOfSections) {
            NSUInteger rowCountInSection = [self.tableView numberOfRowsInSection:currentSection];
            if (rowCountInSection > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:currentSection];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
    
    if (self.isTouchingIndexView) {
        if (@available(iOS 10.0, *)) {
            [self.generator prepare];
            [self.generator impactOccurred];
        }
    }
}

- (void)onActionWithScroll
{
    if (self.isTouchingIndexView) {
        // 当滑动tableView视图时，另一手指滑动索引视图，让tableView滑动失效
        self.tableView.panGestureRecognizer.enabled = NO;
        self.tableView.panGestureRecognizer.enabled = YES;
        
        return; // 当滑动索引视图时，tableView滚动不能影响索引位置
    }
    
    [self configCurrentSection];
}

#pragma mark - Display

- (UIBezierPath *)drawIndicatorPath
{
    CGFloat indicatorRadius = self.configuration.indicatorHeight / 2;
    CGFloat sinPI_4_Radius = sin(M_PI_4) * indicatorRadius;
    CGFloat margin = (sinPI_4_Radius * 2 - indicatorRadius);
    
    CGPoint startPoint = CGPointMake(margin + indicatorRadius + sinPI_4_Radius, indicatorRadius - sinPI_4_Radius);
    CGPoint trianglePoint = CGPointMake(4 * sinPI_4_Radius, indicatorRadius);
    CGPoint centerPoint = CGPointMake(margin + indicatorRadius, indicatorRadius);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addArcWithCenter:centerPoint radius:indicatorRadius startAngle:-M_PI_4 endAngle:M_PI_4 clockwise:NO];
    [bezierPath addLineToPoint:trianglePoint];
    [bezierPath addLineToPoint:startPoint];
    [bezierPath closePath];
    return bezierPath;
}

- (CAShapeLayer *)createSearchLayer
{
    CGFloat radius = self.configuration.indexItemHeight / 4;
    CGFloat margin = self.configuration.indexItemHeight / 4;
    CGFloat start = radius * 2.5 + margin;
    CGFloat end = radius + sin(M_PI_4) * radius + margin;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start, start)];
    [path addLineToPoint:CGPointMake(end, end)];
    [path addArcWithCenter:CGPointMake(radius + margin, radius + margin) radius:radius startAngle:M_PI_4 endAngle:2 * M_PI + M_PI_4 clockwise:YES];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = self.configuration.indexItemBackgroundColor.CGColor;
    layer.strokeColor = self.configuration.indexItemTextColor.CGColor;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = self.configuration.indexItemHeight / 12;
    layer.path = path.CGPath;
    return layer;
}

- (void)showIndicator:(BOOL)animated
{
    if (self.currentSection >= (NSInteger)self.subTextLayers.count) return;
    
    if (self.currentSection < 0) {
        if (self.currentSection == SCIndexViewSearchSection) {
            [self hideIndicator:animated];
        }
        return;
    }
    
    CATextLayer *textLayer = self.subTextLayers[self.currentSection];
    if (self.configuration.indexViewStyle == SCIndexViewStyleDefault) {
        self.indicator.center = CGPointMake(self.bounds.size.width - self.indicator.bounds.size.width / 2 - self.configuration.indicatorRightMargin, textLayer.position.y);
    } else {
        self.indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
    self.indicator.text = textLayer.string;
    
    if (animated) {
        self.indicator.alpha = 0;
        self.indicator.hidden = NO;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.indicator.alpha = 1;
        }];
    } else {
        self.indicator.alpha = 1;
        self.indicator.hidden = NO;
    }
}

- (void)hideIndicator:(BOOL)animated
{
    if (self.indicator.hidden) return;
    
    if (animated) {
        self.indicator.alpha = 1;
        self.indicator.hidden = NO;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.indicator.alpha = 0;
        } completion:^(BOOL finished) {
            self.indicator.alpha = 1;
            self.indicator.hidden = YES;
        }];
    } else {
        self.indicator.alpha = 1;
        self.indicator.hidden = YES;
    }
}

- (void)refreshTextLayer:(BOOL)selected
{
    if (self.currentSection < 0 || self.currentSection >= (NSInteger)self.subTextLayers.count) return;
    
    CATextLayer *textLayer = self.subTextLayers[self.currentSection];
    UIColor *backgroundColor, *foregroundColor;
    if (selected) {
        backgroundColor = self.configuration.indexItemSelectedBackgroundColor;
        foregroundColor = self.configuration.indexItemSelectedTextColor;
    } else {
        backgroundColor = self.configuration.indexItemBackgroundColor;
        foregroundColor = self.configuration.indexItemTextColor;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    textLayer.backgroundColor = backgroundColor.CGColor;
    textLayer.foregroundColor = foregroundColor.CGColor;
    [CATransaction commit];
}

#pragma mark - UITouch and UIEvent

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 当滑动索引视图时，防止其他手指去触发事件
    if (self.touchingIndexView) return YES;
    
    CALayer *firstLayer = self.searchLayer ?: self.subTextLayers.firstObject;
    if (!firstLayer) return NO;
    CALayer *lastLayer = self.subTextLayers.lastObject ?: self.searchLayer;
    if (!lastLayer) return NO;
    
    CGFloat space = self.configuration.indexItemRightMargin * 2;
    if (point.x > self.bounds.size.width - space - self.configuration.indexItemHeight
        && point.x <= self.bounds.size.width
        && point.y > CGRectGetMinY(firstLayer.frame) - space
        && point.y < CGRectGetMaxY(lastLayer.frame) + space) {
        return YES;
    }
    return NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = YES;
    CGPoint location = [touch locationInView:self];
    NSInteger currentPosition = SCPositionOfTextLayerInY(location.y, kSCIndexViewMargin, kSCIndexViewSpace);
    if (currentPosition < 0 || currentPosition >= (NSInteger)self.dataSource.count) return YES;
    
    NSInteger deta = self.searchLayer ? 1 : 0;
    NSInteger currentSection = currentPosition - deta;
    self.currentSection = currentSection;
    [self showIndicator:YES];
    [self onActionWithDidSelect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexView:didSelectAtSection:)]) {
        [self.delegate indexView:self didSelectAtSection:self.currentSection];
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = YES;
    CGPoint location = [touch locationInView:self];
    NSInteger currentPosition = SCPositionOfTextLayerInY(location.y, kSCIndexViewMargin, kSCIndexViewSpace);
    
    if (currentPosition < 0) {
        currentPosition = 0;
    } else if (currentPosition >= (NSInteger)self.dataSource.count) {
        currentPosition = self.dataSource.count - 1;
    }
    
    NSInteger deta = self.searchLayer ? 1 : 0;
    NSInteger currentSection = currentPosition - deta;
    if (currentSection == self.currentSection) return YES;
    
    self.currentSection = currentSection;
    [self showIndicator:NO];
    [self onActionWithDidSelect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexView:didSelectAtSection:)]) {
        [self.delegate indexView:self didSelectAtSection:self.currentSection];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = NO;
    NSInteger oldCurrentPosition = self.currentSection;
    [self refreshCurrentSection];
    if (oldCurrentPosition != self.currentSection) {
        [self showIndicator:NO];
    }
    [self hideIndicator:YES];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.touchingIndexView = NO;
    NSInteger oldCurrentPosition = self.currentSection;
    [self refreshCurrentSection];
    if (oldCurrentPosition != self.currentSection) {
        [self showIndicator:NO];
    }
    [self hideIndicator:YES];
}

#pragma mark - Getters and Setters

- (void)setDataSource:(NSArray<NSString *> *)dataSource
{
    if (_dataSource == dataSource) return;
    
    _dataSource = dataSource.copy;
    
    [self configSubLayersAndSubviews];
    [self configCurrentSection];
}

- (void)setCurrentSection:(NSInteger)currentSection
{
    if (currentSection == _currentSection) return;
    if ((currentSection < 0 && currentSection != SCIndexViewSearchSection)
        || currentSection >= (NSInteger)self.subTextLayers.count) {
        [self refreshTextLayer:NO];
        return;
    }
    
    [self refreshTextLayer:NO];
    _currentSection = currentSection;
    [self refreshTextLayer:YES];
}

- (void)setStartSection:(NSUInteger)startSection {
    if (_startSection == startSection) return;
    _startSection = startSection;
    [self configCurrentSection];
}

- (NSMutableArray *)subTextLayers
{
    if (!_subTextLayers) {
        _subTextLayers = [NSMutableArray array];
    }
    return _subTextLayers;
}

- (UILabel *)indicator
{
    if (!_indicator) {
        _indicator = [UILabel new];
        _indicator.layer.backgroundColor = self.configuration.indicatorBackgroundColor.CGColor;
        _indicator.textColor = self.configuration.indicatorTextColor;
        _indicator.font = self.configuration.indicatorTextFont;
        _indicator.textAlignment = NSTextAlignmentCenter;
        _indicator.hidden = YES;
        
        switch (self.configuration.indexViewStyle) {
            case SCIndexViewStyleDefault:
            {
                CGFloat indicatorRadius = self.configuration.indicatorHeight / 2;
                CGFloat sinPI_4_Radius = sin(M_PI_4) * indicatorRadius;
                _indicator.bounds = CGRectMake(0, 0, (4 * sinPI_4_Radius), 2 * indicatorRadius);
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.path = [self drawIndicatorPath].CGPath;
                _indicator.layer.mask = maskLayer;
            }
                break;
                
            case SCIndexViewStyleCenterToast:
            {
                _indicator.bounds = CGRectMake(0, 0, self.configuration.indicatorHeight, self.configuration.indicatorHeight);
                _indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
                _indicator.layer.cornerRadius = self.configuration.indicatorCornerRadius;
            }
                break;
                
            default:
                break;
        }
    }
    return _indicator;
}

- (UIImpactFeedbackGenerator *)generator {
    if (!_generator) {
        _generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    }
    return _generator;
}

@end
