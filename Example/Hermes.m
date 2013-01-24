//
//  Hermes.m
//  paperwoven
//
//  Created by Alex Reynolds on 9/28/12.
//  Copyright (c) 2012 OutCoursing. All rights reserved.
//

#import "Hermes.h"



@interface HermesButton :UIButton
- (id)initWithFrame: (CGRect)frame andTitle: (NSString*)title andColor: (HermesButtonColor)color;
@end

@implementation HermesButton

- (id)initWithFrame: (CGRect)frame andTitle: (NSString*)title andColor:(HermesButtonColor)color
{
    if ((self = [super initWithFrame:frame]))
    {
        //[self setButtonStyle:style];
        [self awakeFromNib];
        [self setTitle:[title uppercaseString] forState:UIControlStateNormal];
        [self setButtonStates:color];
        
    }
    return self;
}

-(void) setButtonStates:(HermesButtonColor)color
{
    
    NSString *imgsrc;
    NSString *imgsrcHigh;
    switch (color) {
        case HermesBlueButton:
        {
            imgsrc = @"blueBtn.png";
            imgsrcHigh = @"blueBtnHighlighted.png";
            UIImage *btnBkgDisabled =[[UIImage imageNamed:@"blueBtnDisabled.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
            [self setBackgroundImage:btnBkgDisabled forState:UIControlStateDisabled];
        }
            break;
        case HermesBlackButton:
        {
            imgsrc = @"modalBtn.png";
            imgsrcHigh = @"modalBtnHighlighted.png";
        }
            break;
        case HermesRedButton:
        {
            imgsrc = @"redBtnNav.png";
            imgsrcHigh = @"redBtnNavHighlighted.png";
        }
            break;
        default:
            break;
    }
    // Set Btn Images and states
    UIImage *btnBkg = [[UIImage imageNamed:imgsrc] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *btnBkgHighlighted = [[UIImage imageNamed:imgsrcHigh] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [self setBackgroundImage:btnBkg forState:UIControlStateNormal];
    [self setBackgroundImage:btnBkgHighlighted forState:UIControlStateHighlighted];
    
    
    //Style the fonts of the title label
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:0.95 alpha:1.0] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateDisabled];
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOpacity = 0.7f;
    self.titleLabel.layer.shadowRadius = 0.8f;
    self.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.3f);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}
@end





@interface Hermes ()

@end


@implementation Hermes

static const float FULL_BUTTON_WIDTH = 0.9;
static const float HALF_BUTTON_WIDTH = 0.425;
static const NSInteger DEFAULT_BUTTON_COLOR = 1;
static float DEFAULT_HERMES_FONT_SIZE = 16;
static NSString *DEFAULT_HERMES_FONT = @"Arial";
static NSInteger _btnHeight = 40;
static NSInteger _marginBottom = 10;
static float BUTTON_MARGIN = 0.05;
static NSInteger BACKGROUND_TAG = 989;
static float HERMES_WINDOW_SIZE_PERCENTAGE = 0.9;


- (id)initWithMessage:(NSString *)message
{
    // First we get the total screen size

    NSLog(@"init");
    // Create frame that is dynamic based on btn rows
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(screen.origin.x,screen.origin.y, screen.size.width,screen.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        _hermesWidth = screen.size.width * HERMES_WINDOW_SIZE_PERCENTAGE;
        _numberOfButtonRows = 0;
        _halfBtnWidth = _hermesWidth * HALF_BUTTON_WIDTH;
        _fullBtnWidth = _hermesWidth * FULL_BUTTON_WIDTH;
        _marginTop = BUTTON_MARGIN;
        _marginLeft = _hermesWidth*BUTTON_MARGIN;
        _marginRight = _hermesWidth*BUTTON_MARGIN;
        _hermesButtonColor = DEFAULT_BUTTON_COLOR;
        _hermesFont = [UIFont fontWithName:DEFAULT_HERMES_FONT size:DEFAULT_HERMES_FONT_SIZE];
        _message = message;
        _buttonRowCompleted = YES;
        
        // We need to set the message so we can get the height of the message uilabel to then build the modal
        [self setMessageLabel:_message];
        
        // set all of our private vars with dynamically so buttons and spacing is relative to frame
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
        
        [self makeAlertBox:self.frame];


    }
    return self;
}

// Set custom Hermes alert size
// @param float of percentage of total window
-(void) setHermesWidthPercent:(float)widthPercent
{

    CGRect screen = [[UIScreen mainScreen] bounds];
    _hermesWidth = screen.size.width * widthPercent;
    _halfBtnWidth = _hermesWidth*HALF_BUTTON_WIDTH;
    _fullBtnWidth = _hermesWidth*FULL_BUTTON_WIDTH;
}


-(void) makeAlertBox:(CGRect)screen
{
        NSLog(@"make alert");
    // Now set and Calc the label size
    
    float alertBoxOriginX = (screen.size.width - _hermesWidth)/2;
    float alertBoxOriginY = (screen.size.height - _messageHeight)/2;
    
    _alertBox = [[UIView alloc] initWithFrame:CGRectMake(alertBoxOriginX, alertBoxOriginY, _hermesWidth, _messageHeight+_marginTop + _marginBottom + (_numberOfButtonRows*(_btnHeight+_marginBottom)))];
    
    // Add in our Message Label
    [_alertBox addSubview:_messageLabel];
    

    
    // Add in our backgound for the alert box 
    UIImage *background = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pw-login-bg" ofType:@"png"]];
    UIImageView *bkgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,_alertBox.frame.size.width, _alertBox.frame.size.height)];
    
    if(HERMES_ROUNDED_CORNERS){
        [[bkgImageView layer] setCornerRadius:HERMES_ROUNDED_CORNER_RADIUS];
        [[bkgImageView layer] setMasksToBounds:YES];
        [[_alertBox layer] setCornerRadius:HERMES_ROUNDED_CORNER_RADIUS];
    }
    // set the image and make it grow to fill the alert view
    [bkgImageView setImage:background];
    bkgImageView.tag =BACKGROUND_TAG;
    [bkgImageView setContentMode:UIViewContentModeScaleToFill];
    
    // Add the background to the view and send it to the back
    [_alertBox addSubview:bkgImageView];
    [_alertBox sendSubviewToBack:bkgImageView];
    

        

    
    // add shadow to alert modal
    [[_alertBox layer] setShadowOffset:CGSizeMake(3,3) ];
    [[_alertBox layer] setShadowColor : [UIColor blackColor].CGColor ];
    [[_alertBox layer] setShadowOpacity : 0.4f];
    [[_alertBox layer] setShadowRadius : 4];

    
    [[_alertBox layer] setBorderWidth:1.0f];
    [[_alertBox layer] setBorderColor:[[UIColor colorWithWhite:0.8 alpha:1.3] CGColor]];
    
    [self addSubview:_alertBox];
}
// SetButton take a title and type to create a single, double or half button.
- (void) addActionButton:(NSString*)title position:(HermesButtonPlaces)position action:(SEL)buttonAction delegate:(id)delegate
{
    CGRect frame = [self getButtonFrame:position];
    // INIT the button in the right location.
    
    HermesButton *modalBtn = [
                              [HermesButton alloc]
                              initWithFrame:frame
                              andTitle:title
                              andColor:_hermesButtonColor];
    
    [modalBtn addTarget:delegate action:buttonAction forControlEvents: UIControlEventTouchUpInside];
    [modalBtn setTag:position];

    [_alertBox addSubview:modalBtn];
    [self updateHermesShoeSize];
    
}

