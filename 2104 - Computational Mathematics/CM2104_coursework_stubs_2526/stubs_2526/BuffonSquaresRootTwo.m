%% Task 3 - modified version of "Buffon s needle" that drops squares to estimate sqrt(2)
% INPUTS, in order:
% width = the width of the floorboards;
% length = the length of the needles;
% throws = the number of needles thrown.
%
% OUTPUTS, in order:
% r = the estimate of sqrt(2),
% crossings = the number of needles that cross a plank;
%
% NOTE: should you need further input or output variables when integrating
% the function to the GUI, you must implement the necessary  checks  using
% nargin and nargout to  ensure  the  function  works  correctly  outside
% the GUI with the input and output combinations specified above.

function [r, crossings, centreX, centreY, angle, crossing_mask] = BuffonSquaresRootTwo(width, length, throws, planks, plank_length)
arguments
    width (1,1) {mustBePositive}
    length (1,1) {mustBePositive}
    throws (1,1) {mustBePositive}
    planks (1,1) {mustBePositive} = 2
    plank_length (1,1) {mustBePositive} = 10
end
arguments (Output)
    r (1,1) double
    crossings (1,1) uint32
    centreX (1,:) double
    centreY (1,:) double
    angle (1,:) double
    crossing_mask (1,:) logical
end

if nargin < 3
    error('BuffonSquaresRootTwo requires width, length, and throws.');
end

single_crossings = 0;
consecutive_crossings = 0;
crossing_mask = false(throws, 1);
halfL = length/2;

corners = halfL * [
    -1, -1;
    1, -1;
    1,  1;
    -1,  1
    ];

% used to project between vertices for crossings
edges = [1 2; 2 3; 3 4; 4 1];

total_width = planks * width;
centreX = total_width * rand(throws, 1);
centreY = plank_length * rand(throws, 1);
angle = pi * rand(throws, 1);

% the rotation matrix, as an inline function
R = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

for i = 1:throws
    rotated = (R(angle(i)) * corners')';
    pts = rotated + [centreX(i), centreY(i)];
    x = pts(:,1);

    intersections = ( floor(x(edges(:,1))/width) ~= floor(x(edges(:,2))/width) );

    if any(intersections)
        % event A: any edge crosses a line
        single_crossings = single_crossings + 1;
        crossing_mask(i) = true;

        % event B: same line index for two consecutive edges
        for e = 1:4
            e2 = mod(e,4) + 1;
            if intersections(e) && intersections(e2)
                consecutive_crossings = consecutive_crossings + 1;
                break
            end
        end
    end
end

if single_crossings == 0
    r = NaN;
else
    r = 2 - (consecutive_crossings) / (single_crossings);
end
crossings = consecutive_crossings;

if nargout < 1
    error('At least one output argument (r) must be requested.');
end
end