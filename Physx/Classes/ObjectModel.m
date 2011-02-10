//
//  ObjectModel.m
//  Physx
//
//  Created by Angad Singh on 2/7/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ObjectModel.h"


@implementation ObjectModel

@synthesize mass, momentOfInertia, position, width, height, velocity, angularVelocity, objType, rotation, rotationM, center, grav;


-(id)initWithType:(ObjectType)t Mass:(double)m MomentOfInertia:(double)i Position:(Vector2D*)p Width:(double)w Height:(double)h Velocity:(Vector2D*)v AngularVelocity:(Matrix2D*)av
{
	width = w;
	height = h;
	mass = m;
	//momentOfInertia = i;
	position = p;
	velocity = v;
	angularVelocity = av;
	objType = t;
	rotation = 0;
	momentOfInertia = (width*width + height*height)/12.0;
	center = CGPointMake(([position x] + width)/2.0, ([position y] + height)/2.0);
	rotationM = [[Matrix2D matrixWithValues:cos(rotation) and:sin(rotation) and:-sin(rotation) and:cos(rotation)] retain];
	grav = [[Vector2D vectorWith:0.0 y:0.0] retain];
	
	return self;
}

-(void)setVelocity:(Vector2D*)v
{
	velocity = v;
	[velocity retain];
	//NSLog(@"%f, %f", [velocity x], [velocity y]);
}

-(void)setAngularVelocity:(Matrix2D*)a
{
	angularVelocity = a;
}

-(void)setPosition:(Vector2D*)p
{
	position = p;
	[position retain];
}

-(void)applyForce:(Vector2D*)f Gravity:(Vector2D*)g
{	
	//tested - works
	if ((g.x<0 && [self grav].x>0) || (g.x>0 && [self grav].x<0)) {
		[self setVelocity: [Vector2D vectorWith:velocity.x/2 y:velocity.y]];
	}
	
	if((g.y<0 && [self grav].y>0) || (g.y>0 && [self grav].y<0)){
		[self setVelocity: [Vector2D vectorWith:velocity.x y:velocity.y/2]];
	}
	
	[self setVelocity: [velocity add:([[g add:[f multiply:(1/mass)]] multiply:(0.016)])]];
	[self setPosition: ([position add:[velocity multiply:2]])];
	grav = g;
}

-(void)applyTorque:(Matrix2D*)t
{
	//not tested (!)
	[self setAngularVelocity:[angularVelocity add:[[t multiplyScalar:(1/momentOfInertia)]multiplyScalar:(0.016)]]];
}

