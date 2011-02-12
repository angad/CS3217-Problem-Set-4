//
//  PhysxViewController.m
//  Physx
//
//  Created by Angad Singh on 2/5/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "PhysxViewController.h"

@implementation PhysxViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

	//[[NSNotificationCenter defaultCenter] addObserver:self
	//										 selector:@selector(didRotateFromInterfaceOrientation:)
	//											 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	timeStep *ts = [[timeStep alloc]initWithViewController:self];
	
	
	//Accelerometer
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = ts;
	accel.updateInterval = 3.0f/60.0f;
	
	//Drawing rectangles
	CGRect frame = CGRectMake(300, 100, 40, 80);
	red = [[UIView alloc] initWithFrame:frame];
	red.backgroundColor = [UIColor redColor];
	[frameview addSubview:red];
	
	frame = CGRectMake(100, 100, 40, 80);
	green = [[UIView alloc] initWithFrame:frame];
	green.backgroundColor = [UIColor greenColor];
	[frameview addSubview:green];
	
	frame = CGRectMake(140, 200, 40, 80);
	blue = [[UIView alloc] initWithFrame:frame];
	blue.backgroundColor = [UIColor blueColor];
	[frameview addSubview:blue];
	
	frame = CGRectMake(240, 300, 40, 80);
	yellow = [[UIView alloc] initWithFrame:frame];
	yellow.backgroundColor = [UIColor yellowColor];
	[frameview addSubview:yellow];
	
	frame = CGRectMake(200, 500, 40, 80);
	purple = [[UIView alloc] initWithFrame:frame];
	purple.backgroundColor = [UIColor purpleColor];
	[frameview addSubview:purple];
	
	frame = CGRectMake(300, 700, 40, 80);
	pink = [[UIView alloc] initWithFrame:frame];
	pink.backgroundColor = [UIColor magentaColor];
	[frameview addSubview:pink];
	
	//the big invincible masses
	frame = CGRectMake(5, 5, 750, 10);
	top = [[UIView alloc] initWithFrame:frame];
	top.backgroundColor = [UIColor blackColor];
	[frameview addSubview:top];
	
	frame = CGRectMake(750, 5, 10, 990);
	right = [[UIView alloc] initWithFrame:frame];
	right.backgroundColor = [UIColor blackColor];
	[frameview addSubview:right];
	
	frame = CGRectMake(5, 990, 750, 10);
	bottom = [[UIView alloc] initWithFrame:frame];
	bottom.backgroundColor = [UIColor blackColor];
	[frameview addSubview:bottom];
	
	frame = CGRectMake(5, 5, 10, 990);
	left = [[UIView alloc] initWithFrame:frame];
	left.backgroundColor = [UIColor blackColor];
	[frameview addSubview:left];
	
	[yellow release];
	[red release];
	[blue release];
	[green release];
	[purple release];
	[pink release];
	[right release];
	[bottom release];
	[left release];
	[top release];
}


- (void) move:(NSNotification *) notification
{
	ObjectModel *t = [notification object];
	CGAffineTransform transform = CGAffineTransformMakeRotation([t rotation]*(3.14159/180));
	switch ([t objType]) {
		case 1:
			//red
			[red setCenter:CGPointMake([[t position] x], [[t position] y]) ];
			[red setTransform:transform];
			break;
		case 2:
			//green
			[green setCenter:CGPointMake([[t position] x], [[t position] y])];
			[green setTransform:transform];
			break;
		case 3:
			//blue
			[blue setCenter:CGPointMake([[t position] x], [[t position] y])];
			[blue setTransform:transform];

			break;
		case 4:
			//yellow
			[yellow setCenter:CGPointMake([[t position] x], [[t position] y])];
			[yellow setTransform:transform];

			break;
		case 5:
			//purple
			[purple setCenter:CGPointMake([[t position] x], [[t position] y])];
			[purple setTransform:transform];

			break;
		case 6:
			//pink
			[pink setCenter:CGPointMake([[t position] x], [[t position] y])];
			[pink setTransform:transform];
			break;
		default:
			break;
	}
	[t release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[frameview release];
}

@end
