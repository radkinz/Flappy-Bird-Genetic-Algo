# Flappy Bird Genetic Algorithm

This program simulates natural selection, as the flappy birds evolve to learn how to fly through the pipes over time. Each generation, the birds are judged by a fitness algorithm,
which determines a bird's fitness by how many pipes they fly through. A weighted probability drawing, based on fitness, is then used to pick two birds each generation to breed.
The two birds' genotypes are randomly mixed during the breeding process, with a slight chance of mutation, to create a new generation of flappy birds.

## Genotypes
The two primary genotypes that are passed down each generation are color and jump behavior. The jumping behavior is a list of x-positions that correlate with the indices of the global pipe array.
This allows for when each pipe gets near specific x-positions, the bird will jump in response. 
