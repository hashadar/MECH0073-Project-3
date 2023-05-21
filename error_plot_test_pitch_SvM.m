% This file was used to plot the prediction error for each datapoint, for
% different configurations of each FIS.

clc
close all
l=(1:length(pitch1_S))';
rmse_pitch1_S=sqrt(mean(pitch1_S.^2));
rmse_pitch1_M=sqrt(mean(pitch1_M.^2));

hfig = figure;  % save the figure handle in a variable
plot(l,pitch1_S,'Color', [0 0.4470 0.7410],'LineWidth',1.5);
hold on
plot(l,pitch1_M,'Color', [0.8500 0.3250 0.0980],'LineWidth',1.5);
tit=title('Pitch Sugeno v Mamdani ANFIS');
xl=xlabel('Data Point Index');
yl=ylabel('Prediction Error');
fontsize(30,"points")
lg = legend(['Sugeno Type-1, RMSE = ' num2str(rmse_pitch1_S)], ['Mamdani Type-1, RMSE = ' num2str(rmse_pitch1_M)]);
lg.Location = 'best';

fname = 'Pitch SvM';

picturewidth = 60; 
hw_ratio = 0.6; 
set(findall(lg,'-property','FontSize'),'FontSize',28) 
set(findall(tit,'-property','FontSize'),'FontSize',50) 
set(findall(xl,'-property','FontSize'),'FontSize',50)
set(findall(yl,'-property','FontSize'),'FontSize',50) 
set(findall(hfig,'-property','Box'),'Box','off') % optional
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(hfig,fname,'-dpdf','-vector','-fillpage')
