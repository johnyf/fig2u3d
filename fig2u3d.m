function [] = fig2u3d(ax, fname, addaxes, delete_idtf)
%SURF2U3D   Convert plotted surface to U3D file.
%
% usage
%   FIG2U3D
%   FIG2U3D(ax, fname, addaxes, delete_idtf)
%
% optional input
%   ax = axes object handle to export (default = gca)
%   fname = file name string, e.g. 'myfigure' (default = 'surface')
%           Note: The file extension '.idtf' is appended if omitted
%   addaxes = show axes in u3d file (default = 0 (do not show) )
%           = 0 | 1 (do not show/ show, respectively)
%   delete_idtf = remove or not idtf file used intermediately
%               = 0 | 1 (keep /delete, respectively)
%
% output
%   This M-function does not return any data.
%   It saves a U3D file containing the axes object with handle ax.
%
% See also FIG2IDTF, IDTF2U3D, VIEW2VWS,
%          TEST_SPIRAL, TEST_FIG2U3D.
%
% File:      fig2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 2012.06.15
% Language:  MATLAB R2012a
% Purpose:   convert figure to U3D file format (lines, surfaces, points)
% Copyright: Ioannis Filippidis, 2012-

% depends
%   u3d_pre_surface, u3d_pre_line, u3d_pre_quivergroup,
%   fig2idtf, idtf2u3d, view2vws
%   axes_extremal_xyz, takehold, restorehold, quivermd

%% input
if nargin < 1
    ax = gca;
else
    if ~ishandle(ax)
        ax = gca;
    end
end

% filename provided ?
if nargin < 2
    fname = 'surface.idtf';
end

% fname extension ok ?
if isempty(strfind(fname, '.idtf') )
    fname = [fname, '.idtf'];
end

% show axes ?
if nargin < 3
    addaxes = 0;
end

% delete intermediate file by default
if nargin < 4
    delete_idtf = 1;
end

plot_axes(addaxes)

%% convert graphics objects to meshes, line_sets and point_sets
[surf_vertices, faces, facevertexcdata, surf_renderers] = u3d_pre_surface(ax);
[line_vertices, line_edges, line_colors,...
 line_points, line_point_colors] = u3d_pre_line(ax);
[quiver_vertices, quiver_edges, quiver_colors] = u3d_pre_quivergroup(ax);

%% group meshes, line_sets and point_sets
% aggregate meshes
mesh_vertices = surf_vertices;
mesh_faces = faces;
mesh_colors = facevertexcdata;

% aggregate lines
line_vertices = [line_vertices, quiver_vertices];
line_edges = [line_edges, quiver_edges];
line_colors = [line_colors, quiver_colors];

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

vwsfname = strrep(fname, '.idtf', '.vws');
part_renderers = surf_renderers;
view2vws(ax, vwsfname, part_renderers)

function rm_idtf(fname, yesno)
if yesno == 0
    return
end

% fname extensions ok ?
if isempty(strfind(fname, '.idtf') )
    fname = [fname, '.idtf'];
end

system(['rm ', fname] )

function plot_axes(addaxes)
if addaxes == 0
    return
end

held = takehold(ax);

x0 = [0, 0, 0].';

vx = [1, 0, 0].';
quivermd(ax, x0, vx)

vy = [0, 1, 0].';
quivermd(ax, x0, vy)

[~, dim] = axes_extremal_xyz(ax);
if dim == 3
    vz = [0, 0, 1].';
    quivermd(ax, x0, vz)
end

restorehold(ax, held)
