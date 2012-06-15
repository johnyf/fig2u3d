%function [] = test_spiral
%close all

t = linspace(0, 10, 100);

x = [cos(t); sin(t); t];
ax = gca;

plotmd(ax, x, ':')

fig2u3d(ax, 'test')

axis(ax, 'equal')

copyfile('test.u3d', '..\tex\personal\3dheart\img\test.u3d')
copyfile('test.vws', '..\tex\personal\3dheart\img\test.vws')
