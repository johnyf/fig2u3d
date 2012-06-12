function [] = mesh_to_latex(fname,points,faces,face_vertex_data)
%   MESH_TO_LATEX   Provide latex and U3D file for embedding a mesh
%                   into a pdf documment with pdflatex
%       [] = MESH_TO_LATEX(FNAME,POINTS,FACES,FACE_VERTEX_DATA)
% 
%   Created by Alexandre Gramfort on 2009-04-21.
%   Copyright (c)  Alexandre Gramfort. All rights reserved.

% $Id: mesh_to_latex.m 11 2010-01-10 18:28:25Z agramfor $
% $LastChangedBy: agramfor $
% $LastChangedDate: 2010-01-10 19:28:25 +0100 (Dim, 10 jan 2010) $
% $Revision: 11 $

npoints = size(points,1);
nfaces = size(faces,1);

if nargin < 4
    face_vertex_data = [];
end

if ~isempty(face_vertex_data) && size(face_vertex_data,1) ~= npoints && size(face_vertex_data,1) ~= nfaces
    error('Mesh colors should be of size nb points or nb of faces');
end

if size(face_vertex_data,2) == 1
    face_vertex_data = repmat(face_vertex_data,1,3); % RGB colors
end

if size(face_vertex_data,1) == size(points,1)
    normals = mesh_normals(points,faces);
    face_vertex_data = 0.7*face_vertex_data + 0.3*repmat(sum(max(normals*[ones(3,3) , -ones(3,3)],0),2),1,3).*face_vertex_data;
    face_vertex_data(face_vertex_data<0) = 0;
    face_vertex_data(face_vertex_data>1) = 1;
end

% Hack to avoid to have too many colors to store
face_vertex_data = fix(face_vertex_data*10)./10;
% face_vertex_data = fix(face_vertex_data*100)./100;

points = points - repmat(mean(points),npoints,1);

idtffile  = fullfile(cd,[fname,'.idtf']);
% idtffile = tempname;
u3dfile  = fullfile(cd,[fname,'.u3d']);

save_idtf(idtffile,points,faces,face_vertex_data);

mfiledir = fileparts(mfilename('fullpath'));

IDTFcmd = 'IDTFConverter';
if isunix
    if strcmp('MACI',computer) % Intel Mac
        setenv('DYLD_LIBRARY_PATH',[getenv('DYLD_LIBRARY_PATH'),':"',mfiledir,'/bin/maci/"'])
        IDTFcmd = ['"',mfiledir,'/bin/maci/',IDTFcmd,'"'];
    else % Linux
        setenv('LD_LIBRARY_PATH',[getenv('LD_LIBRARY_PATH'),':"',mfiledir,'/bin/glx/"'])
        IDTFcmd = ['"',mfiledir,'/bin/glx/',IDTFcmd,'.sh','"'];
    end
else % windows
    IDTFcmd = [IDTFcmd,'.exe'];
end

current_dir = cd;

try
    if ispc
        cd([mfiledir,'/bin/w32'])
    end
    cmd = sprintf([IDTFcmd,' -input "%s" -output "%s"'],idtffile,u3dfile);
    disp(cmd);
    [status,result] = dos(cmd);
    disp(result);
catch
    rethrow(lasterror)
    cd(current_dir)
end

cd(current_dir)

write_latex(fname);

delete(idtffile);

%% write_latex: Write small latex snippet to embed in you document
function write_latex(fname)

    % Get camera position automatically from matlab
    hf = figure('Visible','off');
    hp = patch('vertices',points,'faces',faces);
    pos = campos;
    up = camup;
    va = camva;
    close(hf);

    ro = norm(pos);

    texfile  = sprintf('./%s.tex',fname);
    disp(['Writing : ',texfile]);
    fid = fopen(texfile,'w');
    [d,fname]=fileparts(fname);
    content = ['\\begin{center}\n\\includemovie[poster,toolbar,label=%s.u3d,text=(%s.u3d),\n3Daac=%d, 3Droll=0, 3Dc2c=%f %f %f, 3Droo=%f, 3Dcoo=0 0 0,3Dlights=CAD,]{\\linewidth}\n{\\linewidth}{%s.u3d}\n\\end{center}\n'];
    % disp(content);
    fprintf(fid,content,fname,fname,ceil(va),up(1),up(2),up(3),ro,fname);
    fclose(fid);

end

end

