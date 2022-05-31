function genFixCross(fix_x, fix_y)

    % Get image data
    image = imread('graybackground.png');
    coords = size(image);

    % Set fixation cross location data
    x_pos1 = (0.25*coords(2))+fix_x;
    y_pos1 = (0.5*coords(1))-fix_y;
    x_pos2 = (0.75*coords(2))+fix_x;
    y_pos2 = y_pos1;

    % % Make the figure
    figure
    %iptsetpref('ImshowBorder','tight');

    imshow(image);
    truesize(gcf,[coords(1)*(63/75) coords(2)*(63/75)]) %64/75
     hold on
     plot(x_pos1,y_pos1,'bx', 'MarkerSize', 12, 'LineWidth', 2)
     hold on
     plot(x_pos2,y_pos2,'bx', 'MarkerSize', 12, 'LineWidth', 2)
    %saveas(gcf, 'graybackground.png')
    saveas(gcf, 'graybackgroundcross.png')

end