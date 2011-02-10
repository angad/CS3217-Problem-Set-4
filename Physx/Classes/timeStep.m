//
//  timeStep.m
//  Physx
//
//  Created by Angad Singh on 2/7/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "timeStep.h"

@implementation timeStep 

//Accelerometer responder
//the view updates here
- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler 
{
	gravity = [[Vector2D alloc] initWith:aceler.x y:-aceler.y];

	allObjects = [[NSArray arrayWithObjects:redRect,greenRect,blueRect, yellowRect, purpleRect, pinkRect, nil] retain];
	walls = [[NSArray arrayWithObjects:topRect, rightRect, bottomRect, leftRect, nil]retain];
	int i,j;
	for (i=1; i<6; i++) {
		for (j=0; j<4; j++) {
			//[[walls objectAtIndex:j]colliding:[allObjects objectAtIndex:i]:gravity];
		}
		
		ObjectModel *temp = [allObjects objectAtIndex:i];
		[temp applyForce:[[Vector2D alloc] initWith:0.0 y:0.0] Gravity:gravity];
		NSLog(@"%f, %f obj type %i", [[temp position] x], [[temp position] y], [temp objType]);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"moveObject" object:temp];
	}
}

-(id)initWithViewController:(PhysxViewController*)vc{
	

	//Registering a notification for objectPositionChange
	[[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(move:) 
                                                 name:@"moveObject"
                                               object:nil];
	
	topRect = [[[ObjectModel alloc]initWithType:top 
										Mass:100.0 
							 MomentOfInertia:0.0 
									Position:[[Vector2D alloc] initWith:5.0 y:5.0]
									 Width:750 
									Height:10 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:[[Matrix2D alloc]initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0]
																		   :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
		   
	rightRect = [[[ObjectModel alloc]initWithType:right 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:750.0 y:5.0]
									 Width:10 
									Height:990 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:[[Matrix2D alloc]initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0]
																		   :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
				  
	bottomRect = [[[ObjectModel alloc]initWithType:bottom 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:5.0 y:990]
									 Width:750 
									Height:10 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:[[Matrix2D alloc]initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0]
																		   :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	
	leftRect = [[[ObjectModel alloc]initWithType:left 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:5.0 y:5.0]
									 Width:10 
									Height:750 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:[[Matrix2D alloc]initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0]
																		   :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	
	
	
	redRect = [[[ObjectModel alloc] initWithType:red
										   Mass:2.0 
								MomentOfInertia:0.0 
									   Position:[[Vector2D alloc] initWith:80.0 y:40.0 ] 
										  Width:40.0 
										 Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];

	
	greenRect = [[[ObjectModel alloc] initWithType:green
											 Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:100.0 y:100.0 ] 
										  Width:40.0 
										 Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	
	blueRect = [[[ObjectModel alloc]initWithType:blue
										   Mass:2.0 
								MomentOfInertia:2.0 
									   Position:[[Vector2D alloc] initWith:140.0 y:200.0 ] 
											 Width:40.0 
											Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	
	yellowRect = [[[ObjectModel alloc]initWithType:yellow
											 Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:240.0 y:300.0 ] 
										   Width:40.0 
										  Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	purpleRect = [[[ObjectModel alloc] initWithType:purple
											  Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:200.0 y:500.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	pinkRect = [[[ObjectModel alloc]initWithType:pink
										   Mass:2.0 
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:300.0 y:700.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:[[Matrix2D alloc] initWithVectors:[[Vector2D alloc]initWith:0.0 y:0.0] 
																				 :[[Vector2D alloc]initWith:0.0 y:0.0]]]retain];
	
	
	return self;
	
}


@end
