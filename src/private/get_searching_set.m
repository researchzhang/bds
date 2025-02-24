function D = get_searching_set(n, options)
   %SEARCHING_SET generates the set of polling directions.
   %
   %D should be a matrix with n rows, whose columns are the polling directions.
   %D = SEARCHING_SET(N) generates the set of polling directions
   %{e_1, -e_1, ..., e_n, -e_n}, which is canonical and represented in matrix form.
   %
   %D = SEARCHING_SET(N, OPTIONS) allows to provide options to the set
   %generation. Set OPTIONS.direction to "identity" to obtain
   %{e_1, ..., e_n, -e_1,..., -e_n}, represented in matrix form.
   %Set OPTIONS.direction to "canonical" to obtain {e_1, -e_1, ..., e_n, -e_n}, 
   %represented in matrix form.
   %If users input OPTIONS.searching_set in matrix form, the function will first
   %remove the directions in which their norm are too small. Next, those directions
   %which are parallel in pairs will be found. Then the function will preserve the first
   %one appearing in the searching set and remove the others. By QR factorization,
   %the searching set will linearly span the full space (If the searching set is 
   %already canonical before QR factorization, then there will be no change).
   %Finally, the set will positively span the full space by adding the 
   %negative direction in an alternating way.
   %

% Set options to an empty structure if it is not provided.
if nargin < 2
    options = struct();
end

if isfield(options, "searching_set")

    searching_set = options.searching_set;

    % Determine whether the searching set contains NaN or Inf values and replace those
    % elements with 10^20.
    hasNaNInf = any(isnan(searching_set) | isinf(searching_set), "all"); 
    if hasNaNInf
        warning("The searching set contains NaN or inf.");
        searching_set(isnan(searching_set) | isinf(searching_set)) = 0;  
    end
    
    % Remove the directions in which their norm are too small.
    % In case there exists a direction whose each component is eps.
    shortest_direction_norm = 10*sqrt(n)*eps;
    direction_norms = sqrt(sum(searching_set.^2, 1));
    short_directions = (direction_norms < shortest_direction_norm);
    if any(short_directions)
        warning("The searching set contains directions shorter than %g. They are removed.", ...
            shortest_direction_norm);  
        searching_set = searching_set(:, ~short_directions);
    end
    
    % Find those directions that are parallel in pairs. Preserve the first one appearing in the 
    % searching set and remove the others.
    direction_norms = sqrt(sum(searching_set.^2, 1)); 
    % Compare the inner products with the product of the norms to see whether the directions are
    % parallel.
    % Which one is better, 1e-10 or sqrt(eps)?
    parallel_directions = (abs(searching_set'*searching_set) > (1 - 1.0e-10) * (direction_norms' * direction_norms)); 
    % Parallel_directions is a symmetric matrix, whose diagonal is 1. Triu(parallel_directions, 1) returns 
    % the indices of the upper triangular part of the matrix parallel_directions, setting the diagonal as zero.
    % By using find, we can get the row and column indices of the elements in the upper triangular part of 
    % parallel_directions in pair, whose boolean value is 1. The column indices are the indices of the parallel 
    % directions that do not appear for the first time in the searching set. 
    [~, repetition_directions_indices] = find(triu(parallel_directions, 1));
    
    % We remove the directions that are parallel in pairs by QR factorization, not appearing the first time.
    preserved_indices = ~ismember(1:size(searching_set, 2), repetition_directions_indices);
    % Keep the remaining direction.
    D = searching_set(:, preserved_indices);
    if isempty(D)
        D = eye(n);
    end

    % By QR factorization, the searching set will linearly span the full space.
    % By the permutation matrix P, the absolute values of the diagonal 
    % elements of R will decrease. We preserve the columns in D where the
    % diagonal elements of R are not too small correspondingly. To make D
    % linearly span the full space, we introduce some columns in Q. 
    [Q, R, ~] = qr(D);
    [~, m] = size(R);
    % If R is a vector, diag(R) will be broadcasted into a matrix. So we 
    % discuss into two situations. If R is a vector, we only select the
    % first element on its diagonal to see whether it is larger than the
    % tolerance. If R is a matrix, then we select the transpose of the
    % diag(R) since the vecnorm will return a column vector.
    if min(m, n) == 1 
        rank_D_clean = sum(abs(R(1, 1)) > 10*eps*max(m,n)*R(1, 1));
    else
        rank_D_clean = sum(abs(diag(R))' > 10*eps*max(m,n)*vecnorm(R(1:min(m,n), 1:min(m,n))));
    end
    D = [D, Q(:, rank_D_clean+1:end)];
    
    % Make the searching set positively span the full space.
    D = [D, -D];
else
    % Set the default searching set, which is identity.
    D = [eye(n), -eye(n)];
end

% If the direction is not identity, then the searching set is canonical.
if ~isfield(options, "direction") || options.direction ~= "identity"
    perm = NaN(2*n, 1);
    perm(1:2:2*n-1) = 1:n;
    perm(2:2:2*n) = n+1:2*n;
    D = D(:, perm);     
end

end
