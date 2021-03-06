function [params] = hue_specific_params(uniqueHue, params)
    import white.*
    
if strcmp(uniqueHue, 'yellow') 
    params.uniqueHue = 'yellow';
    angle_1 = params.angle_bounds.y1; 
    angle_2 = params.angle_bounds.y2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.invert = 0;
    params.left = 'too green';
    params.right = 'too red';
    
elseif strcmp(uniqueHue, 'blue')
    params.uniqueHue = 'blue';
    angle_1 = params.angle_bounds.b1; 
    angle_2 = params.angle_bounds.b2;
    params.angles = linspace(angle_1, angle_2, params.ncolors);
    params.invert = 0;
    params.left = 'too purple';
    params.right = 'too green';
    
elseif strcmp(uniqueHue, 'white')
    params.uniqueHue = 'white';
    
    blue_abc = params.blue_abc;
    yellow_abc = params.yellow_abc;

    params.ncolors = 15; % override default setting to ensure good sampling
    if strcmp(params.color_space, 'xyY')
        x_lim = yellow_abc(1); % no need to go any yellower.
        y_lim = interp1([blue_abc(1) yellow_abc(1)], ...
            [blue_abc(2) yellow_abc(2)], x_lim, 'linear');
    else
        x_lim = yellow_abc(1); % no need to go any yellower.
        y_lim = interp1([blue_abc(1) yellow_abc(1)], ...
            [blue_abc(2) yellow_abc(2)], x_lim, 'linear');
    end
    
    params.x = linspace(blue_abc(1), x_lim, params.ncolors);
    params.y = linspace(blue_abc(2), y_lim, params.ncolors);

    params.invert = 1;
    params.unique_dist = comp.distance_between_points(blue_abc(1:2), ...
        yellow_abc(1:2));
    
    params.angles = zeros(params.ncolors, 1);

    for i=1:length(params.angles)
        params.angles(i) = comp.distance_between_points(blue_abc(1:2), ...
            [params.x(i) params.y(i)]') / params.unique_dist;
    end
    params.left = 'too blue';
    params.right = 'too yellow';
end
params.ntrials = params.ncolors * params.nrepeats;
end