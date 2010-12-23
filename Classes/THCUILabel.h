//
//  THCElementLabel.h
//  thc-ipad
//
//  Created by Vanger on 15.11.10.
//  Copyright 2010 Magic Ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElementInterface.h"
#import "THCUIComponentWithElementProtocol.h"
#import "THCUITextView.h"
#import "THCUIComponentAbstract.h"

extern NSString * const kTypeLabel;
extern const CGFloat kMinimalLabelHeight;

@interface THCUILabel : THCUIComponentAbstract {
	id<UITextViewDelegate> textViewDelegate;
	UILabel *label;
}

@property (nonatomic, retain) id<UITextViewDelegate> textViewDelegate;
@property (nonatomic, retain) UILabel *label;

+ (THCUILabel *)createInView:(UIView *)aView withElement:(id<ElementInterface>)newElement withDelegate:(id<UITextViewDelegate>)delegate;
+ (THCUILabel *)addLabel:(THCUILabel *)label toView:(UIView *)aView withElement:(id<ElementInterface>)newElement withDelegate:(id<UITextViewDelegate>)delegate;

+ (UITapGestureRecognizer *)newGestureForConvertingToTextEdit;
+ (UITapGestureRecognizer *)newGestureForConvertingToTODO;

+ (CGRect)frameForLabelWithElement:(id<ElementInterface>)element;

@end
