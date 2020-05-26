//
//  IFlyISVRecognizer.h
//  ISV
//
//  Created by wangdan on 14-9-6.
//  Copyright (c) 2014年 IFlyTEK. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IFlyISVDelegate.h"

/**
 *  声纹接口类
 */
@interface IFlyISVRecognizer : NSObject 
{

}

/*!
 *  The delegate of FlyISVRecognizer responsing to IFlyISVDelegate.
 */
@property (assign) id<IFlyISVDelegate> delegate;


/*!
 *  FlyISVRecognizer is a kind of Singleton calss.The function can be used as below:<br>
 *  IFLyISVRecognizer *recognizer=[IFlyISVRecognizer creteRecognizer: self];
 */
+(instancetype) sharedInstance;


/*!
 *  Genrerate a serial number password<br>
 *  Princeple:<br>
 *  1.Number serial has no 1 in itself;<br>
 *  2.The nuber serial has no same number("98765432"is right while "99876543" is wrong)
 *
 *  @param length   the serial number's length,length of "98765432" is 8,generally length is 8 and other value is forbidden
 */
-(NSString*) generatePassword:(int)length;



/*!
 *  Used to get password from server
 *
 *  @param pwdt   when pwdt is 1,the function will return chinese text;while pwdt is 2, the funciton will return number serial
 */
-(NSArray*) getPasswordList:(int)pwdt;


/*!
 *  Used to judge if the engine is running in listenning
 *
 *  @return YES: the engine is listenning;<br>No : the engine is not listenning
 */
-(BOOL) isListening;



/*!
 *  Used to query or delete the voiceprint model in server
 *
 *  @param cmd  "del": delete model;<br>"que": query model;
 *  @param authid: user id ,can be @"tianxia" or other;
 *  @param pwdt voiceprint type<br>
 *  1: fixed txt voiceprint code ,like @"我的地盘我做主";<br>
 *  2: free voiceprint code , user can speek anything,but 5 times trainning the speech shall be same;<br>
 *  3: number serial voiceprint code ,like @"98765432" and so on.
 *  @param ptxt voiceprint txt,only fixed voiceprint and number serial have this,in free voiceprint model this param shall be set nil.
 *  @param vid  another voiceprint type model,user can use this to query or delete model in server can be @"jakillasdfasdjjjlajlsdfhdfdsadff",totally 32 bits;<br>
 *  NOTES:<br>
 *  when vid is not nil,then the server will judge the vid first; while the vid is nil, server can still query or delete the voiceprint model by other params.
 */
-(BOOL) sendRequest:(NSString*)cmd authid:(NSString *)auth_id  pwdt:(int)pwdt ptxt:(NSString *)ptxt vid:(NSString *)vid err:(int *)err;


/*!
 *  Set the voiceprint params
 * 
 *  | key             | value                                             |
 *  |:---------------:|:-------------------------------------------------:|
 *  | sst             | @"train" or @"verify"                             |
 *  | auth_id         | @"tianxia" or other                               |
 *  | sub             | @"ivp"                                            |
 *  | ptxt            |                                                   |
 *  | rgn             | @"5"                                              |
 *  | pwdt            | @"1",or @"2", or @"3"                             |
 *  | auf             | @"audio/L16;rate=16000" or @"audio/L16;rate=8000" |
 *  | vad_enable      | @"1" or @"0"                                      |
 *  | vad_timeout     | @"3000"                                           |
 *  | vad_speech_tail | @"100"                                            |
 *
 *  @param value 参数值
 *  @param key   参数类型
 *
 *  @return 设置成功返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *)value forKey:(NSString *)key;



/*!
 *  Get the voiceprint params used the same as function of setParameter
 */
-(NSString*) getParameter:(NSString *)key;


/*!
 *  Start recording
 */
-(void) startListening;


/*!
 *  Stop recording
 */
-(void) stopListening;


/*!
 *  Cancel recording,like function stopListening
 */
-(void) cancel;                                                         /* cancel recognization */




@end

