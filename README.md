# Molehill HeightmapViewer
Molehill HeightmapViewer is a tool to view heightmap images as 3d meshes, created with Actionscript3 and Stage3D API.
It was designed to browse images from the user's computer or load straight from internet (using a PHP proxy to avoid flash security restrictions).

Check online version: http://www.disturbedcoder.com/files/HeightmapViewer

You can navigate using the left panel to modify the view of the current heightmap. Also, you may exchange the source image used to generate the mesh, textures, lightning, etc.

This software is distribuited under the terms of the GNU Lesser Public License.

## Libraries
* AS3console: https://github.com/loteixeira/AS3console
* MinimalComps: https://github.com/minimalcomps/minimalcomps

## Initializing through FlashVars
You can start the application through FlashVars parameters.

General parameters:
* ```no_ui```: If true don't show accordion component with application options.
* ```no_fps```: If true hide fps counter.

Texture parameters:
* ```texture.middle```: Set the edge between top and bottom texture when creating result texture. Valid range is [0..255].
* ```texture.dimension```: Set the size of result texture. Valid values are 64x64, 128x128, 256x256, 512x512 and 1024x1024.
* ```texture.top_file```: URL to image file to be used as top texture.
* ```texture.bottom_file```: URL to image file to be used as bottom texture.

Heightmap mesh parameters:
* ```heightmap.height```: Height of terrain. Valid range is [1..10].
* ```heightmap.file```: URL to image file to be used to create heightmap mesh.

Visual parameters:
* ```visual.light```: Set light source type. Valid values are none, directional and point.
* ```visual.anti_aliasing```: Set anti aliasing. Valid values are 0, 2, 4 and 8.
* ```visual.background```: Set application background color. Must be specified in hexadecimal.