-(BOOL)colliding:(ObjectModel*)shape{
	
	//shape = a
	//self = b
	
	Vector2D *ha;
	Vector2D *hb;
	ha = [Vector2D vectorWith:[shape width]/2 y:[shape height]/2];
	hb = [Vector2D vectorWith:[self width]/2 y:[self height]/2];
		
	Vector2D *d;
	d = [[self position] subtract:[shape position]];
	
	Vector2D *da;
	da = [[[shape rotationM]transpose] multiplyVector:d];
	
	Vector2D *db;
	db = [[[self rotationM]transpose] multiplyVector:d];
	
	Matrix2D *c;
	c = [[[shape rotationM]transpose] multiply:[self rotationM]];
	
	
	Vector2D *fa;
	Vector2D *fb;
	Vector2D *chb;
	Vector2D *ctha;
	
	chb = [[c abs] multiplyVector:hb];
	ctha = [[[c transpose] abs] multiplyVector:ha];
	
	fa = [[[da abs] subtract:ha] subtract:chb];
	fb = [[[db abs] subtract:hb] subtract:ctha];
	
	NSArray *ij = [NSArray arrayWithObjects:
				   [NSNumber numberWithDouble:fa.x],
				   [NSNumber numberWithDouble:fa.y],
				   [NSNumber numberWithDouble:fb.x],
				   [NSNumber numberWithDouble:fb.y], nil];
	
	int i,j,pos;
	double small;
	
	for (i=0; i<4; i++) {
		if ([[ij objectAtIndex:i] doubleValue] > 0) {
			NSLog(@"%i and %i Not Colliding", [self objType], [shape objType]);
			return false;
		}
	}
	
	
	for (i=0; i<4; i++) {
		for (j=0; j<4; j++) {
			if ([ij objectAtIndex:i]  >  [ij objectAtIndex:j]  ) 
			{
				small = (double)[[ij objectAtIndex:i] doubleValue];
				pos = i;
			}
		}
	}
	
	//NSLog(@"%f",small);

	Vector2D *n;
	Vector2D *nf, *ns;
	Vector2D *ni, *p, *h;
	Matrix2D *r;
	double df, ds, dneg, dpos;
	//df - distance between world origin and reference edge

	switch (pos) {
		case 0:
			if (da.x > 0) //rectangle B is on the right hand side of rectangle A in Ra.
			{
				//set E1 of A as reference edge
				n = [[shape rotationM] col1];
			}
			else //rectangle B is on the left hand side of rectangle A in Ra.
			{
				//set E3 of A as reference edge
				n = [[[shape rotationM] col1] negate];
			}
			
			nf = n;
			df = [[shape position] dot:nf] + ha.x;
			ns = [[shape rotationM] col2];
			ds = [[shape position] dot:ns];
			dneg = ha.y - ds;
			dpos = ha.y + ds;
			
			//incident edge
			ni = [[[[self rotationM]transpose] multiplyVector:nf] negate];
			p = [self position];
			r = [self rotationM];
			h = hb;
			
			break;
		
		case 1:
			if (da.y > 0) //rectangle B is on top of rectangle A in Ra.
			{
				//set E4 of A as reference edge
				n = [[shape rotationM] col2];
			}
			else //rectangle B is on bottom of rectangle A in Ra.
			{
				//set E2 of A as reference edge
				n = [[[shape rotationM] col2] negate];
			}
			
			nf = n;
			df = [[shape position] dot:nf] + ha.y;
			ns = [[shape rotationM] col1];
			ds = [[shape position] dot:ns];
			dneg = ha.x - ds;
			dpos = ha.x + ds;
			
			//incident edge
			ni = [[[[self rotationM]transpose] multiplyVector:nf] negate];
			p = [self position];
			r = [self rotationM];
			h = hb;
			
			break;
		case 2:
			if (db.x > 0) //rectangle A is on the right hand side of rectangle B in Rb.
			{
				//set E1 of B as reference edge
				n = [[self rotationM] col1];
			}
			else //rectangle A is on the left hand side of rectangle B in Rb.
			{
				//set E3 of B as reference edge
				n = [[[self rotationM] col1] negate];
			}
			
			nf = [n negate];
			df = [[self position] dot:nf] + hb.x;
			ns = [[self rotationM] col2];
			ds = [[self position] dot:ns];
			dneg = hb.y - ds;
			dpos = hb.y + ds;
			
			//incident edge
			ni = [[[[shape rotationM]transpose] multiplyVector:nf]negate];
			p = [shape position];
			r = [shape rotationM];
			h = ha;
			
			break;
		case 3:
			if (db.x > 0) //rectangle A is on the top of rectangle B in Rb.
			{
				//set E4 of B as reference edge
				n = [[self rotationM] col2];
			}
			else //rectangle A is on the bottom of rectangle B in Rb.
			{
				//set E2 of B as reference edge
				n = [[[self rotationM] col2]negate];
			}
			
			nf = [n negate];
			df = [[self position] dot:nf] + hb.y;
			ns = [[self rotationM] col1];
			ds = [[self position] dot:ns];
			dneg = hb.x - ds;
			dpos = hb.x + ds;
			
			//incident edge
			ni = [[[[shape rotationM]transpose] multiplyVector:nf]negate];
			p = [shape position];
			r = [shape rotationM];
			h = ha;
			
			break;
		default:
			break;
	}
	
	
	Vector2D *v1, *v2;	
	//incident edge with vertices v1 and v2
	if ([[ni abs] x] > [[ni abs] y] && [ni x] > 0) {
		v1 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
		v2 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
	}
	
	if ([[ni abs] x] > [[ni abs] y] && [ni x] <=0) {
		v1 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
		v2 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
	}
	
	if ([[ni abs] x] <= [[ni abs] y] && [ni y] >0) {
		v1 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:h.y]]];
		v2 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
	}
	
	if ([[ni abs] x] <= [[ni abs] y] && [ni y] <=0) {
		v1 = [p add:[r multiplyVector:[Vector2D vectorWith:-h.x y:-h.y]]];
		v2 = [p add:[r multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
	}
	
	//First Clipping
	Vector2D *v1c, *v2c; //points after clipping
	double dist1, dist2;
	dist1 = -[ns dot:v1] - dneg;
	dist2 = -[ns dot:v2] - dneg;
	
	if(dist1 < 0 && dist2 < 0)
	{
		v1c = v1;
		v2c = v2;
		NSLog(@"%i and %i colliding1", [self objType], [shape objType]);
	}
	
	if (dist1 < 0 && dist2 > 0) {
		v1c = v1;
		v2c = [v1 add: [[v2 subtract:v1] multiply:(dist1/(dist1-dist2))]];
		NSLog(@"%i and %i colliding2", [self objType], [shape objType]);
	}

	if (dist1 > 0 && dist2 > 0) {
		//the rectangles do not collide WTF!
		//EXIT THE FUNCTION
		NSLog(@"%i and %i Not Colliding", [self objType], [shape objType]);
		return false;
	}
	/*
	//Second Clipping
	Vector2D *v1cc, *v2cc;
	
	dist1 = [ns dot:v1c] - dpos;
	dist2 = [ns dot:v2c] - dpos;
	
	if (dist1 < 0 && dist2 < 0) {
		v1cc = v1c;
		v2cc = v2c;
	}
	
	if (dist1 < 0 && dist2 > 0) {
		v1cc = v1c;
		v2cc = [v1c add: [[v2c subtract:v1c] multiply:(dist1/(dist1-dist2))]];
	}
	
	if (dist1 > 0 && dist2 > 0) {
		//the rectangles do not collide WTF!
		//exit the function
		NSLog(@"Not colliding");
		return false;
	}
	
	
	//contact points
	Vector2D *c1, *c2;
	double separation;
	
	separation = [nf dot:v1cc] - df;
	c1 = [v1cc subtract:[nf multiply:separation]];
	
	separation = [nf dot:v2cc] - df;
	c2 = [v2cc subtract:[nf multiply:separation]];
	*/
	 [self setVelocity:[Vector2D vectorWith:0.0 y:0.0]];
	 [shape setVelocity:[Vector2D vectorWith:0.0 y:0.0]];

	 
	
	return true;
	 
}

-(void)stopObject{
	[self setVelocity:[Vector2D vectorWith:0.0 y:0.0]];
}


@end
