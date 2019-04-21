//
//  SJTaskQueue.h
//  Pods
//
//  Created by BlueDancer on 2019/2/28.
//

#import <Foundation/Foundation.h>
typedef void(^SJTaskHandler)(void);

/// 此队列的所有方法, 你应该总在主线程中调用
/// 此队列的所有方法, 你应该总在主线程中调用

NS_ASSUME_NONNULL_BEGIN
@interface SJTaskQueue : NSObject
@property (class, nonatomic, copy, readonly) SJTaskQueue *(^queue)(NSString *name);
@property (class, nonatomic, copy, readonly) SJTaskQueue *main;
@property (class, nonatomic, copy, readonly) void(^destroy)(NSString *name);

/// 执行下一次任务时, 延迟多少秒
@property (nonatomic, copy, readonly) SJTaskQueue *_Nullable(^delay)(NSTimeInterval secs);
/// enqueue, Add a task to the queue.
///
/// - This task will be autoexecuted.
@property (nonatomic, copy, readonly) SJTaskQueue *_Nullable(^enqueue)(SJTaskHandler task);
/// dequeue, This method will delete the first task in the queue.
///
/// - The first task will not be executed.
@property (nonatomic, copy, readonly) SJTaskQueue *_Nullable(^dequeue)(void);
/// Empty the tasks in the queue.
@property (nonatomic, copy, readonly) SJTaskQueue *_Nullable(^empty)(void);
/// Destroy queue.
@property (nonatomic, copy, readonly) void(^destroy)(void);

@property (nonatomic, strong, readonly) NSString *name;
@end
NS_ASSUME_NONNULL_END
