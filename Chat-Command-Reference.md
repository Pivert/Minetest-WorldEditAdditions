# Chat Command Reference

This is the full chat command reference for WorldEditAdditions. Having trouble finding the section you want? Try the **[quick reference](https://github.com/sbrl/Minetest-WorldEditAdditions#quick-command-reference)** instead, which has links to back to sections of this document!

Other useful links:

 - [WorldEditAdditions quick reference](https://github.com/sbrl/Minetest-WorldEditAdditions#quick-command-reference)
 - [WorldEditAdditions Chat Command Cookbook](https://github.com/sbrl/Minetest-WorldEditAdditions/blob/master/Cookbook.md)
 - [WorldEdit Chat Command Reference](https://github.com/Uberi/Minetest-WorldEdit/blob/master/ChatCommands.md)
 - [`we_env`](https://github.com/sfan5/we_env#readme)


## `//floodfill [<replace_node> [<radius>]]`
Floods all connected nodes of the same type starting at _pos1_ with <replace_node> (which defaults to `water_source`), in a sphere with a radius of <radius> (which defaults to 50).

```
//floodfill
//floodfill water_source 50
//floodfill glass 25
```

## `//overlay <node_name_a> [<chance[<snowballs|...> [<key_1> [<vaue_1>]] [<key_2> [<value_2>]] ...]_a>] <node_name_b> [<chance_b>] [<node_name_N> [<chance_N>]] ...`
Places `<node_name_a>` in the last contiguous air space encountered above the first non-air node. In other words, overlays all top-most nodes in the specified area with `<node_name_a>`. Optionally supports a mix of node names and chances, as `//mix` (WorldEdit) and `//replacemix` (WorldEditAdditions) does.

Will also work in caves, as it scans columns of nodes from top to bottom, skipping every non-air node until it finds one - and only then will it start searching for a node to place the target node on top of.

Note that all-air columns are skipped - so if you experience issues with it not overlaying correctly, try `//expand down 1` to add an extra node's space to your defined region.

Note also that columns without any air nodes in them at all are also skipped, so try `//expand y 1` to add an extra layer to your defined region.

```
//overlay grass
//overlay glass
//overlay grass_with_dirt
//overlay grass_with_dirt 10 dirt
//overlay grass_with_dirt 10 dirt 2 sand 1
//overlay sandstone dirt 2 sand 5
```

## `//layers [<node_name_1> [<layer_count_1>]] [<node_name_2> [<layer_count_2>]] ...`
Finds the first non-air node in each column and works downwards, replacing non-air nodes with a defined list of nodes in sequence. Like WorldEdit for Minecraft's `//naturalize` command, and also similar to [`we_env`'s `//populate`](https://github.com/sfan5/we_env). Speaking of, this command has `//naturalise` and `//naturalize` as aliases. Defaults to 1 layer of grass followed by 3 layers of dirt.

The list of nodes has a form similar to that of a chance list you might find in `//replacemix`, `//overlay`, or `//mix` - see the examples below. If the numberr of layers isn't specified, `1` is assumed (i.e. a single layer).

```
//layers dirt_with_grass dirt 3
//layers sand 5 sandstone 4 desert_stone 2
//layers brick stone 3
//layers cobble 2 dirt
```

## `//forest [<density>] <sapling_a> [<chance_a>] <sapling_b> [<chance_b>] [<sapling_N> [<chance_N>]] ...`
Plants and grows saplings to generate a forest. A density value is optionally taken, which controls the overall density of the forest that is generated. The `bonemeal` mod is required - just like for the [`//bonemeal`](#bonemeal-strength-chance) command.

The density defaults to 1, acts like a multiplier, and is not affected by the chances of all saplings listed (e.g. you can have a sapling with a chance of 1-in-50, and the overall density of the forest will be unaffected). For example, 2 results in a forest twice as dense as the default, and 0.5 a forest half as dense as the default density.

The tree types are provided as a list of names and 1-in-N chances, just like [`//overlay`](#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-), `//mix`, `//layers`, etc. Unlike the aforementioned commands however, `//forest` has an additional layer of alias resolution to ease the process of determining what the name of the sapling is you want to use to generate forests with. See [`//saplingaliases`](#saplingaliases-aliasesall_saplings) for more details.

Saplings are placed with [`//overlay`](#overlay-node_name_a-chance_a-node_name_b-chance_b-node_name_n-chance_n-) and grown using the same method that's used by the `//bonemeal` command. Up to 100 attempts are made to grow placed saplings. If all of those attempts fail (success is determined by whether the sapling is still present or not), the sapling is removed and the failure counter is incremented.

Currently, the following mods are known to have aliases registered:

 - `default`
 - [`moretrees`](https://content.minetest.net/packages/VanessaE/moretrees/) (warning: these saplings don't appear to work very well this command - assistance in debugging this would be very helpful)
 - [`cool_trees`](https://content.minetest.net/packages/runs/cool_trees/)

If you like, you can also reference the full name of a sapling node instead. The only requirements for saplings to be supported by this mod are:

1. It can be bonemealed
2. It has the `sapling` group

For example, the first 2 examples below are functionally equivalent.

```
//forest aspen
//forest default:aspen_sapling
//forest 2 oak 3 aspen pine
//forest 0.5 acacia
```

## `//saplingaliases [aliases|all_saplings]`
Lists all the currently registered sapling aliases in alphabetical order. These aliases can be used in the `//forest` subcommand.

Optionally takes a single parameter, which is the operating mode. Current implemented operating modes:

Mode			| Description
----------------|----------------------
`aliases`		| The default. Lists all the currently registered sapling aliases in alphabetical order.
`all_saplings`	| Spins through all the nodes currently registered in Minetest, and lists all the nodes that have the `sapling` group.

```
//saplingaliases
//saplingaliases all_saplings
//saplingaliases aliases
```


## `//fillcaves [<node_name>]`
Fills in all airlike nodes beneath non airlike nodes, which gives the effect of filling in caves. Defaults to filling in with stone, but this can be customised.

```
//fillcaves
//fillcaves dirt
//fillcaves brick
```

## `//ellipsoid <rx> <ry> <rz> <node_name>`
Creates a solid ellipsoid at position 1 with the radius `(rx, ry, rz)`.

```
//ellipsoid 10 5 15 ice
//ellipsoid 3 5 10 dirt
//ellipsoid 20 10 40 air
```

## `//hollowellipsoid <rx> <ry> <rz> <node_name>`
Creates a hollow ellipsoid at position 1 with the radius `(rx, ry, rz)`. Works the same way as `//ellipsoid` does.

```
//hollowellipsoid 10 5 15 glass
//hollowellipsoid 21 11 41 stone
```

## `//torus <major_radius> <minor_radius> <node_name>`
Creates a solid torus at position 1 with the specified major and minor radii. The major radius is the distance from the centre of the torus to the centre of the circle bit, and the minor radius is the radius of the circle bit.

```
//torus 15 5 stone
//torus 5 3 meselamp
```

## `//hollowtorus <major_radius> <minor_radius> <node_name>`
Creates a hollow torus at position 1 with the radius major and minor radii. Works the same way as `//torus` does.

```
//hollowtorus 10 5 glass
//hollowtorus 21 11 stone
```

## `//line [<replace_node> [<radius>]]`
Draw a line from position 1 to position 2, optionally with a given thickness.

The radius can be thought of as the thickness of the line, and is defined as the distance from a given node to an imaginary line from pos1 to pos2. Defaults to drawing with dirt and a radius of 1.

Floating-point values are fully supported for the radius.

```
//line
//line stone
//line sandstone 3
//line glass 0.5
```

## `//hollow [<wall_thickness>]`
Replaces nodes inside the defined region with air, but leaving a given number of nodes near the outermost edges alone. In other words, it makes the defined region hollow, while leaving walls around the edges of a given thickness (defaulting to a wall thickness of 1).

Note that all air-like nodes are also left alone.

```
//hollow
//hollow 2
```

## `//maze <replace_node> [<path_length> [<path_width> [<seed>]]]`
Generates a maze using replace_node as the walls and air as the paths. Uses [an algorithm of my own devising](https://starbeamrainbowlabs.com/blog/article.php?article=posts/070-Language-Review-Lua.html) (see also [this post of mine that has lots of eye candy :D](https://starbeamrainbowlabs.com/blog/article.php?article=posts/429-lua-blender-mazes.html)). It is guaranteed that you can get from every point to every other point in generated mazes, and there are no loops.

Requires the currently selected area to be at least 3x3 on the x and z axes respectively.

The optional `path_length` and `path_width` arguments require additional explanation. When generating a maze, a multi-headed random walk is performed. When the generator decides to move forwards from a point, it does so `path_length` nodes at a time. `path_length` defaults to `2`.

`path_width` is easier to explain. It defaults to `1`, and is basically the number of nodes wide the path generated is.

Note that `path_width` must always be at least 1 less than the `path_length` in order to operate normally.

Note also that since WorldEditAdditions v1.10, the seed doesn't have to be a number (but it can't contain spaces due to the parsing algorithm used). Non-numbers are hashed to a number using a simple (non-crypto-safe) hashing algorithm.

The last example below shows how to set the path length and width:

```
//maze ice
//maze stone 2 1 1234
//maze dirt 4 2 56789
//maze glass 2 1 minetestiscool
```

## `//maze3d <replace_node> [<path_length> [<path_width> [<path_depth> [<seed>]]]]`
Same as `//maze`, but adapted for 3d - has all the same properties. Note that currently there's no way to adjust the height of the passageways generated (you'll need to scale the generated maze afterwards).

Requires the currently selected area to be at least 3x3x3.

The optional `path_depth` parameter defaults to `1` and allows customisation of the height of the paths generated.

```
//maze3d glass
//maze3d bush_leaves 2 1 1 12345
//maze3d dirt 4 2 2
//maze3d stone 6 3 3 54321
```

## `//bonemeal [<strength> [<chance>]]`
Requires the [`bonemeal`](https://content.minetest.net/packages/TenPlus1/bonemeal/) ([repo](https://notabug.org/TenPlus1/bonemeal/)) mod (otherwise _WorldEditAdditions_ will not register this command and output a message to the server log). Alias: `//flora`.

Bonemeals all eligible nodes in the current region. An eligible node is one that has an air node directly above it - note that just because a node is eligible doesn't mean to say that something will actually happen when the `bonemeal` mod bonemeals it.

Optionally takes a strength value (that's passed to `bonemeal:on_use()`, the method in the `bonemeal` mod that is called to actually do the bonemealing). The strength value is a positive integer from 1 to 4 (i.e. 1, 2, 3, or 4) - the default is 1 (the lowest strength).

I observe that a higher strength value gives a higher chance that something will actually grow. In the case of soil or sand nodes, I observe that it increases the area of effect of a single bonemeal action (thus at higher strengths generally you'll probably want a higher chance number - see below). See the [`bonemeal` mod README](https://notabug.org/TenPlus1/bonemeal) for more information.

Also optionally takes a chance number. This is the chance that an eligible node will actually get bonemealed, and is a positive integer that defaults to 1. The chance number represents a 1-in-{number} chance to bonemeal any given eligible node, where {number} is the chance number. In other words, the higher the chance number the lower the chance that a node will be bonemealed.

For example, a chance number of 2 would mean a 50% chance that any given eligible node will get bonemealed. A chance number of 16 would be a 6.25% chance, and a chance number of 25 would be 2%.

```
//bonemeal
//bonemeal 3 25
//bonemeal 4
//bonemeal 1 10
//bonemeal 2 15
```

## `//walls <replace_node>`
Creates vertical walls of `<replace_node>` around the inside edges of the defined region.

```
//walls dirt
//walls stone
//walls goldblock
```

## `//replacemix <target_node> [<chance>] <replace_node_a> [<chance_a>] [<replace_node_b> [<chance_b>]] [<replace_node_N> [<chance_N>]] ...`
Replaces a given node with a random mix of other nodes. Functions like `//mix`.

This command is best explained with examples:

```
//replacemix dirt stone
```

The above functions just like `//replace` - nothing special going on here. It replaces all `dirt` nodes with `stone`.

Let's make it more interesting:

```
//replacemix dirt 5 stone
```

The above replaces 1 in every 5 `dirt` nodes with `stone`. Let's get even fancier:

```
//replacemix stone stone_with_diamond stone_with_gold
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes. But wait - there's more!

```
//replacemix stone stone_with_diamond stone_with_gold 4
```

The above replaces `stone` nodes with a random mix of `stone_with_diamond` and `stone_with_gold` nodes as before, but this time in the ratio 1:4 (i.e. for every `stone_with_diamond` node there will be 4 `stone_with_gold` nodes). Note that the `1` for `stone_with_diamond` is implicit there.

If we wanted to put all of the above features together into a single command, then we might do this:

```
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```

The above replaces 1 in 3 `dirt` nodes with a mix of `sandstone`, `dry_dirt`, and `cobble` nodes in the ratio 10:1:2. Awesome!

Here are all the above examples together:

```
//replacemix dirt stone
//replacemix dirt 5 stone
//replacemix stone stone_with_diamond stone_with_gold
//replacemix stone stone_with_diamond stone_with_gold 4
//replacemix dirt 3 sandstone 10 dry_dirt cobble 2
```

## `//convolve <kernel> [<width>[,<height>]] [<sigma>]`
Advanced version of `//smooth` from we_env, and one of the few WorldEditAdditions commands to have any aliases (`//smoothadv` and `//conv`).

Extracts a heightmap from the defined region and then proceeds to [convolve](https://en.wikipedia.org/wiki/Kernel_(image_processing)) over it with the specified kernel. The kernel can be thought of as the filter that will be applied to the heightmap. Once done, the newly convolved heightmap is applied to the terrain. 

Possible kernels:

Kernel			| Description
----------------|------------------------------
[`box`](https://en.wikipedia.org/wiki/Box_blur)		| A simple uniform box blur.
`pascal`		| A kernel derived from the odd layers of [Pascal's Triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle). Slightly less smooth than a Gaussian blur.
[`gaussian`](https://en.wikipedia.org/wiki/Gaussian_blur)	| The default. A Gaussian blur - should give the smoothest result, and also the most customisable - see below.

If you can think of any other convolutional filters that would be useful, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new). The code backing this command is very powerful and flexible, so adding additional convolutional filters should be pretty trivial.

The width and height (if specified) refer to the dimensions of the kernel and must be odd integers and are separated by a single comma (and _no_ space). If the height is not specified, it defaults to the width. If using the `gaussian` kernel, the width and height must be identical. Larger kernels are slower, but produce a more smoothed effect and take more nearby nodes into account for every column. Defaults to a 5x5 kernel.

The sigma value is only applicable to the `gaussian` kernel, and can be thought of as the 'smoothness' to apply. Greater values result in more smoothing. Default: 2. See the [Gaussian blur](https://en.wikipedia.org/wiki/Gaussian_blur) page on Wikipedia for some pictures showing the effect of the sigma value.

```
//convolve
//convolve box 7
//convolve pascal 11,3
//convolve gaussian 7
//convolve gaussian 9 10
//convolve gaussian 5 0.2
```

### `//erode [<snowballs|...> [<key_1> [<value_1>]] [<key_2> [<value_2>]] ...]`
Runs an erosion algorithm over the defined region, optionally passing a number of key - value pairs representing parameters that are passed to the chosen algorithm. This command is **experimental**, as the author is currently on-the-fence about the effects it produces.

Currently implemented algorithms:

Algorithm	| Mode	| Description
------------|-------|-------------------
`snowballs`	| 2D	| The default - based on [this blog post](https://jobtalle.com/simulating_hydraulic_erosion.html). Simulates snowballs rolling across the terrain, eroding & depositing material. Then runs a 3x3 gaussian kernel over the result (i.e. like the `//conv` / `//smoothadv` command).

Usage examples:

```
//erode
//erode snowballs
//erode snowballs count 25000
```

Each of the algorithms above have 1 or more parameters that they support. These are detailed below.

## Algorithm: `snowballs`
Based on the algorithm detailed in [this blog post](https://jobtalle.com/simulating_hydraulic_erosion.html) ([direct link to the source code](https://github.com/jobtalle/HydraulicErosion/blob/master/js/archipelago/island/terrain/erosionHydraulic.js)), devised by [Job Talle](https://jobtalle.com/).

Parameter			| Type		| Default Value		| Description
--------------------|-----------|-------------------|------------------------
rate_deposit		| `float`	| 0.03				| The rate at which snowballs will deposit material
rate_erosion		| `float`	| 0.04				| The rate at which snowballs will erode material
friction			| `float`	| 0.07				| More friction slows snowballs down more.
speed				| `float`	| 1					| Speed multiplier to apply to snowballs at each step.
max_steps			| `float`	| 80				| The maximum number of steps to simulate each snowball for.
velocity_hist_count	| `float`	| 3					| The number of previous history values to average when detecting whether a snowball has stopped or not
init_velocity		| `float`	| 0.25				| The maximum random initial velocity of a snowball for each component of the velocity vector.
scale_iterations	| `float`	| 0.04				| How much to scale erosion by as time goes on. Higher values mean that any given snowball will erode more later on as more steps pass.
maxdiff				| `float`	| 0.4				| The maximum difference in height (between 0 and 1) that is acceptable as a percentage of the defined region's height.
count				| `float`	| 25000				| The number of snowballs to simulate.
noconv				| any		| n/a				| When set to any value, disables to automatic 3x3 gaussian convolution.

If you find any good combinations of these parameters, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) (or a PR!) and let me know! I'll include good combinations here.


## `//count`
Counts all the nodes in the defined region and returns the result along with calculated percentages (note that if the chat window used a monospace font, the returned result would be a perfect table. If someone has a ~~hack~~ solution to make the columns line up neatly, please [open an issue](https://github.com/sbrl/Minetest-WorldEditAdditions/issues/new) :D)

```
//count
```

## `//subdivide <size_x> <size_y> <size_z> <cmd_name> <args>`
Splits the current WorldEdit region into `(<size_x>, <size_y>, <size_z>)` sized chunks, and run `//<cmd_name> <args>` over each chunk. 

Sometimes, we want to run a single command on a truly vast area. Usually, this results in running out of memory. If this was you, then this command is just what you need! It should be able to handle any sized region - the only limit is your patience for command to complete.....

Note that this command only works with WorldEdit commands, and only those which require 2 points (e.g. `//torus` only requires a single point, so it wouldn't work very well - but `//set` or `//clearcut` would).

Note also that `<cmd_name>` should _not_ be prefixed with _any_ forward  slashes - see the examples below.

While other server commands can be executed while a `//subdivide` is running, `//subdivide` manipulates your player's defined region when running. This has the side-effect that you can check on where it has got up to with `//p get` for example - but means that attempting to change your pos1 & pos2 manually will have no effect until the `//subdivide` completes.

**Warning:** Once started, this command cannot be stopped without restarting your server! This is the case with all WorldEdit commands, but it's worth a special mention here.

```
//subdivide 10 10 10 set dirt
//subdivice 25 25 25 fixlight
```

## `//multi <command_a> <command_b> <command_c> .....`
Executes multi chat commands in sequence. Intended for _WorldEdit_ commands, but does work with others too. Don't forget a space between commands!

```
//multi //1 //2 //shift z -10 //sphere 5 sand //shift z 20 //ellipsoid 5 3 5 ice
//multi //1 //hollowtorus 30 5 stone //hollowtorus 20 3 dirt //torus 10 2 dirt_with_grass
//multi /time 7:00 //1 //outset h 20 //outset v 5 //overlay dirt_with_grass //1 //2 //sphere 8 air //shift down 1 //floodfill //reset
```

## `//many <times> <command>`
Executes a single chat command many times in a row. Uses `minetest.after()` to yield to the main server thread to allow other things to happen at the same time, so technically you could have multiple `//many` calls going at once (but multithreading support is out of reach, so only a single one will be executing at the same time).

Note that this isn't necessarily limited to executing WorldEdit / WorldEditAdditions commands. Combine with `//multi` (see above) execute multiple commands at once for even more power and flexibility!

```
//many 10 //bonemeal 3 100
//many 100 //multi //1 //2 //outset 20 //set dirt
```

## `//ellipsoidapply <command_name> <args>`
Executes the given command, and then clips the result to the largest ellipsoid that will fit inside the defined region. The specified command must obviously take 2 positions - so for example `//set`, `//replacemix`, and `//maze3d` will work, but `//sphere`, `//torus`, and `//floodfill` won't.

```
//ellipsoidapply set dirt
//ellipsoidapply maze3d dirt 4 2 2
//ellipsoidapply erode
//ellipsoidapply replacemix sand bakedclay:red bakedclay:orange
//ellipsoidapply layers desert_sand sand 2 desert_sandstone 4 sandstone 10
```


## `//y`
Confirms the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```
//y
```

## `//n`
Prevents the execution of a command if it could potentially affect a large number of nodes and take a while. This is a regular WorldEdit command.

<!-- Equivalent to _WorldEdit_'s `//y`, but because of security sandboxing issues it's not really possible to hook into WorldEdit's existing command. -->

```
//n
```


## Far Wand
The far wand (`worldeditadditions:farwand`) is a variant on the traditional WorldEdit wand (`worldedit:wand`). It looks like this: ![A picture of the far wand](https://raw.githubusercontent.com/sbrl/Minetest-WorldEditAdditions/master/worldeditadditions_farwand/textures/worldeditadditions_farwand.png)

It functions very similarly to the regular WorldEdit wand, except that it has a _much_ longer range - which can be very useful for working on large-scale terrain for example. It also comes with an associated command to control it.

## `//farwand skip_liquid (true|false) | maxdist <number>`
This command helps control the behaviour of the [WorldEditAdditions far wand](#far-wand). Calling it without any arguments shows the current status:

```
//farwand
```

You can decide whether you can select liquids or not like so:

```
//farwand skip_liquid true
//farwand skip_liquid false
```

You can change the maximum range with the `maxdist` subcommand:

```
//farwand maxdist 1000
//farwand maxdist 200
//farwand maxdist 9999
```

Note that the number there isn't in blocks (because hard maths). It is however proportional to the distance the wand will raycast looks for nodes, so a higher value will result in it raycasting further.
