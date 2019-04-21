//
//  SJTaskQueue.m
//  Pods
//
//  Created by BlueDancer on 2019/2/28.
//

#import "SJTaskQueue.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJTaskQueues : NSObject
- (void)addQueue:(SJTaskQueue *)q;
- (void)removeQueue:(NSString *)name;
- (nullable SJTaskQueue *)getQueue:(NSString *)name;
@end

@implementation SJTaskQueues {
    NSMutableDictionary *_m;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _m = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addQueue:(SJTaskQueue *)q {
    if ( !q ) return;
    [_m setValue:q forKey:q.name];
}

- (void)removeQueue:(NSString *)name {
    [_m removeObjectForKey:name];
}
- (nullable SJTaskQueue *)getQueue:(NSString *)name {
    SJTaskQueue *_Nullable q = _m[name];
    return q;
}
@end

#pragma mark -
typedef struct SJTaskItem {
    struct SJTaskItem *next;
    CFTypeRef task;
} SJTaskItem;

static inline void _SJTaskItemFree(SJTaskItem *item) {
    if ( item->task ) {
        CFRelease(item->task);
        item->task = NULL;
    }
    free(item);
}

typedef enum : NSUInteger {
    SJQueueState_inIdle,
    SJQueueState_isExecuting,
    SJQueueState_isDequeueing,
} SJQueueState;

static NSString *const kSJTaskMainQueue = @"com.SJTaskQueue.main";

@interface SJTaskQueue ()
@property (nonatomic) NSTimeInterval delaySecs;
@property (nonatomic) SJTaskItem *head;
@property (nonatomic) SJTaskItem *tail;
@property (nonatomic) SJQueueState state;
@property (nonatomic) BOOL isDelay;
@end

@implementation SJTaskQueue
static SJTaskQueues *_queues;
/// 在当前的RunLoop中创建一个任务队列
///
/// - 请使用唯一的队列名称, 同名的队列将会被移除
/// - 调用destroy后, 该队列将会被移除
+ (SJTaskQueue * _Nonnull (^)(NSString * _Nonnull))queue {
    return ^SJTaskQueue *(NSString *name) {
        NSParameterAssert(name);
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _queues = [SJTaskQueues new];
        });
        SJTaskQueue *_Nullable q = [_queues getQueue:name];
        if ( !q ) {
            if ( name != kSJTaskMainQueue ) {
                q = [[SJTaskQueue alloc] initWithName:name runLoop:CFRunLoopGetCurrent() mode:kCFRunLoopCommonModes];
            }
            else {
                q = [[SJTaskQueue alloc] initWithName:name runLoop:CFRunLoopGetMain() mode:kCFRunLoopCommonModes];
            }
            [_queues addQueue:q];
        }
        return q;
    };
}

/// 在mainRunLoop中创建的任务队列
///
/// - 调用destroy后, 再次获取该队列将会重新创建
+ (SJTaskQueue *)main {
    return self.queue(kSJTaskMainQueue);
}

/// 销毁某个队列
+ (void (^)(NSString * _Nonnull))destroy {
    return ^(NSString *name) {
        if ( name.length < 1 )
            return ;
        SJTaskQueue *_Nullable q = [_queues getQueue:name];
        if ( q ) q.destroy();
    };
}

static NSString *kState = @"state";
- (instancetype)initWithName:(NSString *)name runLoop:(CFRunLoopRef)runLoop mode:(CFRunLoopMode)mode {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - -[%@ %s]", (int)__LINE__, NSStringFromClass([self class]), sel_getName(_cmd));
#endif
    [self _emptyQueue];
}

#pragma mark -

- (SJTaskQueue * _Nullable (^)(SJTaskHandler _Nonnull))enqueue {
    return ^SJTaskQueue *(SJTaskHandler task) {
        SJTaskItem *new_item = (SJTaskItem *)malloc(sizeof(SJTaskItem));
        new_item->next = NULL;
        new_item->task = CFBridgingRetain(task);
        [self _enqueue:new_item];
        [self _excNextTaskIfNeeded];
        return self;
    };
}

- (SJTaskQueue * _Nullable (^)(void))dequeue {
    return ^SJTaskQueue *(void) {
        [self _dequeue:NO];
        return self;
    };
}

- (SJTaskQueue * _Nullable (^)(NSTimeInterval secs))delay {
    return ^SJTaskQueue *(NSTimeInterval secs) {
        self.delaySecs = secs;
        return self;
    };
}

- (SJTaskQueue * _Nullable (^)(void))empty {
    return ^SJTaskQueue *(void) {
        [self _emptyQueue];
        return self;
    };
}

- (void (^)(void))destroy {
    return ^ {
        [self _emptyQueue];
        [_queues removeQueue:self.name];
    };
}

#pragma mark -
- (void)_excNextTaskIfNeeded {
    if ( _state == SJQueueState_inIdle && _head && !_isDelay ) {
        _isDelay = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delaySecs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _performTaskOfHeadItem];
        });
    }
}

- (void)_performTaskOfHeadItem {
    if ( _head && _state == SJQueueState_inIdle ) {
        _state = SJQueueState_isExecuting;
        
        SJTaskItem *item = _head;
        SJTaskHandler block = (__bridge SJTaskHandler)item->task;
        !block?:block();
        
        [self _dequeue:YES];
    }
    _isDelay = NO;
    _state = SJQueueState_inIdle;
    [self _excNextTaskIfNeeded]; // here is safe
}

- (void)_dequeue:(BOOL)isExecuted {
    if ( _head && (_state == SJQueueState_inIdle || isExecuted) ) {
        self.state = SJQueueState_isDequeueing;
        
        SJTaskItem *item = _head;
        _head = item->next;
        if ( !_head ) {
            _tail = NULL;
        }
        _SJTaskItemFree(item);
        
        if ( !isExecuted ) self.state = SJQueueState_inIdle;
    }
}

- (void)_enqueue:(SJTaskItem *)new_item {
    if (__builtin_expect(!_head, 0) ) {
        _head = new_item;
    }
    else {
        _tail->next = new_item;
    }
    _tail = new_item;
}

- (void)_emptyQueue {
    if ( _head ) {
        if ( _state == SJQueueState_inIdle ) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            _isDelay = NO;
        }
        
        SJTaskItem *item = (_state == SJQueueState_inIdle)?_head:_head->next;
        
        while (item) {
            SJTaskItem *next = item->next;
            _SJTaskItemFree(item);
            item = next;
        }
        
        _head = NULL;
        _tail = NULL;
    }
}
@end
NS_ASSUME_NONNULL_END
