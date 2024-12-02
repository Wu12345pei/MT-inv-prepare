function [x_selected, y_selected] = Select_equal_spacing(x, y, n)
%SELECT_EQUAL_SPACING Selects approximately equally spaced n points from xy data.
%   [x_selected, y_selected] = SELECT_EQUAL_SPACING(x, y, n) takes vectors x and y,
%   and selects n points that are approximately equally spaced along the x-axis,
%   spanning the entire range of the data.
%
%   Inputs:
%       x - Vector of x-coordinates.
%       y - Vector of y-coordinates corresponding to x.
%       n - Number of points to select.
%
%   Outputs:
%       x_selected - Selected x-coordinates.
%       y_selected - Selected y-coordinates corresponding to x_selected.

    % Ensure x and y are column vectors
    x = x(:);
    y = y(:);

    % Check that x and y have the same length
    if length(x) ~= length(y)
        error('Vectors x and y must have the same length.');
    end

    % Sort the data based on x-values
    [x_sorted, sortIdx] = sort(x);
    y_sorted = y(sortIdx);

    % Compute the range of x-values
    x_min = x_sorted(1);
    x_max = x_sorted(end);

    % Divide the x-range into n intervals
    x_edges = linspace(x_min, x_max, n+1);

    % Initialize array to hold selected indices
    selected_indices = zeros(n, 1);

    % Loop over each interval to select one point
    for i = 1:n
        % Define the interval boundaries
        x_start = x_edges(i);
        x_end = x_edges(i+1);

        % Find indices of data points within the interval
        idx_in_interval = find(x_sorted >= x_start & x_sorted <= x_end);

        if isempty(idx_in_interval)
            % No data points in this interval, skip to next
            continue;
        end

        % Find the data point closest to the center of the interval
        x_center = (x_start + x_end) / 2;
        [~, minIdx] = min(abs(x_sorted(idx_in_interval) - x_center));

        % Store the index of the selected data point
        selected_indices(i) = idx_in_interval(minIdx);
    end

    % Remove zero entries in case some intervals had no data points
    selected_indices(selected_indices == 0) = [];

    % Retrieve the selected x and y values
    x_selected = x_sorted(selected_indices);
    y_selected = y_sorted(selected_indices);
end

