# Intro to Software Rendering with SDL2
Lets display some pixel data on the screen with [SDL2](https://libsdl.org/) in C. There are a few ways to do this, each with their own trade-offs. I am going to assume that you already have SDL2 set up. Here is the basic framework that our program will use, with the relevant pieces slotted in where the comments are.

```C
#include <SDL2/SDL.h>

int main()
{
    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window * window = SDL_CreateWindow("",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        640, 480,
        0);

    //
    // Set up the method for displaying the pixel buffer.
    //

    while (1)
    {
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT) exit(0);
        }

        //
        // Display the pixel buffer here.
        //
    }
}
```

## Method 1: *Accessing the Window Buffer*
The simplest method of getting pixels on screen is the function [`SDL_GetWindowSurface`](https://wiki.libsdl.org/SDL_GetWindowSurface). It gives back an [`SDL_Surface`](https://wiki.libsdl.org/SDL_Surface) containing our pixel buffer. We can then modify this buffer and display the changes we made using [`SDL_UpdateWindowSurface`](https://wiki.libsdl.org/SDL_UpdateWindowSurface).

```C
SDL_Surface * window_surface = SDL_GetWindowSurface(window);
```

Within this structure there is a pointer to the raw pixel buffer called `pixels`. This pointer is of type `void *`, so we need to cast it to be able to use it. You can do this by assigning the value of the internal pointer to your own pointer of the correct type -- `unsigned int`[^1].

```C
unsigned int * pixels = window_surface->pixels;
```

You can now access the pixel buffer directly. To set values of pixels using their `(x, y)` coordinates, you must use the formula `x + y * width` -- where `width` is the width of the pixel buffer -- to index into the buffer.

```C
// The coordinates of our pixel.
int x = 10;
int y = 30;

// You can get the width value from the surface itself if needed.
int width = window_surface->w;

pixels[x + y * width] = 0xffffffff;
```

Here I have used hexadecimal notation to specify the colour (white) that the pixel should be set. This is the part where this method of accessing the pixel buffer becomes more tricky, as the channel order (e.g. `RGBA`, `ARGB`, `BGRA`, ...) can vary between platforms and for other factors. You can find out what the pixel format is by reading the value at [`window_surface->format->format`](https://wiki.libsdl.org/SDL_PixelFormat), and you can print that out in a readable way using [`SDL_GetPixelFormatName`](https://wiki.libsdl.org/SDL_GetPixelFormatName).

```C
puts(SDL_GetPixelFormatName(window_surface->format->format));
```

Another necessary evil of this method is that if you change resolution at any point, perhaps if you are using a resizeable window or switch to full-screen mode, you will need to call `SDL_GetWindowSurface` again and get a new surface, as the original pointer is now invalid.

```C
// You should get the new pixel buffer whenever
// a SIZE_CHANGED window event comes in.
if (event.type == SDL_WINDOWEVENT)
{
    if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
    {
        window_surface = SDL_GetWindowSurface(window);
        pixels = window_surface->pixels;
    }
}
```

### Summary
This method is great to get jump started with software rendering in SDL2, and may work best on some platforms, such as the [Raspberry Pi](https://www.raspberrypi.org/). It takes a single function call to get access to the buffer, and another to update the window and show your graphics on screen. The downsides are that you may need to perform some kind of conversion if you aren't using the same pixel format in the rest of your code, and that you will need to access a new pixel buffer whenever the resolution of the window changes. Also, there is no way to enable [vertical sync](https://en.wikipedia.org/wiki/Screen_tearing).

[Click here to see the complete code example for this method.](files/sdl2_window_buffer.c)

## Method 2: *Streaming Texture*
The second method of displaying a pixel buffer on screen is via a 'streaming' texture. This is a chunk of GPU-side memory that is displayed on screen, which you can modify using a graphics API such as OpenGL or DirectX. SDL2 offers a simple method to use streaming textures that handles the API calls for you, using its [2D Accelerated Rendering API](https://wiki.libsdl.org/CategoryRender). This method requires more work to set up, but provides features that may make it easier for you to work with the pixel buffer.

Firstly, we must create an [`SDL_Renderer`](https://wiki.libsdl.org/SDL_Renderer), and an [`SDL_Texture`](https://wiki.libsdl.org/SDL_Texture).

```C
// Create a renderer with V-Sync enabled.
SDL_Renderer * renderer = SDL_CreateRenderer(window,
    -1, SDL_RENDERER_PRESENTVSYNC);

// Create a streaming texture of size 320 x 240.
SDL_Texture * screen_texture = SDL_CreateTexture(renderer,
    SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING,
    320, 240);
```

You may have noticed that in the call to `SDL_CreateTexture` that I specified the pixel format using the flag `SDL_PIXELFORMAT_RGBA8888`. This means that our texture is guaranteed to use the `RGBA` format, but there are [many formats](https://wiki.libsdl.org/SDL_PixelFormatEnum) you can choose. I also specified the resolution (`320x240`) in this call, and enabled V-Sync. This resolution does not need to be the same as your window resolution, as you will see later on.

As the texture is likely to be stored in GPU memory, we cannot access it with a pointer. In order to have a buffer we can modify directly we must create it ourselves.

```C
// Create a buffer large enough to hold the same
// number of pixels as the GPU-side texture.
// 320 is our width.
// 240 is our height.
// 4 is the size in bytes of a single RGBA pixel.
unsigned int * pixels = malloc(320 * 240 * 4);
```

We now have everything we need to display our graphics on screen, but this must be done in a few stages. Firstly, we must get our pixel data from the `pixels` buffer into the `screen_texture`. This is done using the function [`SDL_UpdateTexture`](https://wiki.libsdl.org/SDL_UpdateTexture).

```C
SDL_UpdateTexture(screen_texture, NULL, pixels, 320 * 4);
```

The `NULL` in this call is where you can specify a rectangular sub-section of the texture to update, if you only want to change it partially. We want to change the whole thing, so we pass `NULL` instead of a pointer to an `SDL_Rect`. The final parameter is the 'pitch' of the buffer, which is the number of bytes that make up a single row of pixels -- `320` is our width, and `4` is the number of bytes in a single pixel.

Now that our pixel data is in the texture, we need to display that texture on the screen. This is done using [`SDL_RenderCopy`](https://wiki.libsdl.org/SDL_RenderCopy).

```C
SDL_RenderCopy(renderer, screen_texture, NULL, NULL);
```

Same as before, the `NULL`s mean display the entire texture across the entire window. Now that we have rendered our texture we must display the result of our rendering using [`SDL_RenderPresent`](https://wiki.libsdl.org/SDL_RenderPresent).

```C
SDL_RenderPresent(renderer);
```

### Summary
***TODO***

[^1]: It is more correct to use `uint32_t`, which is defined in `<stdint.h>`. SDL also provides a `typedef`'d version of this type called `Uint32`, which you could use instead.
