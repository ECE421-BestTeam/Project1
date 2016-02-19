#include <unistd.h>
#include <time.h>
#include <ruby.h>

static VALUE module_delay;

static VALUE delayedAction (VALUE module, VALUE seconds, VALUE nanoSeconds) {
    struct timespec wait_time; 
    wait_time.tv_sec = seconds; 
    wait_time.tv_nsec = nanoSeconds;
    nanosleep(&wait_time, NULL); 
    
    if (rb_block_given_p()) {
        rb_yield(Qnil); // Call the action!
    }
    return Qnil;
}

void Init_delay() {
    module_delay = rb_define_module("C_Delay");
    rb_define_module_function(module_delay, "delayedAction", delayedAction, 2);
}

