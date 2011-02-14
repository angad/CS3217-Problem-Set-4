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
	gravity = [[Vector2D alloc] initWith:aceler.x*300 y:-aceler.y*300];

	allObjects = [[NSArray arrayWithObjects:redRect,greenRect,blueRect, yellowRect, purpleRect, pinkRect, nil] retain];
	walls = [[NSArray arrayWithObjects:topRect, rightRect, bottomRect, leftRect, nil] retain];
	NSArray *contacts;

	int i,j;
	for (i=0; i<6; i++) {
		[[allObjects objectAtIndex:i] applyForce:[[Vector2D alloc] initWith:0.0 y:0.0] Gravity:gravity];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"moveObject" object:[allObjects objectAtIndex:i]];
		if (i<4) {
		//	[[NSNotificationCenter defaultCenter] postNotificationName:@"moveObject" object:[walls objectAtIndex:i]];
		}

		for (j=0; j<6; j++)
		{
			if (j>=4) {
				if (i!=j) 
				{
					contacts = [[allObjects objectAtIndex:i] colliding:[allObjects objectAtIndex:j]:gravity];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"showCollision" object:contacts];				
				}
			}
			else if (j<4)
			{
				contacts = [[walls objectAtIndex:j]colliding:[allObjects objectAtIndex:i]:gravity];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"showCollision" object:contacts];

				if (i!=j) 
				{
					contacts = [[allObjects objectAtIndex:i] colliding:[allObjects objectAtIndex:j]:gravity];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"showCollision" object:contacts];				
				}
			}
		}
	}
}

-(id)initWithViewController:(PhysxViewController*)vc{
	

	//Registering a notification for objectPositionChange
	[[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(move:) 
                                                 name:@"moveObject"
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(showCollision:) 
                                                 name:@"showCollision"
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:vc
											selector:@selector(drawWalls:)
												 name:@"drawWalls" object:nil];
	
	topRect = [[ObjectModel alloc]initWithType:top 
										Mass:100.0 
							 MomentOfInertia:0.0
									   Angle:(double)0.0
									Position:[[Vector2D alloc] initWith:380.0 y:25.0]
									 Width:1000 
									Height:30 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
		   
	rightRect = [[ObjectModel alloc]initWithType:right 
									  Mass:100.0 
						   MomentOfInertia:0.0
										   Angle:(double)0.0
								  Position:[[Vector2D alloc] initWith:740.0 y:495.0]
									 Width:30 
									Height:1000 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0 ];
				  
	bottomRect = [[ObjectModel alloc]initWithType:bottom 
									  Mass:100.0 
						   MomentOfInertia:0.0 
											Angle:(double)0.0
								  Position:[[Vector2D alloc] initWith:380.0 y:980.0]
									 Width:1000 
									Height:30 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
	
	leftRect = [[ObjectModel alloc]initWithType:left 
									  Mass:100.0 
						   MomentOfInertia:0.0 
										  Angle:(double)0.0
								  Position:[[Vector2D alloc] initWith:15.0 y:500.0]
									 Width:30 
									Height:1000 
								  Velocity:[[Vector2D alloc]initWith:0.0 y:0.0]
						   AngularVelocity:0];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"drawWalls" object:topRect];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"drawWalls" object:rightRect];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"drawWalls" object:bottomRect];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"drawWalls" object:leftRect];


	
	redRect = [[ObjectModel alloc] initWithType:red
										   Mass:5.0 
								MomentOfInertia:0.0 
										  Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:250.0 y:100.0 ] 
										  Width:300.0 
										 Height:120.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];

	
	greenRect = [[ObjectModel alloc] initWithType:green
											 Mass:2.0
								MomentOfInertia:0.0
											Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:100.0 y:100.0 ] 
										  Width:40.0 
										 Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	blueRect = [[ObjectModel alloc]initWithType:blue
										   Mass:2.0 
								MomentOfInertia:0.0 
										  Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:140.0 y:200.0 ] 
											 Width:40.0 
											Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	yellowRect = [[ObjectModel alloc]initWithType:yellow
											 Mass:2.0
								MomentOfInertia:0.0
											Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:240.0 y:300.0 ] 
										   Width:40.0 
										  Height:80.0 
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];

	purpleRect = [[ObjectModel alloc] initWithType:purple
											  Mass:2.0
								MomentOfInertia:0.0
											 Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:200.0 y:500.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	
	pinkRect = [[ObjectModel alloc]initWithType:pink
										   Mass:2.0 
								MomentOfInertia:0.0
										  Angle:(double)0.0
									   Position:[[Vector2D alloc] initWith:300.0 y:700.0 ] 
										  Width:40.0 
										 Height:80.0
									   Velocity:[[Vector2D alloc]initWith:0.0 y:0.0] 
								AngularVelocity:0];
	return self;
}

-(void)dealloc{
	[super dealloc];
	[allObjects release];
	[walls release];
}

@end
