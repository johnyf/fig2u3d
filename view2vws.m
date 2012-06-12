function [] = view2vws(ax)
%VIE2VWS    Saves current view in a views file for LaTeX media9 package.
%
% See also FIG2U3D.
%
% File:      view2vws.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10 - 
% Language:  MATLAB R2012a
% Purpose:   export view for LaTeX media9 package
% Copyright: Ioannis Filippidis, 2012-

%% input
if nargin < 1
    ax = gca;
end

filename = 'matlab.vws';
matrix_mode = 0;
viewname = 'MATLABfig';

%% get view
camera_position = get(ax, 'CameraPosition');

center_of_orbit = get(ax, 'CameraTarget'); % 3Dcoo
center_of_orbit_2_camera_vector = camera_position -center_of_orbit; % 3Dc2c
r = norm(center_of_orbit_2_camera_vector);
radius_of_orbit = r; % 3Droo
camera_roll = 0; % 3Droll

% [3x4] homogenous transformation (sub)matrix
curview = view(ax);
T = curview(1:3, :); % reduced, 12-element matrix for Adobe PDF internals
camera_2_world_transformation_matrix = T(:).'; % c2w

camera_aperture_angle = get(ax, 'CameraViewAngle'); % 3Daac (degrees)
%enable_orthographic_view = 1; % 3Dortho

%% export to file
viewname = ['VIEW=', viewname, '\n'];
closing = 'END\n';

if matrix_mode == 1
    c2w = ['   C2W=', num2str(camera_2_world_transformation_matrix), '\n'];
    aac = ['  AAC=', num2str(camera_aperture_angle), '\n'];
    
    str = [viewname, c2w, closing];
else
    coo = ['   COO=', num2str(center_of_orbit), '\n'];
    c2c = ['   C2C=', num2str(center_of_orbit_2_camera_vector), '\n'];
    roo = ['   ROO=', num2str(radius_of_orbit), '\n'];
    
    roll = ['   ROLL=', num2str(camera_roll), '\n'];
    aac = ['  AAC=', num2str(camera_aperture_angle), '\n'];
    
    str = [viewname, coo, c2c, roo, roll, closing];
end

fid = fopen(filename, 'w');
fprintf(fid, str);
fclose(fid);
