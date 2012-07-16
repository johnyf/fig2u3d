function [] = fig2pdf3d(ax, filename, media9_or_movie15, pdforxelatex)
%FIG2PDF3D  Convert axes to PDF with embedded interactive 3D image.
%
% usage
%   FIG2PDF3D(ax, filename, media9_or_movie15)
%
% input
%   ax = axes object handle
%   filename = file name string (default = 'surface')
%   media9_or_movie15 = use media9 or movie15 LaTeX packages
%                     = 'media9' | 'movie15' (default = 'media9')
%
% output
%   Saves the axes object as a PDF with interactive 3D content.
%
% See also FIG2LATEX, LATEX2PDF3D, FIG2U3D, FIG2IDTF, IDTF2U3D.
%
% File:      fig2pdf3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.22
% Language:  MATLAB R2012a
% Purpose:   convert MATLAB figure to interactive 3D image embedded in PDF
%
% acknowledgment
%   Based on demo_mesh2pdf by Alexandre Gramfort.
%   This can be found on the MATLAb Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

%% input
if nargin < 1
    ax = gca;
end

% Set the output Latex filename
if nargin < 2
    filename = 'surface';
end

% which package to use ?
if nargin < 3
    media9_or_movie15 = 'media9';
end

% which LaTeX compiler ?
if nargin < 4
    pdforxelatex = 'xelatex';
end

%% Generate Latex file
fig2latex(ax, filename, media9_or_movie15, pdforxelatex);
latex2pdf3d(filename, pdforxelatex)
