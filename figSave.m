function figSave(figurePath, figureName, hash)
%% FIGSAVE save the current figure as a PDF and PNG with figureName appended by hash
%
%	Written by: Michael Hutchins

	try
		name = sprintf('%s%s_%s.pdf',figurePath, figureName, hash);
		print(gcf,name,'-dpdf','-painters');
	catch
		name = sprintf('%s%s_%s.eps',figurePath, figureName, hash);
		print(gcf,name,'-depsc','-painters');		
	end
	set(gcf,'InvertHardCopy','off')
	name = sprintf('%s%s_%s.png',figurePath, figureName, hash);
	saveas(gcf,name);
	set(gcf,'InvertHardCopy','on')

end
