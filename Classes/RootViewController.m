    //
//  RootViewController.m
//  thc-ipad
//
//  Created by Dmitry Volkov on 12.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "THCColors.h"
#import "THCFonts.h"

@implementation RootViewController

@synthesize textNotes;
@synthesize scrollView;

const CGFloat kTextAndLabelXDifference = 8;
const CGFloat kTextAndLabelYDifference = 8;
const CGFloat kTextNoteWidth = 150;
const CGFloat kTextNoteHeight = 100;
const CGFloat kTextNoteHeightMax = 9999;

- (void)viewDidLoad {
    [super viewDidLoad];

	textNotes = [[NSMutableArray alloc] init];

	UITapGestureRecognizer *doubleTap = [self newDoubleTapGestureForSpace];
	[self.scrollView addGestureRecognizer:doubleTap];
	[doubleTap release];
	
	UIPanGestureRecognizer *panGesture = [self newPanGestureRecognizerForSpace];
	[self.scrollView addGestureRecognizer:panGesture];
	[panGesture release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[textNotes release];
	[scrollView release];
    [super dealloc];
}

#pragma mark Сreation of text boxes and labels

- (UITextView *)addTextViewWithRect:(CGRect)rect withText:(NSString *)text toView:(UIView *)aView {
	UITextView *textView = [[UITextView alloc] init];
	textView.contentInset = UIEdgeInsetsZero;
	textView.text = text;
	textView.delegate = self;
	textView.backgroundColor = [UIColor colorForTextNoteBackground];
	textView.textColor = [UIColor whiteColor];
	textView.font = [UIFont fontForTextNote];
	textView.editable = YES;
	textView.scrollEnabled = YES;
	[aView addSubview:textView];
	textView.frame = rect;
	[textView release];

	[textView becomeFirstResponder];

	return textView;
}

- (UILabel *)addTextNoteLabelAtPoint:(CGPoint)point withText:(NSString *)text toView:(UIView *)aView andToArray:(NSMutableArray *)anArray{
	CGSize size = [text sizeWithFont:[UIFont fontForTextNote] constrainedToSize:CGSizeMake(kTextNoteWidth, kTextNoteHeightMax)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, kTextNoteWidth, size.height)];
	label.userInteractionEnabled = YES;
	label.numberOfLines = 0;
	label.text = text;
	label.backgroundColor = [UIColor colorForTextNoteBackground];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont fontForTextNote];
	[aView addSubview:label];
	[anArray addObject:label];
	[label release];
	return label;
}

- (void)removeFromSuperviewLabel:(UILabel *)label andFromArray:(NSMutableArray *)array {
	[label removeFromSuperview];
	[array removeObject:label];
}

#pragma mark TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	// Create new UILabel
	CGPoint pointForLabel = CGPointMake(textView.frame.origin.x + kTextAndLabelXDifference,
								textView.frame.origin.y + kTextAndLabelYDifference);
	UILabel *label = [self addTextNoteLabelAtPoint:pointForLabel
										  withText:textView.text
											toView:self.scrollView 
										andToArray:textNotes];

	UITapGestureRecognizer *doubleTap = [self newDoubleTapGestureForLabel];
	[label addGestureRecognizer:doubleTap];
	[doubleTap release];
	
	[textView removeFromSuperview];
}

#pragma mark Label gestures

- (UITapGestureRecognizer *)newDoubleTapGestureForLabel {
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelDoubleTapped:)];
	doubleTap.numberOfTapsRequired = 2;
	return doubleTap;
}

- (void)labelDoubleTapped:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		UILabel *label = (UILabel *)gesture.view;
		[self removeFromSuperviewLabel:(UILabel *)gesture.view andFromArray:textNotes];

		CGRect textViewRect = CGRectMake(label.frame.origin.x - kTextAndLabelXDifference,
										 label.frame.origin.y - kTextAndLabelYDifference,
										 kTextNoteWidth,
										 kTextNoteHeight);

		[self addTextViewWithRect:textViewRect withText:label.text toView:self.scrollView];
	}
}

#pragma mark Space gestures

- (UITapGestureRecognizer *)newDoubleTapGestureForSpace {
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self 
																				action:@selector(spaceDoubleTapped:)];
	doubleTap.numberOfTapsRequired = 2;
	return doubleTap;
}

- (void)spaceDoubleTapped:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		CGPoint location = [gesture locationInView:self.view];
		CGRect textViewRect = CGRectMake(location.x, location.y, kTextNoteWidth, kTextNoteHeight);
		[self addTextViewWithRect:textViewRect withText:@"" toView:self.scrollView];
	}
}

- (UIPanGestureRecognizer *)newPanGestureRecognizerForSpace {
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self 
																				 action:@selector(spaceDraggedAndMoveLabels:)];
	return panGesture;
}

/*
- (void)spaceDragged:(UIPanGestureRecognizer *)panGesture {
	if (panGesture.state != UIGestureRecognizerStateEnded)
		return;
	
	CGPoint diff = [panGesture velocityInView:self.view];
	
	CGPoint offset = self.scrollView.contentOffset;

	offset.x = offset.x - diff.x;
	offset.y = offset.y - diff.y;
	
		
	[self.scrollView setContentOffset:offset animated:YES];
}
*/


- (void)spaceDraggedAndMoveLabels:(UIPanGestureRecognizer *)panGesture {
	CGPoint diff = [panGesture velocityInView:self.view];//[panGesture translationInView:self.view];
	for (UILabel *label in textNotes) {
		CGPoint oldPoint = label.frame.origin;
		
		CGRect labelPosition = label.frame;
		labelPosition.origin.x = oldPoint.x + diff.x;
		labelPosition.origin.y = oldPoint.y + diff.y;
		
		label.frame = labelPosition;
	}
}

#pragma mark scrolling view



@end
