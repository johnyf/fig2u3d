Export figure to 3D interactive PDF
===================================

Summary
-------
Export figure as a U3D file or directly to 3D interactive graphics within a PDF.
Licensed under 2-clause BSD.

Description
-----------
`fig2u3d` saves the figure as a `U3D` file for inclusion as an interactive 3-dimensional figure within a `PDF`. Either `LaTeX` or Adobe Acrobat can be used to embed the `U3D` file in the `PDF`.

The `idtf2u3d` executables are needed from [this project](http://sourceforge.net/projects/u3d/). To obtain them download [this](http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object) and place the `bin` directory in the `idtf2u3d` directory of the `fig2u3d` distribution.

A `vws` file is also created, which contains the current camera view of the axes saved. This file can be used to set the figure's default view in the PDF to be the same with the open figure window in `MATLAB`.

The [media9](http://www.ctan.org/tex-archive/macros/latex/contrib/media9) LaTeX package can import U3D files with their associated VWS files in a PDF document.

For PDF readers which do not render 3D figures, it is possible to include an alternative 2D image as a substitute to the 3D object. For conveniency, the script saves a 2D image together with U3D file. File type and other options for exporting this 2D image can be specified as additional arguments.

`fig2pdf3d` Converts the figure directly to a PDF containing only an interactive 3D graphics object.

Graphics object supported for export include:

- line
- surface
- patch
- quivergroup
- contourgroup

Line colors and marker styles, surfaces and `quivers` with `NaN`s and surface shading are supported. Multiple instances of various objects can be plotted in the same axes and exported. Note that some limitations apply, for example filled contours are not yet supported.

Dependencies
------------

- `fig2u3d` needs the idtf2u3d converter executable by downloading [this](http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object) and placing the `bin` directory in the `idtf2u3d` directory of the `fig2u3d` distribution.

- `fig2pdf3d` needs a latex distribution (e.g. [MikTeX](http://miktex.org/), [TeXLive](http://www.tug.org/texlive/), [MacTeX](http://tug.org/mactex/)) and [`media9`](http://www.ctan.org/pkg/media9) (preferred) or [`movie15`](http://www.ctan.org/pkg/movie15) LaTeX package (replaced by `media9`).

Included
--------
The distribution archive includes these dependencies (not in the git repository):

- [MATLAB mesh to PDF with 3d interactive object](http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object)
- [Generate vertices, faces and color for U3D format](http://www.mathworks.com/matlabcentral/fileexchange/27245-generate-vertices-faces-and-color-for-u3d-format)
- [Generate U3D files from STL models for making multi-layer 3D PDF figures](http://www.mathworks.com/matlabcentral/fileexchange/31413-generate-u3d-files-from-stl-models-for-making-multilayer-3d-pdf-figures)
- [Arclength](http://www.mathworks.com/matlabcentral/fileexchange/34871-arclength)
- [Vectorized MeshGrid](http://www.mathworks.com/matlabcentral/fileexchange/35036-vectorized-meshgrid)
- [Plot 2/3d Point(s)](http://www.mathworks.com/matlabcentral/fileexchange/34731-plot-23d-points)
- [Plot 2/3d Vector(s)](http://www.mathworks.com/matlabcentral/fileexchange/35224-plot-23d-vectors)
- [Take & restore hold](http://www.mathworks.com/matlabcentral/fileexchange/36641-take-restore-hold)
- [Normalize n-dim vectors](http://www.mathworks.com/matlabcentral/fileexchange/36248-normalize-n-d-vectors-in-single-matrix-or-n-component-matrices)
- [Cell Extrema](http://www.mathworks.com/matlabcentral/fileexchange/35983-cell-extrema)
- [Vector Norm](http://www.mathworks.com/matlabcentral/fileexchange/10708-vector-norm)
- [Verbatim](http://www.mathworks.com/matlabcentral/fileexchange/23194-verbatim-get-the-text-of-a-block-comment)

Acknowledgments
---------------
- [Create 3d interactive html file from MATLAB figure](http://www.mathworks.com/matlabcentral/fileexchange/27333-create-3d-interactive-html-file-from-matlab-surface)
- [MATLAB 3d figure to 3d xhtml](http://www.mathworks.com/matlabcentral/fileexchange/32207-matlab-3d-figure-to-3d-xhtml)
- [Remnan](http://www.mathworks.com/matlabcentral/fileexchange/10863-remnan)
- [Export Fig](http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig)

License
-------
This project is licensed under the 2-clause BSD license.
The license file includes the authors of all dependencies, so that they can be distributed with this project.

Hosted
------
Development on [github](https://github.com/johnyf/fig2u3d) and releases distributed also via the `MATLAB` [File Exchange](http://www.mathworks.com/matlabcentral/fileexchange/37640-export-figure-to-3d-interactive-pdf).

Keywords
--------
3d, u3d, graphics, export, save, plot, surface, vector, quiver, quivergroup, mesh, contourgroup, contour, data export, mathematics, vision, latex, pdf, media9, movie15, pdflatex, xelatex
