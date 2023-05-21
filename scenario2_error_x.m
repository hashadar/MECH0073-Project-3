% This file was used to find the error in position. The same file is
% modififed for all scenarios and x, y, and z positions.

clc
close all

hfig = figure;  % save the figure handle in a variable
plot(t_fis2,smooth(er_x_fis2,10),'Color', [0 0.4470 0.7410],'LineWidth',1.5);
hold on
plot(t_pid2,smooth(er_x_pid2,10),'Color', [0.8500 0.3250 0.0980],'LineWidth',1.5);
hold on
y_l1=yline([2 10],'-.r',{'2%','10%'},'LineWidth',0.8);
%hold on
%yline(2,'-.r','2%')
tit=title('Scenario 2 ANFIS v PID Control Response (x)');
xl=xlabel('Time (seconds)');
yl=ylabel('% Error in Position x');
fontsize(14,"points")
lg = legend('ANFIS', 'PID');
lg.Location = 'best';

fname = 'Scenario 2 Error in x Position';

picturewidth = 20; 
hw_ratio = 0.6; 
set(findall(y_l1,'-property','FontSize'),'FontSize',13) 
set(findall(lg,'-property','FontSize'),'FontSize',17) 
set(findall(tit,'-property','FontSize'),'FontSize',17) 
set(findall(xl,'-property','FontSize'),'FontSize',17)
set(findall(yl,'-property','FontSize'),'FontSize',17) 
set(findall(hfig,'-property','Box'),'Box','off') % optional
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(hfig,fname,'-dpdf','-vector','-fillpage')
