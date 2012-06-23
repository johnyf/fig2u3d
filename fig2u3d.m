function [] = fig2u3d(ax, fname, imgtype, addaxes, varargin)
%FIG2U3D   Convert figure to U3D file.
%   FIG2U3D saves the current axes as a U3D file for inclusion as an
%   interactive 3-dimensional figure within a PDF. Either LaTeX or Adobe
%   Acrobat can be used to embed the U3D file in the PDF.
%
%   A VWS file is also created, which contains the current camera view of
%   the axes saved. This file can be used to set the figure's default view
%   in the PDF to be the same with the open figure window in MATLAB.
%
%   The media9 LaTeX package can import U3D files with their associated VWS
%   files in a PDF document. It can be found here:
%       http://www.ctan.org/tex-archive/macros/latex/contrib/media9
%
%   For PDF readers which do not render 3D figures, it is possible to
%   include an alternative 2D image as a substitute to the 3D object.
%   For conveniency, the script saves a 2D image together with U3D file.
%   File type and other options for exporting this 2D image can be
%   specified as additional arguments.
%
%   Either export_fig (if available) or the standard print function are
%   used for 2D export. Arguments defining 2D export options need conform
%   to the export function used.
%
% usage
%   FIG2U3D
%   FIG2U3D(ax, fname, imgtype, addaxes, varargin)
%
% optional input
%   ax = axes object handle to export (default = gca)
%   fname = file name string, e.g. 'myfigure' (default = 'surface')
%           Note: Filename extensions are appended automatically.
%   imgtype = save axes also as an image, to be used as a substitute in
%             PDF readers which cannot render the interactive 3D figure.
%           = 'filetype' | 'none'
%             where:
%                   filetype = any file format supported by the export_fig
%                              or print function (whichever is used)
%                   'none' = in this case a 2D image is not saved
%   addaxes = show axes in u3d file (default = 0)
%           = 0 | 1 (do not show/ show, respectively)
%             (depending on which one is available and used).
%   varargin = additional options for exporting 2D image using either print
%              or export_fig. These must conform to the inputs accepted by
%              the export function used.
%
% output
%   This M-function does not return any data.
%   It saves a U3D file containing the axes object with handle ax.
%
% examples
%   peaks
%   FIG2U3D(gca, 'peaks', 0, 1, '-dpdf') % if using print
%   FIG2U3D(gca, 'peaks', 0, 1, 1, '-dpng', '-r300') % if using print
%
%   FIG2U3D(gca, 'peaks', 0, 1, 1, '-pdf') % if using export_fig
%   FIG2U3D(gca, 'peaks', 0, 1, 1, '-png') % if using export_fig
%   
% optional dependency
%   export_fig, for saving an accompanying 2D image to substitute the 3D
%   inetractive figure in PDF readers which do not render it.
%   This can be downloaded from the MATLAB Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/23629
%   Otherwise, the print function is used for the 2D image.
%
% reference
%   IDTF (Intermediate Data Text File) Format Description, Version 100,
%   Intel Corporation, 2005, available at:
%       http://u3d.svn.sourceforge.net/viewvc/u3d/releases/Gold12Update/Docs/IntermediateFormat/IDTF%20Format%20Description.pdf
%
% See also EXAMPLE_FIG2U3D, FIG2PDF3D, FIG2IDTF, IDTF2U3D, VIEW2VWS, PRINT,
%          EXPORT_FIG.
%
% File:      fig2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 2012.06.15
% Language:  MATLAB R2012a
% Purpose:   convert figure to U3D file format (lines, surfaces, points)
% Copyright: Ioannis Filippidis, 2012-

% depends
%   u3d_pre_surface, u3d_pre_line, u3d_pre_quivergroup, u3d_pre_contourgroup
%   fig2idtf, idtf2u3d, view2vws
%   axes_extremal_xyz, takehold, restorehold, quivermd, check_file_extension

% optional depends
%   export_fig

%% input
if nargin < 1
    ax = gca;
