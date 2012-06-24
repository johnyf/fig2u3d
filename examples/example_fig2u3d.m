function [] = example_fig2u3d
% File:      example_fig2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10
% Language:  MATLAB R2012a
% Purpose:   examples for using fig2u3d
% Copyright: Ioannis Filippidis, 2012-

ax1 = gca;

peaks_facecolors(ax1)
%peaks_sphere(ax1)
%mixed_scene(ax1)

copyfile('peaks.u3d', '..\tex\personal\3dheart\img\peaks.u3d')
copyfile('peaks.vws', '..\tex\personal\3dheart\img\peaks.vws')

function [] = peaks_facecolors(ax)
[x, y, z] = peaks;
[n, m] = size(x);
c = 10 *rand(n-1, m-1);

surf(ax, x, y, z +5, z +5)

hold(ax, 'on')
surf(ax, x, y, z, c)

[x, y, z] = sphere;
[n, m] = size(x);
c = 10 *rand(n-1, m-1);
surf(ax, x, y, z, c)

fig2u3d(ax, 'peaks')

function [] = peaks_sphere(ax)
axes(ax)
peaks
hold(ax, 'on')
sphere
freezeColors
plot_torus(ax, zeros(3, 1)+10, 1, 2, eye(3) )

fig2u3d(ax, 'peaks')

function [] = mixed_scene(ax)
%% init
hold(ax, 'on')

%% surf
sphere(20)

%% line
t = linspace(0, 10, 100);
x = [cos(t); sin(t); t];
plotmd(ax, x, 'b-*')
plotmd(ax, x+1, 'ro') % 2nd line

%% quiver3
n = 8;
x = 10 *rand(3, n);
v = rand(3, n);
quivermd(ax, x, v, 'g')

%% view
axis(ax, 'equal')
axis(ax, 'tight')
view(ax, 3)

%fig2u3d(ax, 'mixed_scene')
