function label_add(els)
% D. Hermes & K.J. Miller 240509
% Dept of Neurology and Neurosurgery, University Medical Center Utrecht

msize=40; %marker size

hold on, plot3(els(:,1)*1.01,els(:,2)*1.01,els(:,3)*1.01,'.','MarkerSize',msize,'Color',[.99 .99 .99])
for k=1:length(els(:,1))
    text(els(k,1)*1.01,els(k,2)*1.01,els(k,3)*1.01,num2str(k),'FontSize',8,'HorizontalAlignment','center','VerticalAlignment','middle')
end



