//
//  ElementManager.m
//  thc-ipad
//
//  Created by Vanger on 15.11.10.
//  Copyright 2010 Magic Ink. All rights reserved.
//

#import "ElementManager.h"


@implementation ElementManager

static ElementManager *sharedInstance;

+ (void)initSharedInstanceWithContext:(NSManagedObjectContext *)context {
	sharedInstance = [ElementManager alloc];
	sharedInstance.managedObjectContext = context;
}

+ (ElementManager *) sharedInstance {
    return sharedInstance;
}

- (Element *)newEmptyElement {
	Element * element = (Element *) [NSEntityDescription 
													 insertNewObjectForEntityForName:kElemntEntityName 
													 inManagedObjectContext:self.managedObjectContext];
	[element retain];
	return element;
}

- (NSMutableArray *)copyElementsArray {
	// Fetch
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:kElemntEntityName 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
			// Handle the error.
	}
	[request release];
	
	return mutableFetchResults;
}

- (Element *)newElementWithText:(NSString *)text atPoint:(CGPoint)point {
	Element *element = [self newEmptyElement];
	element.text = text;
	element.x = [NSNumber numberWithInt:(int)point.x];
	element.y = [NSNumber numberWithInt:(int)point.y];
	return element;
}

@end