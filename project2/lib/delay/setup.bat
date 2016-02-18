swig -ruby delay.i

gcc -shared -o delay.so delay.c delay_wrap.c -IC:\Ruby200-x64\include\ruby-2.0.0 -IC:\Ruby200-x64\include\ruby-2.0.0\x64-mingw32 -lruby