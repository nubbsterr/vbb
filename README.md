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
Prints text to the screen and halts. Das it lol. 

Colour output for text is not working which is odd, and maybe an issue with `vncviewer` or Qemu; unsure. 

Next steps are to get some user interaction going; some user input maybe to shutdown on a key press for instance.

# showcase
![VBB in action ye](https://github.com/nubbsterr/vbb/blob/main/images/vbb1-0.png)
