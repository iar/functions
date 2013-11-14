function figSave(figurePath, figureName, hash)
%% FIGSAVE save the current figure as a PDF and PNG with figureName appended by hash
%
%	Written by: Michael Hutchins

	name = sprintf('%s%s_%s.pdf',figurePath, figureName, hash);
	%print(gcf,name,'-dpdf','-painters');
	
	name = sprintf('%s%s_%s.png',figurePath, figureName, hash);
	saveas(gcf,name);

end
