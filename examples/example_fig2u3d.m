function [] = example_fig2u3d
% File:      example_fig2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.10
% Language:  MATLAB R2012a
% Purpose:   examples for using fig2u3d
% Copyright: Ioannis Filippidis, 2012-

ax1 = newax;

mixed_scene(ax1)

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
