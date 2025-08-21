# VBB, the Very Basic Bootloader
Some experimentation with making an x86 bootloader, built upon [Nir Lichtman's own tutorial](https://www.youtube.com/watch?v=xFrMXzKCXIc).

# dependencies
Dependencies needed are `nasm`, `qemu-system-i386`, and `tigervnc`. 

You can avoid using `tigervnc` by simply having GUI support with your Qemu install. On Arch, I personally have installed the `qemu-system-i386` package and `tigervnc`; installation may differ for your distro.

# assembly and testing
Just assemble w/ `nasm` lol:

```bash
nasm bootloader.s
```

Now run it with `qemu`:

```bash
qemu-system-i386 bootloader
```

Access the VNC server with a viewer, such as TigerVNC:

```bash
vncviewer localhost:0
```

Note that the port may differ if you supply the `-vnc` flag and modify the hosting port.

# current functions
Prints text to the screen in real/protected mode and halts. Das it lol. 

Next steps are actually getting a kernel going w/ it. Daedalus is goated indeed.
# showcase
![VBB in action ye](https://github.com/nubbsterr/vbb/blob/main/images/vbb2-0.png)
