function [elecMatrix,elecInfo] = sortelec()
% this function works on the active MATLAB figure

hold on;
h = datacursormode; 
done = 0;
elecNum = 0;
elecInfo=[];
disp('Click on the first electrode and hit enter');
disp('Enter = label electrode');
disp('0 = remove last electrode');
disp('1 = stop labeling');
disp('Please select 4 electordes per pin');
% probably going to change this so 0 means stop and any other number means
% remove that electrode from matrix

    while ~done
   if mod(elecNum,4)==0 
            pinnum=input('Type in a pin name:','s');
            if isempty(pinnum)
                disp('All electrodes selected?? Then Press 1 to finish! ');
            end
                
    end
    m = sprintf('Select electrode %d', elecNum + 1);
    disp(m);
    userResponse = input('');

        if isempty(userResponse) % if enter was pressed before any typing

            cursor = getCursorInfo(h); % store cursor location

            elecNum = elecNum + 1;
            
            % write label on figure and store handle in t
            t(elecNum)=text(cursor.Position(1), cursor.Position(2), cursor.Position(3),... % position
                num2str(elecNum),... % number
                'FontSize', 15,...
                'Color', 'red',...
                'BackgroundColor', [.7 .9 .7],...
                'HorizontalAlignment', 'center',...
                'VerticalAlignment', 'middle',...
                'FontWeight', 'bold'); %#ok<*SAGROW> removes warning for t

            elecMatrix(elecNum, 1) = cursor.Position(1);
            elecMatrix(elecNum, 2) = cursor.Position(2);
            elecMatrix(elecNum, 3) = cursor.Position(3);
            elecInfo.loc{elecNum}=elecMatrix(elecNum,:);
            elecInfo.name{elecNum}=pinnum;
            
        elseif userResponse == 0 && elecNum ~= 0 % remove last electrode

            delete(t(elecNum)); % remove from figure
            elecNum = elecNum - 1;
            elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix
            pinnum=elecInfo.name{elecNum};
            
        elseif userResponse == 1 % stop labeling

            datacursormode off;
            saveas(gcf,'Electrodes\ElectrodesMarker','fig');
            done = 1;

        end   

    end

end
