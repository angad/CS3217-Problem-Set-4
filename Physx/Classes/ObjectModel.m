//
//  ObjectModel.m
//  Physx
//
//  Created by Angad Singh on 2/7/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "ObjectModel.h"


@implementation ObjectModel

@synthesize mass, momentOfInertia, position, width, height, velocity, angularVelocity, objType, rotation, rotationM, center, grav, collided;

-(id)initWithType:(ObjectType)t Mass:(double)m MomentOfInertia:(double)i Angle:(double)r Position:(Vector2D*)p Width:(double)w Height:(double)h Velocity:(Vector2D*)v AngularVelocity:(double)av
{
	dt = 0.016;
	//initializes ObjectModel
	width = w;
	height = h;
	mass = m;
	position = p;
	velocity = v;
	angularVelocity = av;
	objType = t;
	rotation = r;
	momentOfInertia = (width*width + height*height)/12.0;
	center = CGPointMake(([position x] + width)/2.0, ([position y] + height)/2.0);
	rotationM = [[Matrix2D matrixWithValues:cos(rotation) and:sin(rotation) and:-sin(rotation) and:cos(rotation)] retain];
	grav = [[Vector2D vectorWith:0.0 y:0.0] retain];
	collided = NO;
	return self;
}

-(void)setVelocity:(Vector2D*)v
{
	//sets Velocity
	velocity = v;
	[velocity retain];
	[self setPosition: ([position add:[velocity multiply:dt]])];
}

-(void)setAngularVelocity:(double)a
{
	angularVelocity = a;
	[self setRotation: (rotation + (dt * angularVelocity *180/M_PI))];
}

-(void)setRotation:(double)r{
	rotation = r;
	r = r*M_PI/180;
	rotationM = [[Matrix2D matrixWithValues:cos(r) and:sin(r) and:-sin(r) and:cos(r)] retain];
}
	 
-(void)setPosition:(Vector2D*)p
{
	position = p;
	[position retain];
}

-(void)applyForce:(Vector2D*)f Gravity:(Vector2D*)g
{	
	//tested - works
//	if ((g.x<0 && [self grav].x>0) || (g.x>0 && [self grav].x<0)) {
//		[self setVelocity: [Vector2D vectorWith:velocity.x/2 y:velocity.y]];
//	}
//	
//	if((g.y<0 && [self grav].y>0) || (g.y>0 && [self grav].y<0)){
//		[self setVelocity: [Vector2D vectorWith:velocity.x y:velocity.y/2]];
//	}
	
	[self setVelocity: [velocity add:([[g add:[f multiply:(1/mass)]] multiply:(dt)])]];
	grav = g;
}

-(void)applyTorque:(Vector2D*)t
{
	//not tested (!)
	//[self setAngularVelocity:[angularVelocity add:[[t multiplyScalar:(1/momentOfInertia)]multiplyScalar:(0.016)]]];
}