- (void) addDismissButton:(NSString*)title position:(HermesButtonPlaces)position
{

    
    CGRect frame = [self getButtonFrame:position];
    // INIT the button in the right location.
    HermesButton *modalBtn = [
                              [HermesButton alloc]
                              initWithFrame:frame
                              andTitle:title
                              andColor:_hermesButtonColor];
    
    [modalBtn addTarget:self action:@selector(dismissModal) forControlEvents: UIControlEventTouchUpInside];
    [modalBtn setTag:position];

    [_alertBox addSubview:modalBtn];

    [self updateHermesShoeSize];
}

-(void) updateHermesShoeSize
{
    CGRect newHermesShoeSize = _alertBox.frame;
    newHermesShoeSize.size.height =_messageHeight+_marginTop + _marginBottom + (_numberOfButtonRows*(_btnHeight+_marginBottom));
    newHermesShoeSize.origin.y -= (newHermesShoeSize.size.height -  _alertBox.frame.size.height)/2;
    
    //Update our alert box.
    _alertBox.frame = newHermesShoeSize;
    
    // Now Update our background image;
    [_alertBox viewWithTag:BACKGROUND_TAG].frame = CGRectMake(0,0,_alertBox.frame.size.width, _alertBox.frame.size.height);
}

// Put our buttons in place, ie left right top button
-(CGRect) getButtonFrame:(HermesButtonPlaces)type
{
    
    CGRect frame;
    switch (type){
        case HermesButtonHalf:
            if(_lastButtonType == HermesButtonHalf){
                if(_buttonRowCompleted){
                    // Start new row
                    frame = CGRectMake(_marginLeft,_alertBox.bounds.size.height, _halfBtnWidth, _btnHeight);
                    _buttonRowCompleted = NO;
                    _numberOfButtonRows +=1;
                } else{
                    // Finish old row
                    frame = CGRectMake(_marginLeft + _halfBtnWidth + _marginRight,_alertBox.bounds.size.height - _btnHeight -_marginTop - _marginBottom, _halfBtnWidth, _btnHeight);
                    _buttonRowCompleted = YES;
                }

            } else {
                // start new row
                frame = CGRectMake(_marginLeft,_alertBox.bounds.size.height, _halfBtnWidth, _btnHeight);
                _buttonRowCompleted = NO;
                _numberOfButtonRows +=1;
            }
            
            break;
        case HermesButtonFull:
            _buttonRowCompleted = YES;
            _numberOfButtonRows +=1;
            frame = CGRectMake(_marginLeft,_alertBox.bounds.size.height, _fullBtnWidth, _btnHeight);
            break;
        default:
            _buttonRowCompleted = YES;
            _numberOfButtonRows +=1;
            frame = CGRectMake(_marginLeft,_alertBox.bounds.size.height, _fullBtnWidth, _btnHeight);
            break;
    }
    _lastButtonType = type;
    return frame;
}
// set Message get an NSString and creates a UILabel.
// The Label is set dynamically with margins and set UILabelHeight
- (void) setMessageLabel:(NSString *)message
{
    float msgWidth = _hermesWidth-(_marginLeft*2);
    CGSize labelsize=[message sizeWithFont:[UIFont fontWithName:_hermesFont.fontName size:(18.0)] constrainedToSize:CGSizeMake(msgWidth, 1000.0) lineBreakMode:UILineBreakModeWordWrap];
    // Calculating the height of the message allows the label to be exact and aligned top
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(_marginLeft, _marginTop, msgWidth, labelsize.height)];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        msg.textAlignment =  NSTextAlignmentCenter;
    } else {
        msg.textAlignment =  UITextAlignmentCenter;
    }
    msg.textColor = [UIColor whiteColor];
    msg.backgroundColor = [UIColor clearColor];
    msg.font = _hermesFont;
    msg.numberOfLines = 0;
    msg.text = message;
    _messageLabel = msg;
    _messageHeight = _messageLabel.frame.size.height;
}

