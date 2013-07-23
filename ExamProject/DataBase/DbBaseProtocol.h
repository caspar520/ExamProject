//
//  DbBaseProtocol.h
//  ExamProject
//
//  Created by Magic Song on 13-7-18.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DbBaseProtocol <NSObject>

@end

@protocol PaperDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * paperId;          //试卷ID
@property (nonatomic, retain) NSString * title;            //试卷标题
@property (nonatomic, retain) NSString * desc;             //试卷描述
@property (nonatomic, retain) NSString * creator;       // 试卷创建者
@property (nonatomic, retain) NSNumber * totalTime;     // 试卷答题时间
@property (nonatomic, retain) NSNumber * totalScore;    // 试卷总分
@property (nonatomic, retain) NSNumber * topicCount;    // 试卷题目数
@property (nonatomic, retain) NSNumber * passingScore;  // 及格分数
@property (nonatomic, retain) NSNumber * eliteScore;    // 优秀分数
@property (nonatomic, retain) NSNumber * userScore;     //用户得分
@property (nonatomic, retain) NSNumber * fav;           // 是否存在收藏
@property (nonatomic, retain) NSNumber * wrong;         // 是否存在错题
@property (nonatomic, retain) NSNumber * sequence;      // 排序
@property (nonatomic, retain) NSString * addtime;       // 添加时间
@property (nonatomic, retain) NSString * url;

@end

@protocol UserDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * email;         // email作为用户名
@property (nonatomic, retain) NSString * fullName;      // 姓名
@property (nonatomic, retain) NSNumber * regionId;      // 所在地代号
@property (nonatomic, retain) NSString * deptName;      // 部门名称

@end

@protocol TopicDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * topicId;       //试题Id
@property (nonatomic, retain) NSString * question;      // 试题题目
@property (nonatomic, retain) NSNumber * type;          //试题类型 试题类型 1:单选 2:多选 3:判断 4:简答
@property (nonatomic, retain) NSString * answers;       //试题答案选项(选项1|选项2),判断题此行无数据,简答题此行为答案
@property (nonatomic, retain) NSString * corrects;      //试题答案实体,此项数据库中不存储
@property (nonatomic, retain) NSString * selected;      //试题正确选项 单选题(0,1,2,3),多选题(0|1),判断题(-1为错 0为对),简答题此行无数据
@property (nonatomic, retain) NSString * analysis;      //考生选择的答案 填写形式与corrects字段一样
@property (nonatomic, retain) NSString * value;         // 试题分值
@property (nonatomic, retain) NSString * image;         //试题图片
@property (nonatomic, retain) NSNumber * favourite;     // 收藏
@property (nonatomic, retain) NSNumber * wrong;         // 错题标记

@end

@protocol RegionDataProtocol <NSObject>

@property (nonatomic, retain) NSNumber * regionId;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * show;

@end
