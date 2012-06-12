%function [] = test_fig2u3d
%% init
clf
ax = gca;
hold(ax, 'on')

%% surf
sphere(3)

%% line
t = linspace(0, 10, 10);
x = [cos(t); sin(t); t];
plotmd(ax, x)

%% quiver3
%{
n = 10;
x = 10 *rand(3, n);
v = rand(3, n);
quivermd(ax, x, v)
%}
%% view
axis(ax, 'equal')
axis(ax, 'tight')


fig2u3d(gca, 'test');

!cp test.u3d ..\tex\personal\3dheart\img\test.u3d
!cp matlab.vws ..\tex\personal\3dheart\img\matlab.vws