else
    % not a handle ?
    if ~ishandle(ax)
        warning('fig2u3d:handle',...
                'AX argument is not a handle. Exporting current axes.')
        ax = gca;
    end
    
    % not axes handle ?
    handle_type = get(ax, 'Type');
    if strcmp(handle_type, 'figure')
        warning('fig2u3d:handle',...
               ['AX argument is a figure handle.',...
                'Exporting the first axes child of this figure.'] )
        ax = get(ax, 'Children');
    end
end

% no axes object ?
if isempty(ax)
    warning('fig2u3d:emptyaxes',...
            'AX axes handle is empty. Noting to export.')
    return
end

% filename provided ?
if nargin < 2
    fname = 'surface';
end

% save image substitute ?
saveimg = 1;
if nargin < 3
    imgtype = '-png';
elseif strcmp(imgtype, 'none') || isempty(imgtype)
    saveimg = 0;
end

% show axes ?
if nargin < 4
    addaxes = 0;
end

plot_axes(ax, addaxes)
delete_idtf = 1; % delete intermediate IDTF file

%% convert graphics objects to meshes, line_sets and point_sets
[surf_vertices, faces, facevertexcdata, surf_renderers] = u3d_pre_surface(ax);
[line_vertices, line_edges, line_colors,...
 line_points, line_point_colors] = u3d_pre_line(ax);
[quiver_vertices, quiver_edges, quiver_colors] = u3d_pre_quivergroup(ax);
[contour_vertices, contour_edges, contour_colors] = u3d_pre_contourgroup(ax);

%% group meshes, line_sets and point_sets
% aggregate meshes
mesh_vertices = surf_vertices;
mesh_faces = faces;
mesh_colors = facevertexcdata;

% aggregate lines
line_vertices = [line_vertices, quiver_vertices, contour_vertices];
line_edges = [line_edges, quiver_edges, contour_edges];
line_colors = [line_colors, quiver_colors, contour_colors];

% aggregate pointsets
pointset_points = line_points;
pointset_colors = line_point_colors;

%% export
fig2idtf(fname,...
          mesh_vertices, mesh_faces, mesh_colors,...
          line_vertices, line_edges, line_colors,...
          pointset_points, pointset_colors)

idtf2u3d(fname)
rm_idtf(fname, delete_idtf)

part_renderers = surf_renderers;
view2vws(ax, fname, part_renderers)

save_png_substitute(ax, fname, saveimg, imgtype, varargin{:} )

function rm_idtf(fname, yesno)
if yesno == 0
    return
end

% fname extensions ok ?
fname = check_file_extension(fname, '.idtf');
fname  = fullfile(cd, fname);

system(['rm ', fname] )

function plot_axes(ax, addaxes)
if addaxes == 0
    return
end

[xyz_minmax, dim] = axes_extremal_xyz(ax);
xyz_minmax = 1.3 *xyz_minmax;

x0 = [0, 0, 0].';
vx = [xyz_minmax(2), 0, 0].';
vy = [0, xyz_minmax(4), 0].';

if dim == 3
    vz = [0, 0, xyz_minmax(6) ].';
end

held = takehold(ax);
    quivermd(ax, x0, vx, 'k')
    quivermd(ax, x0, vy, 'k')
    quivermd(ax, x0, vz, 'k')
restorehold(ax, held)

function [] = save_png_substitute(ax, fname, saveimg, imgtype, varargin)
% save image substitute ?
if saveimg == 0
    return
end

% export_fig available ?
fighandle = get(ax, 'Parent');
if exist('export_fig', 'file') == 2
    col = get(fighandle, 'Color'); % get color
    
    % set white background for png ?
    if strcmp(imgtype, '-png')
        set(fighandle, 'Color', 'w')
    end
    
    export_fig(ax, imgtype, varargin{:}, fname)
    
    set(fighandle, 'Color', col) % restore color
else
    print(fighandle, imgtype, varargin{:}, fname)
end
