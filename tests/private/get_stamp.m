function solver_stamp = get_stamp(parameters, i)
% GET_STAMP gets the stamp of j-th solver on performance profile.
%

switch parameters.solvers_options{i}.solver
    case {"bds"}
        solver_stamp = upper(parameters.solvers_options{i}.Algorithm);
        if isfield(parameters.solvers_options{i}, "sufficient_decrease_factor")
            for j = 1:length(parameters.solvers_options{i}.sufficient_decrease_factor)
                if parameters.solvers_options{i}.sufficient_decrease_factor(j) == 0
                    solver_stamp = strcat(solver_stamp, "-", ...
                        num2str(parameters.solvers_options{i}.sufficient_decrease_factor(j)));
                elseif parameters.solvers_options{i}.sufficient_decrease_factor(j) == eps
                    solver_stamp = strcat(solver_stamp, "-", "eps");
                else
                    solver_stamp = strcat(solver_stamp, "-", ...
                        int2str(int32(-log10(parameters.solvers_options{i}.sufficient_decrease_factor(j)))));
                end
            end
        end

        if isfield(parameters.solvers_options{i}, "alpha_init_perturbed") && parameters.solvers_options{i}.alpha_init_perturbed
            solver_stamp = strcat(solver_stamp, "-", "perturbed");
        end

        if isfield(parameters.solvers_options{i}, "forcing_function_type")
            solver_stamp = strcat(solver_stamp, "-", parameters.solvers_options{i}.forcing_function_type);
        end

    case {"dspd"}
        solver_stamp = "dspd";

    case {"bds_powell"}
        solver_stamp = "CBDS-Powell";

    case {"fminsearch_wrapper"}
        solver_stamp = "simplex";

    case {"fminunc_wrapper"}
        solver_stamp = upper(parameters.solvers_options{i}.fminunc_type);

    case {"wm_newuoa"}
        solver_stamp = "wm-newuoa";

    case {"nlopt_wrapper"}
        switch parameters.solvers_options{i}.Algorithm
            case "cobyla"
                solver_stamp = "nlopt-cobyla";
            case "newuoa"
                solver_stamp = "nlopt-newuoa";
            case "bobyqa"
                solver_stamp = "nlopt-bobyqa";
        end

    case {"nomad_wrapper"}
        solver_stamp = "nomad";

    case {"lam"}
        solver_stamp = "lam";

    case {"patternsearch"}
        solver_stamp = "patternsearch";

    case {"bfo_wrapper"}
        solver_stamp = "bfo";

    case {"prima_wrapper"}
        solver_stamp = parameters.solvers_options{i}.Algorithm;
end

end
