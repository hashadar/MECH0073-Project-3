% This file was used to find the allocated computational power.

clc
close all
%FIS scene 1
al_mem_fis1=[458452 346764 318372 331692 339528];
peak_mem_fis1=[337604 301224 278768 296548 294936];
cp_time_fis1=[81.002 72.51 71.118 73.304 70.166];
fis1_al_cp=mean(al_mem_fis1);
fis1_p_cp=mean(peak_mem_fis1);
fis1_t=mean(cp_time_fis1);

%PID scene 1
al_mem_pid1=[363348 329560 348672 342704 330560];
peak_mem_pid1=[300908 297800 297664 297980 297664];
cp_time_pid1=[68.494 68.331 71.992 70.536 69.738];
pid1_al_cp=mean(al_mem_pid1);
pid1_p_cp=mean(peak_mem_pid1);
pid1_t=mean(cp_time_pid1);

%FIS scene 2
al_mem_fis2=[346496 351848 325104 324408 343012];
peak_mem_fis2=[323004 324908 346260 353116 321960];
cp_time_fis2=[83.5 83.153 83.207 82.561 82.382];
fis2_al_cp=mean(al_mem_fis2);
fis2_p_cp=mean(peak_mem_fis2);
fis2_t=mean(cp_time_fis2);

%PID scene 2
al_mem_pid2=[356608 366224 368392 355956 351800];
peak_mem_pid2=[306708 327232 330032 325644 322588];
cp_time_pid2=[113.763 112.296 110.390 107.608 108.563];
pid2_al_cp=mean(al_mem_pid2);
pid2_p_cp=mean(peak_mem_pid2);
pid2_t=mean(cp_time_pid2);

%FIS scene 3
al_mem_fis3=[544504 557044 543148 558260 553592];
peak_mem_fis3=[311440 317636 314304 322668 315192];
cp_time_fis3=[179.63 177.476 177.830 177.183 177.854];
fis3_al_cp=mean(al_mem_fis3);
fis3_p_cp=mean(peak_mem_fis3);
fis3_t=mean(cp_time_fis3);

%PID scene 3
al_mem_pid3=[454472 541492 545596 545363 540896];
peak_mem_pid3=[328112 328064 311016 314340 313836];
cp_time_pid3=[124.849 120.493 120.41 120.062 120.545];
pid3_al_cp=mean(al_mem_pid3);
pid3_p_cp=mean(peak_mem_pid3);
pid3_t=mean(cp_time_pid3);

%FIS scene 4
al_mem_fis4=[417956 522068 521120 523152 525048];
peak_mem_fis4=[333672 337952 340240 348012 348084];
cp_time_fis4=[178.597 180.705 178.084 177.012 177.217];
fis4_al_cp=mean(al_mem_fis4);
fis4_p_cp=mean(peak_mem_fis4);
fis4_t=mean(cp_time_fis4);

%PID scene 4
al_mem_pid4=[494780 384396 366376 388392 390552];
peak_mem_pid4=[320968 325708 322028 330036 331796];
cp_time_pid4=[126.570 124.187 123.624 130.195 126.991];
pid4_al_cp=mean(al_mem_pid4);
pid4_p_cp=mean(peak_mem_pid4);
pid4_t=mean(cp_time_pid4);

%FIS scene 5
al_mem_fis5=[619120 557252 544696 514920 542096];
peak_mem_fis5=[330112 353004 345336 343856 338156];
cp_time_fis5=[227.684 222.704 220.849 218.394 219.395];
fis5_al_cp=mean(al_mem_fis5);
fis5_p_cp=mean(peak_mem_fis5);
fis5_t=mean(cp_time_fis5);

%PID scene 5
al_mem_pid5=[535316 555200 527868 552040 542268];
peak_mem_pid5=[332300 336644 340980 344352 354104];
cp_time_pid5=[270.034 270.237 272.776 277.7 277.333];
pid5_al_cp=mean(al_mem_pid5);
pid5_p_cp=mean(peak_mem_pid5);
pid5_t=mean(cp_time_pid5);

al_diff1=round(((fis1_al_cp-pid1_al_cp)/pid1_al_cp)*100,1);
al_diff2=round(((fis2_al_cp-pid2_al_cp)/pid2_al_cp)*100,1);
al_diff3=round(((fis3_al_cp-pid3_al_cp)/pid3_al_cp)*100,1);
al_diff4=round(((fis4_al_cp-pid4_al_cp)/pid4_al_cp)*100,1);
al_diff5=round(((fis5_al_cp-pid5_al_cp)/pid5_al_cp)*100,1);

x = {'Scenario 1', 'Scenario 2', 'Scenario 3', 'Scenario 4', 'Scenario 5'};
alloc = [pid1_al_cp, fis1_al_cp; pid2_al_cp, fis2_al_cp; pid3_al_cp, fis3_al_cp; pid4_al_cp, fis4_al_cp; pid5_al_cp, fis5_al_cp];

hfig=figure;
b = bar(alloc);
set(gca, 'xticklabel', x);
diff_values = [al_diff1, al_diff2, al_diff3, al_diff4, al_diff5];
for k = 1:length(diff_values)
    % Add '+' before positive values and '%' after all values
    if diff_values(k) > 0
        diff_text = ['+', num2str(diff_values(k)), '%'];
    else
        diff_text = [num2str(diff_values(k)), '%'];
    end

    text(k+0.05, alloc(k,2), diff_text, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
end
%b.BarWidth=0.1;
tit=title('Allocated Computational Memory Results');
yl=ylabel('Computational Memory (kB)');
fontsize(14,"points")
lg = legend('PID', 'ANFIS');
lg.Location = 'northwest';

fname = 'Allocated Computational Power';

picturewidth = 20; 
hw_ratio = 0.6; 
set(findall(lg,'-property','FontSize'),'FontSize',14) 
set(findall(tit,'-property','FontSize'),'FontSize',17) 
set(findall(yl,'-property','FontSize'),'FontSize',17) 
set(findall(hfig,'-property','Box'),'Box','off') % optional
set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(hfig,'Position');
set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(hfig,fname,'-dpdf','-vector','-fillpage')