// dismissModal removes the Hermes view from the superview.
- (void) dismissModal
{
   [self removeFromSuperview];
}

// show animates a Hermes message in and adds the view to the window
-(void) show
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    _alertBox.alpha = 0.0;
    _alertBox.transform = CGAffineTransformMakeScale(0.80, 0.80);
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         _alertBox.alpha = 1.0;
                         _alertBox.transform = CGAffineTransformMakeScale(1.10, 1.10);
                     }
     
                     completion:^(BOOL Finished){
                         
                         [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                          
                                          animations:^{
                                              _alertBox.transform = CGAffineTransformIdentity;
                                          }
                          
                                          completion:^(BOOL Finished){
                                          }];
                         
                     }];
}

-(void) fadeInAndOut:(float)delay
{
    self.alpha = 0.0;
    _alertBox.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [[[[UIApplication sharedApplication] delegate] window ] addSubview:self];
    
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         self.alpha = 1.0;
                          _alertBox.transform = CGAffineTransformMakeScale(1.10, 1.10);
                     }
     
                     completion:^(BOOL Finished){
                         
                         [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                          
                                          animations:^{
                                              _alertBox.transform = CGAffineTransformIdentity;
                                          }
                          
                                          completion:^(BOOL Finished){
                                              
                                              [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseIn
                                               
                                                               animations:^{
                                                                   self.alpha = 0.0;
                                                               }
                                               
                                                               completion:^(BOOL Finished){
                                                                   
                                                                   [self removeFromSuperview];
                                                               }];
                                              
                                          }];
                         
                     }];
     

}
-(UIButton *) createButtonWithFrame:(CGRect *)frame
{
    return _hermesButton;
}

- (void)drawRect:(CGRect)rect {
       UIBezierPath *line = [UIBezierPath bezierPath];
    [[UIColor colorWithWhite:1.0 alpha:0.5] setStroke];
    line.lineWidth =1;
    [line moveToPoint:CGPointMake(0, 0)];
    [line addLineToPoint:CGPointMake(_alertBox.bounds.size.width, 0)];
    [line stroke];
    
    
    
    
}

@end

