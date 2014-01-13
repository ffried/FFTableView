//
//  FFExpandableTableViewCell.h
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

#import <UIKit/UIKit.h>

@interface FFExpandableTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *collapsedView; // Always displayed
@property (nonatomic, strong) IBOutlet UIView *expandedView; // Displayed below collapsed view when expanded

// Always called, no matter if you use XIBs or code. Requires you to call super
- (void)initialize;

// It's important to call super at the beginning and [self layoutIfNeeded]; at the and of the implenentation in a subclass
- (void)configureWithObject:(id)object expanded:(BOOL)expanded;

@end
