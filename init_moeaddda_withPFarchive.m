function init_moeaddda_withPFarchive(varargin)

global params population archival

    % call global init function
    initpub(varargin);
    
    % Set up the initial setting for the MOEA/D
    %the parameter for the DE.
    params.F 	= 0.5;

    %handle the parameters, mainly about the popsize        
    for k=1:2:length(varargin)
        switch varargin{k}
            case 'problem'
                mop         = varargin{k+1};            
            case 'F'
                params.F    = varargin{k+1};
        end
    end
    params.pm   = 1.0/params.xdim;
    
    params.fes  = 0;
    
    %% blocks
    population.W  = [];
    population.WA = [];     % weight adaptation
    block_init(params.popsize); 
    population.ITabuB       = 1;%:127;            % tabu blocks that can not be removed
    population.W            = get_weights();
    params.popsize          = size(population.W,2);
    v                       = squareform(pdist(population.W'));
    [~, population.neighbor]= sort(v);
    params.popsize          = size(population.W,2);
    
    % initialize the population
    population.parameter	= initpop(mop, params.popsize);
    population.objective	= evaluate(mop, population.parameter);

    % initialize the approximation model
    population.ideapoint    = min(population.objective,[],2);
    
    % index of extreme subproblems
    [~,population.eindex]   = max(population.W,[],2);    
    
    % initialize the archival
    archival.parameter=[];
    archival.objective=[];
end

