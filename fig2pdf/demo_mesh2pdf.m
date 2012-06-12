%% Mesh to pdf demo script
% Generates a Latex file that can be used to generate a pdf embedded with a 3D mesh
%
% $Id: demo_mesh2pdf.m 3 2009-09-19 12:25:30Z agramfor $

%% Load sample data
load demo_data/data_mesh2pdf.mat

%% Set the output Latex filename
filename = 'tex/mesh';

%% Generate Latex file
mesh_to_latex(filename,points,faces,face_vertex_data);

%% Use pdflatex to generate the pdf
pdflatex_cmp = ['C:/Program Files/MiKTeX 2.8/miktex/bin/pdflatex.exe'];

if isunix
    pdflatex_cmp = 'pdflatex';
else
    addpath(['C:/Program Files/MiKTeX 2.8/miktex/bin/']);
    pdflatex_cmp = 'pdflatex.exe';
end

cd tex
dos([pdflatex_cmp,' -interaction=nonstopmode demo_mesh2pdf.tex']);
dos([pdflatex_cmp,' -interaction=nonstopmode demo_mesh2pdf.tex']); % re-run (required by movie15 package)
dos([pdflatex_cmp,' -interaction=nonstopmode demo_mesh2pdf.tex']); % re-run (required by movie15 package)
cd ../
