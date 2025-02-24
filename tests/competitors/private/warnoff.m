function orig_warning_state = warnoff(solvers)
% This file is cited from https://github.com/libprima/prima/blob/main/matlab/tests/private/warnoff.m, which is
% written by Zaikun ZHANG.

orig_warning_state = warning;

for isol = 1 : length(solvers)
    if endsWith(solvers{isol}, '_classical')
        solvers{isol} = regexprep(solvers{isol}, '_classical', '');
        warning('off', [solvers{isol}, ':Classical']);
        warning('off', [solvers{isol}, ':IprintContradictClassical']);
    end
end

solvers = regexprep(solvers, '_single', '');
solvers = regexprep(solvers, '_quadruple', '');
solvers = regexprep(solvers, '_archiva', '_norma');
solvers = [solvers, 'prima', 'prima_norma'];

cellfun(@(solver) warning('off', [solver, ':Debug']), solvers);
cellfun(@(solver) warning('off', [solver, ':ChkFunval']), solvers);
cellfun(@(solver) warning('off', [solver, ':ReviseX0']), solvers);
cellfun(@(solver) warning('off', [solver, ':UnknownProbField']), solvers);
cellfun(@(solver) warning('off', [solver, ':UnknownOption']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidMaxfun']), solvers);
cellfun(@(solver) warning('off', [solver, ':ExtremeBarrier']), solvers);
cellfun(@(solver) warning('off', [solver, ':IprintContradictFortran']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidMaxhist']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidNpt']), solvers);
cellfun(@(solver) warning('off', [solver, ':ObjectiveAbnormalReturn']), solvers);
cellfun(@(solver) warning('off', [solver, ':ConstraintAbnormalReturn']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidChkfunval']), solvers);
cellfun(@(solver) warning('off', [solver, ':FortranContradictPrecision']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidMaxfun']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidMaxfilt']), solvers);
cellfun(@(solver) warning('off', [solver, ':InvalidPrecision']), solvers);
cellfun(@(solver) warning('off', [solver, ':IprintContradictQuiet']), solvers);
cellfun(@(solver) warning('off', [solver, ':FortranContradictClassical']), solvers);
cellfun(@(solver) warning('off', [solver, ':FortranContradictPrecision']), solvers);
cellfun(@(solver) warning('off', [solver, ':ObjectiveFailure']), solvers);
cellfun(@(solver) warning('off', [solver, ':ConstraintFailure']), solvers);
cellfun(@(solver) warning('off', [solver, ':X0IsRow']), solvers);
cellfun(@(solver) warning('off', [solver, ':BeqIsRow']), solvers);
cellfun(@(solver) warning('off', [solver, ':BineqIsRow']), solvers);
%cellfun(@(solver) warning('off', ['FMXAPI:', upper(solver)]), solvers);

return
