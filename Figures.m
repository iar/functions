function Figures(fig,Font)
%Figures sets the fontsize of the given or current figure to Fontsize 14
%   Colorbar handles must be passed manually
%
%   Written By:  Michael Hutchins

switch nargin
    case 0
        fig=gca;
        Font=14;
    case 1
        Font=14;
end

% Figures.m alters figures for a consistent look
set(fig,'FontSize',Font);
h_xlabel = get(fig,'XLabel');
set(h_xlabel,'FontSize',Font); 
h_ylabel = get(fig,'YLabel');
set(h_ylabel,'FontSize',Font); 
h_title = get(fig,'Title');
set(h_title,'FontSize',Font);


clear Font h_xlabel h_ylabel h_title