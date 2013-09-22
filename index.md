# Code Walkabout

## Engines

The core classes within the Apsis system are called Engines.

### System Engine

This is the core engine that contains and initializes the remaining engines.

### Input Engine

This engine receives input from devices and converts them to Events and Actions.

### Object Engine

This engine loads objects and resources in the system and can retain and cache those objects as needed.

### Sound Engine

(yet to be implemented) This engine reacts to audio events and facilitates what is playing.

### Music Engine

(yet to be implemented) This engine is concerned with musical cues and playback.

### 

## Resources

Resources are elements within the system that can be loaded and presented.

### Game

The main resource that acts as a root resource to all others.

### Scene

This resource describes an environment in similar respect to a 'level' in that it describes the resources that should be loaded and acted upon. A Scene will refer to all resources it requires which can be loaded with it.

### Music

(yet to be implemented) This resource describes music.

### Sound

(yet to be implemented) This resource describes a sound or sound effect.

### Bindings

This resource maps key combinations to Actions.

### Thing

This resource describes a drawable object that can act and react with other such objects in the system.

### Map

This resource is a two-dimensional tile-based environment.

### Graphics

This resource describes a texture.

### Rule

This resource describes a set of behaviors and code that can be attached to an acting object in the system.
