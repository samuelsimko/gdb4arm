=======
gdb4arm
=======


About
-----

This repository contains a script to compile ARM assembly
source code, run the executable with qemu and connect it to gdb.

It is intended for educational purposes.


Required software
-----------------

- arm-linux-gnueabi-gcc
- gdb
- qemu-arm

Usage
-----

.. code-block:: console

   $ ./gdb4arm.sh source_code_file.s [-a main]

Useful gdb commands
-------------------

See https://www.tutorialspoint.com/gnu_debugger/gdb_commands.htm
