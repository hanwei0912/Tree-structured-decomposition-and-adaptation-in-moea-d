function demo_moeaddda_withPFarchive(problem,times)
% demo('tec09_f1')

path('../problem',path); 
path('../problem/cec09',path); 
path('../public',path);
path('wd',path)

%problem = 'tec09_f3';

mop     = testmop(problem, 30);
popsize = 300;

tic;

init_moeaddda_withPFarchive('problem', mop, 'popsize', popsize, 'niche', 20, 'pns', 0.9, 'F', 0.5, 'method', 'ts', 'updatesize', 2);
% updateplot(0);
for g=1:1000
    step_moeaddda_withPFarchive(mop, g);
%     updateplot(g);
    if mod(g,10)==0
        sname = sprintf('data/moeaddda_withPFarchive/%s_run%d_gen%d', problem, times, g);
        savearchival(sname);
    end
end
endt    = toc;   

% movie2avi(F,'d:/tec09_f1.avi');

disp(endt); 

end


%% 

function savedata(name)
global population;

pareto  = population;
df      = [pareto.objective]; df = df'; 
ds      = [pareto.parameter]; ds = ds'; 

save(name, 'df', 'ds');

clear pareto df ds;
end

function savearchival(name)
global archival population;

pareto  = population;
apareto =archival;

df      = [pareto.objective]; df = df'; 
ds      = [pareto.parameter]; ds = ds'; 
af      = [apareto.objective]; af=af';
as      = [apareto.parameter]; as=as';

save(name, 'df', 'ds','af','as');

clear pareto df ds af as apareto;
end

%%
function updateplot(gen)

global population archival;

af      = archival.objective; af=af';
as      = archival.parameter; as=as';

df      = population.objective; df = df';
ds      = population.parameter; ds = ds';
str     = sprintf('gen=%d', gen);

hold off; 
subplot(1,4,1);
if size(df,2) == 2
    plot(df(:,1), df(:,2), 'ro', 'MarkerSize',4);
    xlabel('f1', 'FontSize', 6);
    ylabel('f2', 'FontSize', 6);
else
    plot3(df(:,1), df(:,2), df(:,3), 'ro', 'MarkerSize',4);
    xlabel('f1', 'FontSize', 6);
    ylabel('f2', 'FontSize', 6);
    zlabel('f3', 'FontSize', 6);
end
title(str, 'FontSize', 8);
box on;
drawnow;

subplot(1,4,2);
if size(ds,2) >= 3
    plot3(ds(:,1), ds(:,2), ds(:,3), 'ro', 'MarkerSize',4);
    xlabel('x1', 'FontSize', 6);
    ylabel('x2', 'FontSize', 6);
    zlabel('x3', 'FontSize', 6);    
elseif size(ds,2) >= 2
    plot(ds(:,1), ds(:,2), 'ro', 'MarkerSize',4);
    xlabel('x1', 'FontSize', 6);
    ylabel('x2', 'FontSize', 6);
end
box on;
drawnow;

subplot(1,4,4);
% if size(as,2) >= 3
%     plot3(as(:,1), as(:,2), as(:,3), 'ro', 'MarkerSize',4);
%     xlabel('x1', 'FontSize', 6);
%     ylabel('x2', 'FontSize', 6);
%     zlabel('x3', 'FontSize', 6);    
% elseif size(as,2) >= 2
%     plot(as(:,1), as(:,2), 'ro', 'MarkerSize',4);
%     xlabel('x1', 'FontSize', 6);
%     ylabel('x2', 'FontSize', 6);
% end
if size(df,2) >= 3
    plot3(population.W(1,:), population.W(2,:), population.W(3,:), 'ro', 'MarkerSize',4);
    xlabel('w1', 'FontSize', 6);
    ylabel('w2', 'FontSize', 6);
    zlabel('w3', 'FontSize', 6);    
elseif size(df,2) >= 2
    plot(population.W(1,1:end), population.W(2,1:end), 'ro', 'MarkerSize',4);
    xlabel('w1', 'FontSize', 6);
    ylabel('w2', 'FontSize', 6);
end
box on;
drawnow;

subplot(1,4,3);
plot(population.W(1,1:end),ds(1:end,1), 'ro', 'MarkerSize',4);
xlabel('w1', 'FontSize', 6);
ylabel('x1', 'FontSize', 6);
% if size(af,2) == 2
%     plot(af(:,1), af(:,2), 'ro', 'MarkerSize',4);
%     xlabel('f1', 'FontSize', 6);
%     ylabel('f2', 'FontSize', 6);
% else
%     plot3(af(:,1), af(:,2), af(:,3), 'ro', 'MarkerSize',4);
%     xlabel('f1', 'FontSize', 6);
%     ylabel('f2', 'FontSize', 6);
%     zlabel('f3', 'FontSize', 6);
% end
title(str, 'FontSize', 8);
box on;
drawnow;
clear pareto df ds af as;
end