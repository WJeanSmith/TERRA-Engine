//
//  EAGLView.h
//  sushiquest_iphone
//
//  Created by Sergio Flores on 3/3/11.
//  Copyright 2011. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

	
/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView <UIAccelerometerDelegate> {

@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
	GLuint depthStencilBuffer;
	GLuint stencilRenderbuffer;

	GLuint msaaFramebuffer;
    GLuint msaaRenderBuffer;
	GLuint msaaDepthBuffer;
	
	UIDeviceOrientation currentOrientation;
    
	bool hasMsaa;
	bool hasStencil;
	
    bool started;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;

    
    float screenscale;
    
}

@property NSTimeInterval animationInterval;
@property float screenscale;
@property GLint backingWidth;
@property GLint backingHeight;
@property bool started;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
- (void)beginDraw;
- (void)endDraw;
-(void)initAccel;
@end