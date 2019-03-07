#include <stdio.h>
#include <SDL2/SDL.h>

int main()
{
    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window * window = SDL_CreateWindow("",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        640, 480,
        SDL_WINDOW_RESIZABLE);

    SDL_Surface * window_surface = SDL_GetWindowSurface(window);

    unsigned int * pixels = window_surface->pixels;
    int width = window_surface->w;
    int height = window_surface->h;

    printf("Pixel format: %s\n",
        SDL_GetPixelFormatName(window_surface->format->format));

    while (1)
    {
        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            if (event.type == SDL_QUIT) exit(0);
            if (event.type == SDL_WINDOWEVENT)
            {
                if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
                {
                    window_surface = SDL_GetWindowSurface(window);
                    pixels = window_surface->pixels;
                    width = window_surface->w;
                    height = window_surface->h;
                    printf("Size changed: %d, %d\n", width, height);
                }
            }
        }

        // Set every pixel to white.
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                pixels[x + y * width] =
                    SDL_MapRGBA(window_surface->format, 200, 100, 250, 255);
            }
        }

        SDL_UpdateWindowSurface(window);
    }
}
