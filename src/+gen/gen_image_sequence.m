function [params] = gen_image_sequence(cal, params)

import convert.CIE_from_Angle

k = 1;
color_sequence = zeros(params.ntrials, 4);
for i=1:params.ncolors
    if strcmp(params.uniqueHue, 'yellow') || ...
            strcmp(params.uniqueHue, 'blue')
        % iterate through each color in chromaticities above
        [x, y] = CIE_from_Angle(params.angles(i), params.RHO);
        xyY = [x y params.LUM]';
    else
        xyY = [params.x(i) params.y(i) params.LUM]';
    end
    
    % Convert to RGB:
    XYZ = xyYToXYZ(xyY);
    [RGB, outOfRangePixels] = SensorToSettings(cal, XYZ);
    
    % Check for out-of-range non-displayable color values:
    if any(outOfRangePixels)
        fprintf('WARNING: Out of range RGB values!\n');
        fprintf('pix = %f\n', outOfRangePixels);
        fprintf('rgb = %f\n', RGB);
    end

    for j=1:params.nrepeats
        color_sequence(k, 1:3) = RGB * 255;
        color_sequence(k, 4) = params.angles(i);
        k = k + 1;
    end
    
end
% randomize the sequence
p = randperm(params.ntrials); % 1:ntrials
color_sequence = color_sequence(p, :);
params.color_sequence = color_sequence;
end