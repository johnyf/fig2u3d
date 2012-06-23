function [] = u3d_in_latex(fname, media9_or_movie15)
%U3D_IN_LATEX   LaTeX code which includes a U3D file.
%
% usage
%   U3D_IN_LATEX(fname, media9_or_movie15)
%
% input
%   fname = LaTeX file name (a '_small.tex' will be appended)
%   media9_or_movie15 = LaTeX package to use for including the 3D file
%
% output
%   Saves a LaTeX file including the U3D file
%
% File:      u3d_in_latex.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.06.21
% Language:  MATLAB R2012a
% Purpose:   produce LaTeX code including a U3D file
%
% acknowledgment
%   Based on write_latex by Alexandre Gramfort.
%   This can be found on the MATLAb Central File Exchange:
%       http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object
%   and is covered by the BSD License.

fname = clear_file_extension(fname, '.tex');
texfile = [fname, '_small.tex'];
disp(['Writing: ', texfile] );

%[~, u3dfname] = fileparts(fname);
if strcmp(media9_or_movie15, 'media9')
    content = latex_include_using_media9;
else
    content = latex_include_using_movie15;
end

fid = fopen(texfile, 'w');
    fprintf(fid, content, fname, fname, fname);
fclose(fid);

%fprintf(fid, content, fname, fname, ceil(va),...
%        up(1), up(2), up(3), ro, fname);

function [str] = latex_include_using_media9
% VWS file name (w/o extension) = string,
% 2D substitute image file name (w/o extension) = string,
% U3D file name (w/o extension) = string
str = verbatim;
%{
%%\\begin{center}
    \\includemedia[%%
    width=\\linewidth,%%
    height=\\linewidth,%%
    activate=pagevisible,%%
    deactivate=pageinvisible,%%
    3Dviews=%s.vws,%%
    3Dtoolbar]{%%
        \\includegraphics[width=\\linewidth]{%s.png}%%
    }{%s.u3d}%%
%%\\end{center}
%}

function [str] = latex_include_using_movie15
% u3dfile = string,
% u3dfile = string,
% 3Daac = float,
% 3Dc2c = float, float, float,
% 3Droo = float
str = verbatim;
%{
\\begin{center}
    \\includemovie[%%
    poster,%%
    toolbar,%%
    label=%s.u3d,%%
    text=(%s.u3d),%%
    3Daac=%d,%%
    3Droll=0,%%
    3Dc2c=%f %f %f,%%
    3Droo=%f,%%
    3Dcoo=0 0 0,%%
    3Dlights=CAD]{\\linewidth}{\\linewidth}%%
    {%s.u3d}
\\end{center}
%}
