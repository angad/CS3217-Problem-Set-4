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
	walls = [[NSArray arrayWithObjects:topRect, rightRect, bottomRect, leftRect, nil] retain];
	
	int i,j;
	for (i=0; i<6; i++) {
		[[allObjects objectAtIndex:i] applyForce:[[Vector2D alloc] initWith:0.0 y:0.0] Gravity:gravity];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"moveObject" object:[allObjects objectAtIndex:i]];
/*
		for (j=0; j<6; j++)
		{
			if (j>=4) {
				if (i!=j) 
				{
					[[allObjects objectAtIndex:i] colliding: [allObjects objectAtIndex:j]:gravity];
				}
			}
			else if (j<4)
			{
				[[walls objectAtIndex:j]colliding:[allObjects objectAtIndex:i]:gravity];
				if (i!=j) 
				{
					[[allObjects objectAtIndex:i] colliding: [allObjects objectAtIndex:j]:gravity];
				}
			}
		}
 */
		for (j=0; j<[allObjects count]; j++) {
			if (i!=j) {
				[[allObjects objectAtIndex:j] colliding:[allObjects objectAtIndex:i]:gravity];
			}
		}
		
		for (j=0; j<[walls count]; j++) {
			[[walls objectAtIndex:j]colliding:[allObjects objectAtIndex:i]:gravity];
		}
	}
}

-(id)initWithViewController:(PhysxViewController*)vc{
	

	//Registering a notification for objectPositionChange
	[[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(move:) 
                                                 name:@"moveObject"
                                               object:nil];
	
	topRect = [[ObjectModel alloc]initWithType:top 
										Mass:100.0 
							 MomentOfInertia:0.0 
									Position:[[Vector2D alloc] initWith:380.0 y:5.0]
									 Width:750 
									Height:10 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
		   
	rightRect = [[ObjectModel alloc]initWithType:right 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:750.0 y:495.0]
									 Width:10 
									Height:990 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0 ];
				  
	bottomRect = [[ObjectModel alloc]initWithType:bottom 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:380.0 y:990.0]
									 Width:750 
									Height:10 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
	
	leftRect = [[ObjectModel alloc]initWithType:left 
									  Mass:100.0 
						   MomentOfInertia:0.0 
								  Position:[[Vector2D alloc] initWith:5.0 y:495.0]
									 Width:10 
									Height:750 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
	
	redRect = [[ObjectModel alloc] initWithType:red
										   Mass:2.0 
								MomentOfInertia:0.0 
									   Position:[[Vector2D alloc] initWith:300.0 y:100.0 ] 
										  Width:40.0 
										 Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];

	
	greenRect = [[ObjectModel alloc] initWithType:green
											 Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:100.0 y:100.0 ] 
										  Width:40.0 
										 Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	blueRect = [[ObjectModel alloc]initWithType:blue
										   Mass:2.0 
								MomentOfInertia:0.0 
									   Position:[[Vector2D alloc] initWith:140.0 y:200.0 ] 
											 Width:40.0 
											Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	yellowRect = [[ObjectModel alloc]initWithType:yellow
											 Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:240.0 y:300.0 ] 
										   Width:40.0 
										  Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];

	purpleRect = [[ObjectModel alloc] initWithType:purple
											  Mass:2.0
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:200.0 y:500.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	pinkRect = [[ObjectModel alloc]initWithType:pink
										   Mass:2.0 
								MomentOfInertia:0.0
									   Position:[[Vector2D alloc] initWith:300.0 y:700.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	return self;
}


@end
