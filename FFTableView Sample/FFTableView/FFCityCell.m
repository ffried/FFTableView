//
//  FFCityCell.m
//  FFTableView Sample
//
//  Created by Florian Friedrich on 9.1.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFCityCell.h"
#import "City.h"

@interface FFCityCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rankLabel;

- (void)setupCollapsedView;
- (void)setupExpandedView;

@end


@implementation FFCityCell

- (void)initialize
{
    [super initialize];
    [self setupCollapsedView];
    [self setupExpandedView];
}

#pragma mark - View setup
- (void)setupCollapsedView
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.collapsedView addSubview:self.nameLabel];
    NSDictionary *views = @{@"name": self.nameLabel};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[name]-|" options:kNilOptions metrics:nil views:views];
    [self.collapsedView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[name]-|" options:kNilOptions metrics:nil views:views];
    [self.collapsedView addConstraints:constraints];
    
//    self.collapsedView.backgroundColor = [UIColor greenColor];
}

- (void)setupExpandedView
{
    self.rankLabel = [[UILabel alloc] init];
    self.rankLabel.backgroundColor = [UIColor clearColor];
    self.rankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.expandedView addSubview:self.rankLabel];
    NSDictionary *views = @{@"rank": self.rankLabel};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[rank]-|" options:kNilOptions metrics:nil views:views];
    [self.expandedView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[rank]-|" options:kNilOptions metrics:nil views:views];
    [self.expandedView addConstraints:constraints];
    
//    self.expandedView.backgroundColor = [UIColor redColor];
}

#pragma mark - Cell configuration
- (void)configureWithObject:(City *)object expanded:(BOOL)expanded
{
    [super configureWithObject:object expanded:expanded];
    self.nameLabel.text = object.name;
    self.rankLabel.text = object.rank;
    [self layoutIfNeeded];
}

@end
