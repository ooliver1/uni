%% Task 2 - modified version of “Buffon’s needle” that drops squares
% INPUTS, in order:
% width = the width of the floorboards;
% length = the length of the needles;
% throws = the number of needles thrown.
%
% OUTPUTS, in order:
% p = the estimate of pi,
% crossings = the number of needles that cross a plank;
%
% NOTE: should you need further input or output variables when integrating
% the function to the GUI, you must implement the necessary  checks  using
% nargin and nargout to  ensure  the  function  works  correctly  outside
% the GUI with the input and output combinations specified above.

function [p, crossings, centreX, centreY, angle, crossing_mask] = BuffonSquaresPi(width, length, throws, planks, plank_length)
arguments (Input)
    width (1,1) {mustBePositive}
    length (1,1) {mustBePositive}
    throws (1,1) {mustBePositive}
    planks (1,1) {mustBePositive} = 2
    plank_length (1,1) {mustBePositive} = 10
end
arguments (Output)
    p (1,1) double
    crossings (1,1) uint32
    centreX (1,:) double
    centreY (1,:) double
    angle (1,:) double
    crossing_mask (1,:) logical
end

if nargin < 3
    error('BuffonSquaresPi requires width, length, and throws.');
end

if length * sqrt(2) >= width
    error('BuffonSquaresPi is only valid when length * sqrt(2) < width')
end

total_width = planks * width;
centreX = total_width * rand(throws, 1);
centreY = plank_length * rand(throws, 1);
angle = pi * rand(throws, 1);

crossings = 0;
crossing_mask = false(throws, 1);

halfL = length / 2;

% Model the corners of a square, and use edge vectors to project between corners
corners = halfL * [
    -1, -1;
    1, -1;
    1,  1;
    -1,  1
    ];
edges = [1 2; 2 3; 3 4; 4 1];

% The rotation matrix, as an inline function
R = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

for i = 1:throws
    rotated = (R(angle(i)) * corners')';

    pts = rotated + [centreX(i), centreY(i)];
    % Only x coord is needed for intersecting
    x = pts(:, 1);

    squareCrossed = false;

    for e = 1:size(edges, 1)
        % Find the plank index of both corners
        idx1 = floor(x(edges(e, 1)) / width);
        idx2 = floor(x(edges(e, 2)) / width);
        if idx1 ~= idx2
            crossings = crossings + 1;
            squareCrossed = true;
        end
    end
    crossing_mask(i) = squareCrossed;
end

totalEdges = throws * 4;
if crossings == 0
    p = NaN;
else
    p = (2 * length * totalEdges) / (crossings * width);
end

if nargout < 1
    error('At least one output argument (p) must be requested.');
end
end