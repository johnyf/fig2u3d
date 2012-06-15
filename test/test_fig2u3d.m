%function [] = test_fig2u3d
%% init
clf
ax = gca;
hold(ax, 'on')

%% surf
sphere(20)

%% line
%
t = linspace(0, 10, 100);
x = [cos(t); sin(t); t];
plotmd(ax, x)

plotmd(ax, x+1)
%
%% quiver3
%
n = 8;
x = 10 *rand(3, n);
v = rand(3, n);
quivermd(ax, x, v)
%
%% view
axis(ax, 'equal')
axis(ax, 'tight')
view(ax, 3)

fig2u3d(gca, 'test');

copyfile('test.u3d', '..\tex\personal\3dheart\img\test.u3d')
copyfile('test.vws', '..\tex\personal\3dheart\img\test.vws')
