function step_moeaddda_withPSarchive(mop, g)

global params population ;
global archival;
   
    population_density();
    subproblemindex = weightadaptation(1, 'X', g);

    for i=1:length(subproblemindex)
        %dynamic neighborhood
        if rand() < params.pns
            neighborhood = population.neighbor(1:params.niche,subproblemindex(i));
        else
            neighborhood = 1:params.popsize;
        end

        %new point generation using genetic operations, and evaluate it.
        ind     = de(subproblemindex(i), neighborhood);
        obj     = evaluate(mop, ind);
        
        %update the idealpoint.
        population.ideapoint  = min(population.ideapoint, obj);

        %update the neighbours.
        update(obj, ind, neighborhood);
    end
    
    params.fes  = params.fes + params.popsize;
    
    pointf          = [archival.objective, population.objective]; 
    pointx          = [archival.parameter, population.parameter];
    pointv          = zeros(1, size(pointx,2));
    [archival.objective, archival.parameter, ~] = NDSelector(pointf, pointx, pointv, params.popsize);
    
    clear subproblemindex ind obj neighbourhood pointf pointx pointv;
end

%%
function ip = weightadaptation(delete, flag, g)

global population params

% save data
W = population.W;
X = population.parameter;
F = population.objective;

% adjust the weight
ip = weight_adjust(delete, flag, g);
W1 = population.WA.W(:,ip);

% update weight
population.W            = get_weights();
params.popsize          = size(population.W,2);
v                       = squareform(pdist(population.W'));
[~, population.neighbor]= sort(v);

D           = pdist2(W1', population.W');
[~,index]   = sort(D,2);
ip          = index(:,1)';

% assign data to new subproblems
D           = pdist2(population.W', W');
[~,index]   = sort(D,2);
index       = index(:,1)';
population.parameter    = X(:,index);
population.objective    = F(:,index);

clear W X F v D index;
end

%%
function update(obj, parameter, neighborhood)
%updating of the neighborindex with the given new individuals
global params population;
    
    %objective values of current solution
    newobj  = subobjective(population.W(:,neighborhood), obj, population.ideapoint, params.dmethod);
    %previous objective values
    oldobj  = subobjective(population.W(:,neighborhood), population.objective(:,neighborhood), population.ideapoint, params.dmethod);    
    %new solution is better?
    C       = newobj < oldobj; 
    
    %repace with the new one
    if (length(C(C==1)) <= params.updatesize)
        toupdate = neighborhood(C);
    else
        toupdate = randsample(neighborhood(C), params.updatesize);
    end    
    population.parameter(:,toupdate) = repmat(parameter, [1, size(toupdate)]);
    population.objective(:,toupdate) = repmat(obj, [1, size(toupdate)]); 
    clear subp newobj oops oldobj C toupdate;
end

%%
function ind = de(index, neighborhood)

global population params;
    %parents
    si      = ones(1,3)*index;
    while si(2)==si(1) || si(3)==si(1) || si(3)==si(2)
        si(2:3) = randsample(neighborhood, 2);
    end

    %retrieve the individuals.
    selectpoints    = population.parameter(:, si);

    %generate new trial point
    newpoint        = selectpoints(:,1)+params.F*(selectpoints(:,2)-selectpoints(:,3));

    %repair the new value
    rnds            = rand(params.xdim,1);
    pos             = newpoint>params.xupp;
    if sum(pos)>0
        newpoint(pos) = selectpoints(pos,1) + rnds(pos,1).*(params.xupp(pos)-selectpoints(pos,1));
    end
    pos             = newpoint<params.xlow;
    if sum(pos)>0
        newpoint(pos) = selectpoints(pos,1) - rnds(pos,1).*(selectpoints(pos,1)-params.xlow(pos));
    end
    
    ind             = realmutate(newpoint, params.pm);

    clear si selectpoints newpoint pos;
end

%%
function ind = realmutate(ind, rate)
%REALMUTATE Summary of this function goes here
%   Detailed explanation goes here
global params;

    eta_m = params.etam;

    for j = 1:params.xdim
      r = rand();
      if (r <= rate) 
        y       = ind(j);
        yl      = params.xlow(j);
        yu      = params.xupp(j);
        delta1  = (y - yl) / (yu - yl);
        delta2  = (yu - y) / (yu - yl);

        rnd     = rand();
        mut_pow = 1.0 / (eta_m + 1.0);
        if (rnd <= 0.5) 
          xy    = 1.0 - delta1;
          val   = 2.0 * rnd + (1.0 - 2.0 * rnd) * (xy^(eta_m + 1.0));
          deltaq= (val^mut_pow) - 1.0;
        else 
          xy    = 1.0 - delta2;
          val   = 2.0 * (1.0 - rnd) + 2.0 * (rnd - 0.5) * (xy^ (eta_m + 1.0));
          deltaq= 1.0 - (val^mut_pow);
        end

        y   = y + deltaq * (yu - yl);
        if y < yl, y = yl; end
        if y > yu, y = yu; end

        ind(j) = y;        
      end
    end
end

%%
function population_density()

global params population ;


% density = distance between a point and the mean of its neighbors
NN = 6;
dis2m   = zeros(1,params.popsize);
dis2f   = zeros(1,params.popsize);
% adis2m   = zeros(1,params.popsize);
% adis2f   = zeros(1,params.popsize);
for i=1:params.popsize
    neighbori   = population.neighbor(1:NN, i);
    neighborx   = population.parameter(:,neighbori);
    neighborf   = population.objective(:,neighbori);
    dis2m(i)	= max(sum((repmat(neighborx(:,1),1,NN) - neighborx).^2));
    dis2f(i)	= max(sum((repmat(neighborf(:,1),1,NN) - neighborf).^2));
    
end

population.DenX     = dis2m;
population.DenF     = dis2f;


clear dis2m neighbori neighborx;

end