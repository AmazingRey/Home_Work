/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "THTTPClient.h"
#import "TTransportException.h"
#import "TObjective-C.h"
#import "ASIHTTPRequest.h"
#import "XKNetworkException.h"
#import "XKServerException.h"
#import "XKAppInfoHelper.h"

@implementation THTTPClient
@synthesize responseData;
@synthesize response_;
- (void) setupRequest
{
  if (mRequest != nil) {
    [mRequest release_stub];
  }
    mRequest = [ASIFormDataRequest requestWithURL:mURL];
    [mRequest addRequestHeader:@"Content-Type" value:@"application/x-thrift"];

    [mRequest addRequestHeader:@"Accept" value:@"application/x-thrift"];
  NSString * userAgent = mUserAgent;
  if (!userAgent) {
    userAgent = @"Cocoa/THTTPClient";
  }
    [mRequest addRequestHeader:@"User-Agent" value:userAgent];

//  [mRequest setPostValue:userAgent forKey:@"User-Agent"];÷

  [mRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
  if (mTimeout) {
    [mRequest setTimeOutSeconds:XKNetTimeOutSeconds];
  }
}


- (id) initWithURL: (NSURL *) aURL
{
  return [self initWithURL: aURL
                 userAgent: nil
                   timeout: 0];
}


- (id) initWithURL: (NSURL *) aURL
         userAgent: (NSString *) userAgent
           timeout: (int) timeout
{
  self = [super init];
  if (!self) {
    return nil;
  }

  mTimeout = timeout;
  if (userAgent) {
    mUserAgent = [userAgent retain_stub];
  }
  mURL = [aURL retain_stub];

  [self setupRequest];

  // create our request data buffer
  mRequestData = [[NSMutableData alloc] initWithCapacity: 1024];

  return self;
}


- (void) setURL: (NSURL *) aURL
{
  [aURL retain_stub];
  [mURL release_stub];
  mURL = aURL;

  [self setupRequest];
}


- (void) dealloc
{
  [mURL release_stub];
  [mUserAgent release_stub];
  [mRequest release_stub];
  [mRequestData release_stub];
  [mResponseData release_stub];
  [super dealloc_stub];
}


- (int) readAll: (uint8_t *) buf offset: (int) off length: (int) len
{
  NSRange r;
  r.location = mResponseDataOffset;
  r.length = len;

    
    @try {
        [mResponseData getBytes: buf+off range: r];
    }
    @catch (id exception) {
        if ([XKAppInfoHelper releaseType] != XKAppInfoReleaseTypeDevelopment) {
            @throw [XKNetworkException exceptionWithType:kXKNetworkExceptionTypeDataLoss cause:exception];
        }
        else {
            @throw exception;
        }
    }
  mResponseDataOffset += len;

  return len;
}


- (void) write: (const uint8_t *) data offset: (unsigned int) offset length: (unsigned int) length
{
  [mRequestData appendBytes: data+offset length: length];
}


- (void) flush
{
    [mRequest setPostBody: mRequestData]; // not sure if it copies the data
    // make the HTTP request
    [mRequest setTimeOutSeconds:XKNetTimeOutSeconds];
    [mRequest setValidatesSecureCertificate:NO];
    mRequest.shouldContinueWhenAppEntersBackground = YES;
    [mRequest startSynchronous];

    responseData = mRequest.responseData;

    [mRequestData setLength: 0];
    if (responseData == nil) {
        @throw [XKNetworkException exceptionWithType:kXKNetworkExceptionTypeNoResponse];
    }
    if (mRequest.responseStatusCode != 200) {
        if (mRequest.responseStatusCode == 0) {
            @throw [XKNetworkException exceptionWithType:kXKNetworkExceptionTypeNoResponse];
        }
        else {
            @throw [XKServerException exceptionWithUrl:mRequest.url httpStatusCode:mRequest.responseStatusCode];
        }
    }
    // phew!
    mResponseData = responseData;
    mResponseDataOffset = 0;
}

@end
