//
//  FFExpandableTableViewCell.m
//
//  Created by Florian Friedrich on 8.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "FFExpandableTableViewCell.h"

@interface FFExpandableTableViewCell ()

@property (nonatomic, weak) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, weak) NSLayoutConstraint *interConstraint;

@property (nonatomic) BOOL expanded;

- (void)setupTheCollapsedView;
- (void)setupTheExpandedView;

- (void)setupBottomConstraintExpanded:(BOOL)expanded;
- (void)setupInterConstraint;

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
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contentView.clipsToBounds = YES;
    
    // Also sets up the constraints, see setters
    self.collapsedView = [[UIView alloc] init];
    self.expandedView = [[UIView alloc] init];
    self.expanded = YES;
}

#pragma mark - Configuration
- (void)configureWithObject:(id)object expanded:(BOOL)expanded
{
    if (self.expanded != expanded) {
        self.expanded = expanded;
        if (expanded) {
            [self setupTheExpandedView];
        } else {
            [self.expandedView removeFromSuperview];
        }
        [self setupBottomConstraintExpanded:expanded];
        [self.contentView setNeedsLayout];
    }
}

#pragma mark - Properties
- (void)setCollapsedView:(UIView *)collapsedView
{
    if (collapsedView != _collapsedView) {
        [_collapsedView removeFromSuperview];
        _collapsedView = collapsedView;
        [self setupTheCollapsedView];
        [self setupBottomConstraintExpanded:NO];
    }
}

- (void)setExpandedView:(UIView *)expandedView
{
    if (expandedView != _expandedView) {
        [_expandedView removeFromSuperview];
        _expandedView = expandedView;
        [self setupTheExpandedView];
        [self setupBottomConstraintExpanded:YES];
    }
}

#pragma mark - Setup views
- (void)setupTheCollapsedView
{
    self.collapsedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.collapsedView];
    
    NSDictionary *viewsDictionary = @{@"collapsedView": self.collapsedView};
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
    
    [self setupInterConstraint];
}

- (void)setupTheExpandedView
{
    self.expandedView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.expandedView];
    
    NSDictionary *viewsDictionary = @{@"expandedView": self.expandedView};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[expandedView]|"
                                                                   options:kNilOptions
                                                                   metrics:nil
                                                                     views:viewsDictionary];
    [self.contentView addConstraints:constraints];
    
    [self setupInterConstraint];
}

#pragma mark - Helpers
- (void)setupBottomConstraintExpanded:(BOOL)expanded
{
    if (self.bottomConstraint != nil) [self.contentView removeConstraint:self.bottomConstraint];
    
    UIView *firstView = (expanded) ? self.expandedView : self.collapsedView;
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:firstView
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
