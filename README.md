# FlutterCAD

Probably nothing to see here.

I've written a flat pattern drafting program in .NET as a declarative vector graphics language that correlates to fashion design books I've encountered. Now, after years of thought and experience in using other tools such as Fusion360 and Adobe Illustrator and such, I've decided to rewrite the program from the ground up. And I chose to do it in Dart and with Flutter.

At this time, the program does precisely nothing. It's just a bunch of CAD primitives and I'm working my way through documenting the math and creating unit tests for each algorithm I use.

## The planned work flow

### Implementation of CAD primitives

So far, I've managed to implement most of the true basics. Line line segments and intersections and such.

I'll implement bezier curves next. I'll start by porting my existing code (and cleaning up the math substantially). This was more than good enough for development of the earlier program.

Next I expect I'll finally implement functions for calculating intersections between
 - Lines and Lines
 - Curves and lines
 - Curves and curves

These will be pretty important for clipping a path by another path. I've already planned the math behind all of them. I suspect I'll lose 100+ hours on Geogebra getting them right.

### Implement a canvas

I've never coded a single line of Flutter before, but it seems to mean that the pattern is similar in many ways to Qt. I will make use of the Flutter canvas object to draw the objects on the screen. The canvas will be interactive and should behave similarly to Fusion360 when in sketch mode.

### Implement a document model

The document model I used in the past was great for operating as a strictly declarative language model. In fact, it was in reality, very static and all changes had to be made programmatically through the language and then the code would be reparsed.

I intend to implement a similar model in many ways this time. But the goal will be, rather than writing code, it the code will be generated interactively through the GUI. This will allow fast forwarding and rewinding through the steps of the code like Fusion360 can, but should also allow the functionality of a more advanced drawing program than I've created in the past.

#### The code of the document structure will be layers and groups.

This is a big mistake I made last time. I started with a flat document model and then attempted to add layers and groups afterwards. The drawback was that I found myself unable to add the features afterwards.
