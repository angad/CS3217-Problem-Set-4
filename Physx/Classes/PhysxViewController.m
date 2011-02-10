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
	accel.updateInterval = 1.0f/60.0f;
	
	//Drawing rectangles
	CGRect frame = CGRectMake(80, 40, 100, 20);
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
}

/*
 
 This is for checking orientation (without accelerometer).
	
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	NSLog(@"rotated");
	
//	NSLog(@"%@", fromInterfaceOrientation);
	
}
 */

- (void) move:(NSNotification *) notification
{
	ObjectModel *t = [notification object];
//	NSLog(@"%f", [[t position] x]);
//	NSLog(@"%i", [t objType]);
//	if ([[notification name] isEqualToString:@"moveObject"])
// NSLog (@"Successfully received the test notification!");
	
	switch ([t objType]) {
		case 1:
			//red
			[red setCenter:CGPointMake([[t position] x], [[t position] y])];
			break;
		case 2:
			//green
			[green setCenter:CGPointMake([[t position] x], [[t position] y])];
			break;
		case 3:
			//blue
			[blue setCenter:CGPointMake([[t position] x], [[t position] y])];

			break;
		case 4:
			//yellow
			[yellow setCenter:CGPointMake([[t position] x], [[t position] y])];

			break;
		case 5:
			//purple
			[purple setCenter:CGPointMake([[t position] x], [[t position] y])];

			break;
		case 6:
			//pink
			[pink setCenter:CGPointMake([[t position] x], [[t position] y])];

			break;
		default:
			break;
	}
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
}

@end
