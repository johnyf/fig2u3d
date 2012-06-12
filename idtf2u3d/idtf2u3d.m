function [] = idtf2u3d(fin, fout)
%IDTF2U3D   Convert IDTF to U3D file.
%
% usage
%   idtf2u3d(IDTF_filename)
%   idtf2u3d(IDTF_filename, U3D_filename)
%
% See also FIG2U3D.
%
% File:      idtf2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2011.02.17 - 2012.06.09
% Language:  MATLAB R2012a
% Purpose:   convert IDTF file to U3D file format
% Copyright: Ioannis Filippidis, 2011-

% depends
%   IDTFConverter.exe in system path

%% input
if nargin < 1
    fin = 'surface.idtf';
    fout = 'surface.u3d';
end

if nargin < 2
    fout = strrep(fin, '.idtf', '');
    fout = [fout, '.u3d'];
end

% fname extensions ok ?
if isempty(strfind(fin, '.idtf') )
    fin = [fin, '.idtf'];
end

if isempty(strfind(fout, '.u3d') )
    fout = [fout, '.u3d'];
end

%% convert
idtf2u3dcmd = ['!IDTFConverter.exe -input ', fin, ' -output ', fout];
eval(idtf2u3dcmd)
