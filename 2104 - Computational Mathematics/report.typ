#show heading.where(level: 1): set text(20pt)
#show heading.where(level: 2): set text(16pt)
#show heading.where(level: 3): set text(14pt)
#show heading.where(level: 4): set text(12pt)
#set text(10pt)
#page[
  #set align(center)
  Oliver Wilkes

  C24057633
  === CM2104 - Computational Mathematics
  = Buffon's Needle Simulation
]

// You must supply a report on your submission which provides a short written description (1–2
// pages of text; plus diagrams, screenshots etc.) conveying all the appropriate information to
// demonstrate its operation and explaining your extension of the basic algorithm. Include your
// student number in the report.

== Original Algorithm

Buffon's Needle is an experiment to estimate a rational number. The experiment consists of dropping a needle onto a floor with equally spaced parallel lines, and the probability of the needle crossing a line can be used to estimate the value of $pi$ with the formula $p = (2L) / (pi d)$ where $L <= d$.

=== Implementation

My implementation involved using MATLAB to simulate dropping the needle multiple times and counting how many cross a line. The formula I used was derived from the above, where $p = "crossings"/"throws"$ and therefore $pi = (2L dot "throws") / ("crossings"dot d)$.

The first part of the code initialises the random needle locations and angles, and calculates the projection of half the needle length along the horizontal axis.
```matlab
total_width = planks * width;
centreX = total_width * rand(throws, 1);
centreY = plank_length * rand(throws, 1);
angle = pi * rand(throws, 1);
proj = (length/2) .* sin(angle);
```
This projection is then used to determine if the centre of the needle, plus or minus the projection, crosses a line.
```matlab
% Find the closest crack, to the left or right
offset = mod(centreX, width);
dist_to_boundary = min(offset, width - offset);

% Crossings_mask is used again in display for different colours
crossing_mask = proj >= dist_to_boundary;
crossings = sum(crossing_mask);
```
Finally, the value of $pi$ is estimated using the number of crossings and total throws.
```matlab
p = (2 * length * throws) / (crossings * width);
```

== Extending With Squares

The next task was to extend the algorithm to drop squares instead of needles. The first step was to model squares as 4 independent edge needles, and check their crossings individually. This would still produce an estimate of $pi$, except would be displayed as squares.

This requires using a for loop for simplicity, as checking each individual needle would be more complex with vectorised operations.

=== Implementation

I use the following code to define the corners of the square, then a matrix of edges connecting them, for finding crossings.

```matlab
corners = halfL * [
    -1, -1;
    1, -1;
    1,  1;
    -1,  1
    ];
edges = [1 2; 2 3; 3 4; 4 1];
```

I use the rotation matrix to rotate the square by the random angle generated for each throw. Each edge is checked individually, but also a mask is kept to see if anywhere in the square crossed, which is used to display the squares in different colours.

```matlab
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
```

Finally, the value of $pi$ is estimated again, using the total number of edges (4 per square), and total edge crossings.
```matlab
totalEdges = throws * 4;
p = (2 * length * totalEdges) / (crossings * width);
```

== Estimating Other Rational Numbers

In addition to estimating $pi$, the algorithm can be adapted to estimate other rational numbers by changing the shape being dropped and the formula used. This is listed in the paper "Statistical estimation of some irrational numbers using an extension of Buffon's needle experiment" #link(<ref1>)[[1]].

The general formula for estimating a number based on the probability of crossing is given as:

$P(B|A) = P(B)/P(A) = 2 - D/L = 2[1-cos(pi/n)] equiv p_n$

where $p_4 = 2 - sqrt(2)$

This can be simplified to $sqrt(2) approx 2 - P(B)/P(A)$ where $P(A)$ is the amount of squares that cross a line, and $P(B)$ is the amount of squares where consecutive/adjacent edges cross a line.

=== Implementation

This follows off the previous square implementation, with an additional check for adjacent edges crossing.

This is done by first checking if any edge crosses a line, and if so, incrementing the count for event A. Then, a second loop checks each edge and the next edge (wrapping around) to see if both cross a line, and if so increments the count for event B.

```matlab
intersections = ( floor(x(edges(:,1))/width) ~= floor(x(edges(:,2))/width) );

if any(intersections)
    % event A (N_c): any edge crosses a line
    single_crossings = single_crossings + 1;
    crossing_mask(i) = true;

    % event B (N_cc): same line index for two consecutive edges
    for e = 1:4
        e2 = mod(e,4) + 1;
        if intersections(e) && intersections(e2)
            consecutive_crossings = consecutive_crossings + 1;
            break
        end
    end
end
```

