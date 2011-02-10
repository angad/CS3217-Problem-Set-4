//
//  timeStep.h
//  Physx
//
//  Created by Angad Singh on 2/7/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysxViewController.h"
#import "ObjectModel.h"
#import "Vector2D.h"
#import "Matrix2D.h"

@interface timeStep : NSObject {
	
	Vector2D *gravity;
	
	ObjectModel *redRect;
	ObjectModel *greenRect;
	ObjectModel *yellowRect;
	ObjectModel *pinkRect;
	ObjectModel *blueRect;
	ObjectModel *purpleRect;
	ObjectModel *right;
	ObjectModel *left;
	ObjectModel *top;
	ObjectModel *bottom;
	
	NSArray *allObjects;
	NSArray *walls;
}


- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler;
//- (id)initWithViewController:(PhysxViewController*)vc;
@end
