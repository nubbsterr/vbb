# VBB, the Very Basic Bootloader (and Kernel) (and OS)
Some experimentation with making an x86 bootloader, built upon [Nir Lichtman's own tutorial](https://www.youtube.com/watch?v=xFrMXzKCXIc), with further assistance from [Daedalus Community's OSdev series](https://www.youtube.com/watch?v=MwPjvJ9ulSc).

Note: I don't plan on using a cross-compiler for this just cuz build time/downloading bunch of dependencies and my rootfs is 55% full lol. There is an Arch build script though for cross-compiling gcc though, which you can find [here](https://github.com/mell-o-tron/MellOs/blob/main/A_Setup/setup-gcc-arch.sh)!

This is made to be a toy project to see what OSdev is really about. 

# dependencies
Dependencies needed are `nasm`, `qemu-system-i386`, and `tigervnc`. 

You can avoid using `tigervnc` by simply having GUI support with your Qemu install. On Arch, I personally have installed the `qemu-system-i386` package and `tigervnc`; installation may differ for your distro.

# assembly and testing
**Without a cross-compiler I can't really compile this for my system however we can compile the bootloader and have fun with it.**

Simply run `nasm bootloader.s` then `qemu-system-i386 bootloader`. We can then access the VNC server using TigerVNC like so: `vncviewer localhost:0`.

Note that the port may differ if you supply the `-vnc` flag and modify the hosting port.

# current functions
- Prints text to the screen in real/protected mode and would load our kernel and execute however that is not the case at the moment since I didn't cross-compile anything.
    - What's crazier is that even without the kernel loaded anywhere it still continues to protected mode so I believe there's some undefined behaviour here but whaaaaatever.
- When trying to find kernel code from sectors, if letter 'K' shows up, it means that the bootloader failed to do so (too lazy for strings).
