//
//  ObjectModel.h
//  Physx
//
//  Created by Angad Singh on 2/7/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#import "Matrix2D.h"

#define DELTA 1/60

@interface ObjectModel : NSObject {
}

typedef enum
{
	red = 1,
	green = 2,
	blue = 3,
	yellow = 4,
	purple = 5,
	pink = 6,
	top = 7,
	right = 8,
	bottom = 9,
	left = 10,

} ObjectType;


@property (readonly) double mass;
@property (readonly) double momentOfInertia;
@property (readonly) Vector2D *position;
@property (readonly) double width;
@property (readonly) double height;
@property (readonly) Vector2D *velocity;
@property (readonly) Matrix2D *angularVelocity;
@property (readonly) ObjectType objType;
@property (readonly) double rotation;
@property (readonly) Matrix2D *rotationM;
@property (readonly) CGPoint center;
@property (readonly) Vector2D *grav;


-(id)initWithType:(ObjectType)t Mass:(double)m MomentOfInertia:(double)i Position:(Vector2D *)p Width:(double)w Height:(double)h Velocity:(Vector2D *)v AngularVelocity:(Matrix2D *)av;
-(void)applyForce:(Vector2D *)f Gravity:(Vector2D *)g;

@end