-(NSArray*)colliding:(ObjectModel*)shape:(Vector2D*)g{
	//Checks for collisions between self and shape. It returns the array of colliding points.	
	
	//shape = a
	//self = b
	NSArray *empty = [NSArray array];
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
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
		
	double ij[4];
	ij[0] = fa.x;
	ij[1] = fa.y;
	ij[2] = fb.x;
	ij[3] = fb.y;
	
	double modified[4];
	modified[0] = fa.x - 0.01*(ha.x);
	modified[1] = fa.y - 0.01*(ha.y);
	modified[2] = fb.x - 0.01*(hb.x);
	modified[3] = fb.y - 0.01*(hb.y);
	
	int i,pos, flag;
	double small = modified[0];
	pos = 0;
	flag = 0;
	
	//if any of them are positive then they do not collide
	for (i=0; i<4; i++) {
		if (ij[i] > 0) {
			//NSLog(@"%i and %i Not Colliding", [self objType], [shape objType]);
			return empty;
		}
	}
	
	//favoring the larger edge for reference edge
	for (i=0; i<4; i++) {
		if (modified[i] > (0.95)*ij[i]) {
			small = modified[i];
			pos = i;
			flag = 1;
		}
	}
	
	if (flag == 0) {
		small = ij[0];
		pos = 0;	
		for (i=0; i<4; i++) {
			if (ij[i] > small) 
			{
				small = ij[i];
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
			//NSLog(@"0");
			if (da.x >= 0) //rectangle B is on the right hand side of rectangle A in Ra.
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
			//NSLog(@"1");

			if (da.y >= 0) //rectangle B is on top of rectangle A in Ra.
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
			//NSLog(@"2");

			if (db.x >= 0) //rectangle A is on the right hand side of rectangle B in Rb.
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
			//NSLog(@"3");

			if (db.y >= 0) //rectangle A is on the top of rectangle B in Rb.
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
	dist1 = [[ns negate] dot:v1] - dneg;
	dist2 = [[ns negate] dot:v2] - dneg;
	
	if (dist1 > 0 && dist2 > 0) {
		//the rectangles do not collide WTF!
		//EXIT THE FUNCTION
		//NSLog(@"%i and %i Not Colliding", [self objType], [shape objType]);
		return empty;
	}

	if(dist1 < 0 && dist2 < 0)
	{
		v1c = v1;
		v2c = v2;
		collided = YES;
		//NSLog(@"%i and %i colliding1", [self objType], [shape objType]);
	}
	
	if (dist1 < 0 && dist2 > 0) {
		v1c = v1;
		v2c = [v1 add: [[v2 subtract:v1] multiply:(dist1/(dist1-dist2))]];
		collided = YES;
		//NSLog(@"%i and %i colliding2", [self objType], [shape objType]);
	}
	
	if (dist1 > 0 && dist2 < 0) {
		v1c = v2;
		v2c = [v1 add: [[v2 subtract:v1] multiply:(dist1/(dist1-dist2))]];
		collided = YES;
		//NSLog(@"%i and %i colliding3", [self objType], [shape objType]);
	}

	//Second Clipping
	Vector2D *v1cc, *v2cc;
	
	dist1 = [ns dot:v1c] - dpos;
	dist2 = [ns dot:v2c] - dpos;
	
	if (dist1 > 0 && dist2 > 0) {
		//the rectangles do not collide WTF!
		//exit the function
		//NSLog(@"%i and %i Not colliding2", [self objType], [shape objType]);
		return empty;
	}
	
	if (dist1 < 0 && dist2 < 0) {
		v1cc = v1c;
		v2cc = v2c;
		collided = YES;
		//NSLog(@"%i and %i colliding4", [self objType], [shape objType]);
	}
	
	if (dist1 < 0 && dist2 > 0) {
		v1cc = v1c;
		v2cc = [v1c add: [[v2c subtract:v1c] multiply:(dist1/(dist1-dist2))]];
		collided = YES;
		//NSLog(@"%i and %i colliding5", [self objType], [shape objType]);
	}
	
	if (dist1 > 0 && dist2 < 0) {
		v1cc = v2c;
		v2cc = [v1c add: [[v2c subtract:v1c] multiply:(dist1/(dist1-dist2))]];
		collided = YES;
		//NSLog(@"%i and %i colliding6", [self objType], [shape objType]);
	}
	
	//contact points
	Vector2D *c1, *c2;
	double separation;
	
	separation = [nf dot:v1cc] - df;
	
	if (separation < 0) {
		c1 = [v1cc subtract:[nf multiply:separation]];
		[self applyImpulse:shape :c1 :n: separation];
	}
	else return empty;
	
	separation = [nf dot:v2cc] - df;
	
	if (separation < 0) {
		c2 = [v2cc subtract:[nf multiply:separation]];
		[self applyImpulse:shape :c2 :n: separation];
	}
	else return empty;
	
	//[self setVelocity:[Vector2D vectorWith:0.0 y:0.0]];
	//[shape setVelocity:[Vector2D vectorWith:0.0 y:0.0]];
	//NSLog(@"%i and %i Colliding", [self objType], [shape objType]);
	
	
	NSArray *contacts = [[NSArray alloc] initWithObjects:c1, c2, nil];
	[pool release];

	return [contacts autorelease];
}
		  
-(void)applyImpulse:(ObjectModel*)shape:(Vector2D*)contact:(Vector2D*)normal :(double)separation{
	
	//Impulses at contact points
	
	//self b 
	//shape a
	
	Vector2D *tangent;
	tangent = [normal crossZ:1.0];
	
	Vector2D *ra, *rb;
	Vector2D *ua, *ub;
	Vector2D *u;
	
	//direction vectors of the contact point from the centres of mass
	ra = [contact subtract:[shape position]];
	rb = [contact subtract:[self position]];
	
	//velocities at contact point
	ua = [[shape velocity] add:[ra crossZ:-[shape angularVelocity]]];
	ub = [[self velocity] add:[rb crossZ:-[self angularVelocity]]];
	
	//relative velocity of the contact point
	u = [ub subtract:ua];

	double un, ut;
	un = [u dot:normal];
	ut = [u dot:tangent];

	double massn_i, masst_i, massn, masst;
	
	massn_i = (1/[self mass]) + (1/[shape mass]) + (([ra dot:ra] - ([ra dot:normal]*[ra dot:normal]))/[shape momentOfInertia]) + (([rb dot:rb] - ([rb dot:normal]*[rb dot:normal]))/[self momentOfInertia]);
	masst_i = (1/[self mass]) + (1/[shape mass]) + (([ra dot:ra] - ([ra dot:tangent]*[ra dot:tangent]))/[shape momentOfInertia]) + (([rb dot:rb] - ([rb dot:tangent]*[rb dot:tangent]))/[self momentOfInertia]);

	massn = 1/massn_i;
	masst = 1/masst_i;

	Vector2D *pn;	//Normal impulse
	double dpt;		//Change of tangential momentum
	
	double restitution = 0.15;
	double tolerance = 0.01;
	double bias = abs((restitution/dt)*(tolerance + separation));
	//NSLog(@"%f", separation);
	
	if (tolerance < separation) {
		bias = 0;
	}
	
	pn = [normal multiply:(massn * (un-bias))];
//	pn = [normal multiply:(massn * un)];
	dpt = masst * ut;
	
	double friction = 0.95;
	double ptmax = friction * friction * [pn length];
	
	dpt = MAX(-ptmax, MIN(dpt, ptmax));
	
	Vector2D *pt;
	pt = [tangent multiply:dpt];
	
	Vector2D *newVa, *newVb;
	double newWa, newWb;
	
	newVa = [[shape velocity] add:[[pn add:pt] multiply:(1/[shape mass])]];
	newVb = [[self velocity] subtract:[[pn add:pt] multiply:(1/[self mass])]];
	
	newWa = [shape angularVelocity] + ([ra cross:[pt add:pn]]/[shape momentOfInertia]);
	newWb = [self angularVelocity] - ([rb cross:[pt add:pn]]/[self momentOfInertia]);
	
	if ([self objType]<7) {
		[self setVelocity:newVb];
		[self setAngularVelocity:newWb];
	}
	
	if ([shape objType]<7) {
		//NSLog(@"%i  %f %f", [shape objType], [newVb x], [newVb y]);
		[shape setVelocity:newVa];
		[shape setAngularVelocity:newWa];
	}
}

-(void)dealloc{
	[super dealloc];
	[rotationM release];
	[position release];
	[velocity release];
	[grav release];
}

-(void)stopObject{
	[self setVelocity:[Vector2D vectorWith:0.0 y:0.0]];
}


@end
