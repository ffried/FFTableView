//
//  FFExpandableTableViewCell.m
//
//  Created by Florian Friedrich on 8.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFExpandableTableViewCell.h"

@interface FFExpandableTableViewCell ()

@property (nonatomic, strong) NSLayoutConstraint *interConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

- (void)setBottomConstraintWithView:(UIView *)view;

@end


@implementation FFExpandableTableViewCell
@synthesize collapsedView = _collapsedView;
@synthesize expandedView = _expandedView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) [self initialize];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    // Also sets the constraints, see setters
    self.collapsedView = [[UIView alloc] init];
    self.expandedView = [[UIView alloc] init];
}

#pragma mark - Configuration
- (void)configureWithObject:(id)object expanded:(BOOL)expanded
{
//    [self layoutIfNeeded];
    [self setBottomConstraintWithView:((expanded) ? self.expandedView : self.collapsedView)];
}

#pragma mark - Properties
- (void)setCollapsedView:(UIView *)collapsedView
{
    if (collapsedView != _collapsedView) {
        [_collapsedView removeFromSuperview];
        _collapsedView = collapsedView;
        _collapsedView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_collapsedView];
        
        NSDictionary *viewsDictionary = @{@"collapsedView": _collapsedView};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collapsedView]|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:viewsDictionary];
        [self.contentView addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collapsedView]"
                                                              options:kNilOptions
                                                              metrics:nil
                                                                views:viewsDictionary];
        [self.contentView addConstraints:constraints];
        
        if (self.expandedView && !self.interConstraint) [self setupInterConstraint];
        
        [self setBottomConstraintWithView:_collapsedView];
    }
}

- (void)setExpandedView:(UIView *)expandedView
{
    if (expandedView != _expandedView) {
        [_expandedView removeFromSuperview];
        _expandedView = expandedView;
        _expandedView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_expandedView];
        
        NSDictionary *viewsDictionary = @{@"expandedView": _expandedView};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[expandedView]|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:viewsDictionary];
        [self.contentView addConstraints:constraints];
        
        
        if (self.collapsedView && !self.interConstraint) [self setupInterConstraint];
        
        [self setBottomConstraintWithView:_expandedView];
    }
}

#pragma mark - Helpers
- (void)setBottomConstraintWithView:(UIView *)view
{
    if (self.bottomConstraint != nil) [self.contentView removeConstraint:self.bottomConstraint];
    
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self.contentView addConstraint:self.bottomConstraint];
}

- (void)setupInterConstraint
{
    if (self.interConstraint != nil) [self.contentView removeConstraint:self.interConstraint];
    
    self.interConstraint = [NSLayoutConstraint constraintWithItem:self.collapsedView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.expandedView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self.contentView addConstraint:self.interConstraint];
}

@end
