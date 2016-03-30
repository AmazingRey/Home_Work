//
//  XKRWRecordCircumferenceEntity.m
//  XKRW
//
//  Created by XiKang on 14-11-18.
//  Copyright (c) 2014年 XiKang. All rights reserved.
//

#import "XKRWRecordCircumferenceEntity.h"

@implementation XKRWRecordCircumferenceEntity
{
    float _bust;
    float waistline;
    
}

@synthesize bust = _bust, waistline = _waistline, hipline = _hipline, arm = _arm, thigh = _thigh, shank = _shank;

- (float)bust
{
    if (_bust < 0) {
        _bust = 0;
    }
    return _bust;
}

- (void)setBust:(float)bust
{
    if (bust < 0) {
        _bust = 0;
    } else {
        _bust = bust;
    }
}

- (float)waistline
{
    if (_waistline < 0) {
        _waistline = 0 ;
    }
    return _waistline;
}

- (void)setWaistline:(float)the_waistline
{
    if (the_waistline < 0) {
        _waistline = 0;
    } else {
        _waistline = the_waistline;
    }
}

- (float)hipline
{
    if (_hipline < 0) {
        _hipline = 0;
    }
    return _hipline;
}

- (void)setHipline:(float)hipline
{
    if (hipline < 0) {
        _hipline = 0;
    } else {
        _hipline = hipline;
    }
}

- (float)arm
{
    if (_arm < 0) {
        _arm = 0;
    }
    return _arm;
}

- (void)setArm:(float)arm
{
    if (arm < 0) {
        _arm = 0;
        return;
    }
    _arm = arm;
}

- (float)thigh
{
    if (_thigh < 0) {
        _thigh = 0;
    }
    return _thigh;
}

- (void)setThigh:(float)thigh
{
    if (thigh < 0) {
        _thigh = 0;
        return;
    }
    _thigh = thigh;
}

- (float)shank
{
    if (_shank < 0) {
        _shank = 0;
    }
    return _shank;
}

- (void)setShank:(float)shank
{
    if (shank < 0) {
        _shank = 0;
        return;
    }
    _shank = shank;
}
@end
