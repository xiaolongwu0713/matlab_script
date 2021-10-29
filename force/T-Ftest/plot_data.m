for i=1:110
    plot(data_after_local(:,i)');
        saveas(gcf,['./','Data_',num2str(i),'.jpg']);
end