function prepareFigure4Save(resize, path2save, saveString, nameString)
set(gca,'FontSize',8);
set(gcf, 'Color', 'w');
if resize
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 8 6]);
else
    set(gcf, 'Units', 'Centimeters', 'Position', [0 0 15 9]);
end
pos = get(gca, 'Position');
set(gca, 'Position', pos + [0.1, 0.1, -0.1, -0.1]);
export_fig(strcat(path2save,saveString,nameString,'.pdf'));
end