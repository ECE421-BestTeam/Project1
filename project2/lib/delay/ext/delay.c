#include <ruby.h>

static VALUE module_delay;

static VALUE delay (VALUE module, VALUE seconds) {
    printf("hey");
    return Qnil;
}

void Init_delay() {
    module_delay = rb_define_module("C_Delay");
    rb_define_module_function(module_delay, "delay", delay, 1);
}

