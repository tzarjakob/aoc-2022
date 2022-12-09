Practical example of [nifs](https://www.erlang.org/doc/tutorial/nif.html).

1. compiling c and nif libraries

```console
make
# moving library so it is visibile to iex
cp part_two_nif.so ../../
```

2. use it via elixir

### Warning

If something wrong happens in the c or nif code, the VM crashes.