Finally, the value of $sqrt(2)$ is estimated using the counts of events A and B.
```matlab
r = 2 - (consecutive_crossings / single_crossings);
```

== Displaying Results

Another task is to display the results of the simulation graphically, showiung the needles/squares, the lines, the estimated value of $pi$ or $sqrt(2)$, and colouring intersecting shapes differently.

Drawing the lines is simple, by using a vector range and plotting vertical lines at each position.
```matlab
lines = 0:width:width*planks;
xline(ax, lines);
```
Using the exported vectors `centreX`, `centreY`, and `angle`, the needle endpoints can be calculated using trigonometry.
```matlab
halfL = length / 2;

dx = halfL * sin(angle);
dy = halfL * cos(angle);

x1 = centreX + dx;
y1 = centreY + dy;
x2 = centreX - dx;
y2 = centreY - dy;
```

Then, these needles are drawn separately by using these plots, and using `crossing_mask` exported earlier to colour them differently.

```matlab
for i = 1:throws
    colour = app.NeedleColourPicker.Value;
    if crossing_mask(i)
        colour = app.IntersectingNeedleColourPicker.Value;
    end
    app.NeedleLines(i) = plot(ax, [x1(i), x2(i)], [y1(i), y2(i)], 'Color', colour, 'HitTest', 'off', 'LineWidth', 1);
end
```

This logic is similar for drawing squares, by calculating the rotated corners and plotting them with different colours based on `crossing_mask`.

```matlab
corners = halfL * [
    -1, -1;
     1, -1;
     1,  1;
    -1,  1
];

% The rotation matrix, as an inline function
R = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

for i = 1:throws
    % Compute square's individual edges again
    pts = (R(angle(i)) * corners')' + [centreX(i), centreY(i)];
    x = pts(:,1); y = pts(:,2);

    xplot = [x; x(1)];
    yplot = [y; y(1)];

    if crossing_mask(i)
        plot(ax, xplot, yplot, 'Color', app.IntersectingNeedleColourPicker.Value);
    else
        plot(ax, xplot, yplot, 'Color', app.NeedleColourPicker.Value);
    end
end
```

#table(
    columns: (auto, auto),
    stroke: none,
    [#image("images/basic.png", width: 256pt)],
    [#image("images/square.png", width: 256pt)]
)

== Selection

For the first program, the user can click a needle to highlight it, as well as `n` amount of needles with the most similar orientation. I do this by projecting a vector from the clicked needle, on to the needle itself, and finding the closest needle of all needles.

All the data is stored previously by the simulation, so I access them as properties of `app`.

```matlab
x1 = app.NeedleX1(i); y1 = app.NeedleY1(i);
x2 = app.NeedleX2(i); y2 = app.NeedleY2(i);

% Vector along the needle
vx = x2 - x1; vy = y2 - y1;
% Vector from needle start to click
wx = cx - x1; wy = cy - y1;

% Scalar project click vector onto needle vector
% And clamp to [0,1] to stay bounded within the needle
% t = dot(w, v) / dot(v, v)
t = (vx*wx + vy*wy) / (vx*vx + vy*vy);
t = max(0, min(1, t));

% Find the closest point on the needle to the click
px = x1 + t*vx;
py = y1 + t*vy;

% And finally, the distance from that point to the click
dist(i) = hypot(cx - px, cy - py);
```

This calculates the distance with every needle, so that the user does not need to be within a fine margin of error to select a needle, and can just click near it.

And then, to find the `n` most similar needles by angle, I calculate the absolute difference in angle, and sort them to find the closest `n`.
```matlab
n = app.SelectionCountEditField.Value;
current_angle = app.NeedleAngle(idx);
other_angles = abs(app.NeedleAngle - current_angle);

% Get the closest needles in angle, excluding the most similar
% (the already selected needle)
[~, order] = sort(other_angles);
similar_idx = order(2:n+1);
```

#image("images/selection.png", width: 512pt)

== Improvements

There are plenty of performance improvements that I could make to the code. For example, the square crossing detection could be vectorised to avoid the for loop over each throw. This would involve more complex indexing, but would speed up the simulation for large numbers of throws.

This corner calculation could also be exported to the display code to avoid recalculating the corners again when drawing the squares.

== References

<ref1> [1] S. Velasco , F. L. Román , A. González & J. A. White (2006) Statistical estimation of some irrational numbers using an extension of Buffon's needle experiment, International Journal of Mathematical Education in Science and Technology, 37:6, 735-740, DOI: 10.1080/00207390500432675