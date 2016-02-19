#include <unistd.h>
#include <ruby.h>

static VALUE module_delay;

static VALUE delay (VALUE module, VALUE seconds) {
    sleep(seconds);
    if (rb_block_given_p()) {
        rb_yield(Qnil);
    }
    return Qnil;
}

void Init_delay() {
    module_delay = rb_define_module("C_Delay");
    rb_define_module_function(module_delay, "delay", delay, 1);
}

