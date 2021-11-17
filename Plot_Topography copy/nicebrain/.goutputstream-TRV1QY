function [elecMatrix] = sortelec()
% this function works on the active MATLAB figure

hold on;
h = datacursormode; 
done = 0;
elecNum = 0;
disp('Click on the first electrode and hit enter');
disp('Enter = label electrode');
disp('0 = remove last electrode');
disp('1 = stop labeling');
% probably going to change this so 0 means stop and any other number means
% remove that electrode from matrix

    while ~done

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

        elseif userResponse == 0 && elecNum ~= 0 % remove last electrode

            delete(t(elecNum)); % remove from figure
            elecNum = elecNum - 1;
            elecMatrix = elecMatrix(1:elecNum, :); % remove from matrix


        elseif userResponse == 1 % stop labeling

            datacursormode off;
            done = 1;

        end   

    end

end
