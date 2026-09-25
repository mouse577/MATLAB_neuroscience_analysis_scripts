% NEW pERG / VEP analysis

myDir = uigetdir;
myFiles = dir(fullfile(myDir, '*.txt'));
n = length(myFiles);

prompt = {'Enter 0 for pERG or 1 for VEP'};
dlg_title = 'Type of analysis';
num_lines = 1;
def = {'0'};
options.Resize = 'on';
options.WindowStyle = 'normal';
answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
TYPE = answer;
figNum = 1;

% FOR pERG!!!!!!!!!!!!!!!!
if TYPE == 0

    M = cell(n,6);
    Tfold = (1:494)';
    Twave_norm_all = zeros(494,n);
    measurements_all = zeros(n,3);
    figNum_tiled = 100;
    figure(figNum_tiled);
    for i = 1:n
        baseFileName = myFiles(i).name;
        fullFileName = fullfile(myDir, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        T = readtable(baseFileName);
        Twave = table2array(T(:,4));
        Twave_start = Twave(1:1);

        if Twave_start < 0
            Twave_norm = Twave + abs(Twave_start);
        elseif Twave_start > 0
            Twave_norm = Twave - abs(Twave_start);
        end
        
        Twave_norm_all(:,i) = Twave_norm;

        figure(figNum);
        plot(Twave_norm);
        set(gcf, 'Position', [100,100,1600,360]);
        hold on;
        grid on;
        [ymin, minIdx] = min(Twave_norm);
        MIN = ymin - 5;
        [ymax, maxIdx] = max(Twave_norm);
        MAX = ymax + 5;
        ylim([MIN, MAX]);
        xlabel('ms');
        set(gca, 'XTick', 0:5:494);
        set(gca, 'YTick', MIN:2:MAX);
        ylabel('uV');
        i_str = num2str(i);
        title('select curr trace P1 (red), N2 (green), and N3 (blue)', i_str);
        plot(minIdx, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
        plot(maxIdx, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
        [min_n1, n1Idx] = min(Twave_norm(1:100, 1));
        plot(n1Idx, min_n1, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
    
        prompt = {'Enter 0 for NO or 1 for YES'};
        dlg_title = 'Re-select N1, P1 and N2';
        num_lines = 1;
        def = {'0'};
        options.Resize = 'on';
        options.WindowStyle = 'normal';
        figure(figNum)
        answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
        ANSWER = answer;
    
           
        if ANSWER == 0
            close(figure(figNum));
            figNum = figNum + 1;

            figure(figNum_tiled);
            nexttile;
            plot(Twave_norm);
            hold on;
            grid on;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:20:494);
            set(gca, 'YTick', MIN:10:MAX);
            ylabel('uV');
            i_str = num2str(i);
            title('select current trace P1 (red), N2 (green), N1 (blue)', i_str);
            plot(minIdx, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(maxIdx, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(n1Idx, min_n1, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            hold off;  
            
            Amp = ymax - ymin;
            measurements_all(i, 1) = Amp;
            Implicit_time_1 = maxIdx - n1Idx;
            measurements_all(i, 2) = Implicit_time_1;
            Implicit_time_2 = minIdx - maxIdx;
            measurements_all(i, 3) = Implicit_time_2;
            Twave_norm_all(:,n) = Twave_norm;
            measurements = [Amp Implicit_time_1 Implicit_time_2]

            M{i, 1} = Twave;
            M{i, 2} = Twave_norm;
            M{i, 3} = ymax;
            M{i, 4} = ymin;
            M{i, 5} = ymax - ymin;
            M{i, 6} = measurements;


        else
            ANSWER = 1;
            ymax = 0;
            maxIdx_P1 = 0;
            ymin = 0;
            minIdx_N2 = 0;
            N1_min = 0;
            minIdx_N1 = 0;

            while ANSWER == 1
                prompt = {'Enter start (ms) for P1 detection, >= 1'};
                dlg_title = 'P1 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp = zeros(1,4);
                temp(1,1) = answer;
        
                prompt = {'Enter end (ms) for P1 detection, >= 1'};
                dlg_title = 'P1 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,2) = answer;
        
                prompt = {'Enter start (ms) for N2 detection, >= 1'};
                dlg_title = 'N2 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,3) = answer;
        
                prompt = {'Enter end (ms) for N2 detection, >= 1'};
                dlg_title = 'N2 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,4) = answer;

                prompt = {'Enter start (ms) for N1 detection, >= 1'};
                dlg_title = 'N1 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,5) = answer;

                prompt = {'Enter end (ms) for N1 detection, >= 1'};
                dlg_title = 'N1 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,6) = answer;

                temp = temp';

                ymax = 0;
                maxIdx_P1 = 0;
                ymin = 0;
                minIdx_N2 = 0;
                N1_min = 0;
                minIdx_N1 = 0;

                [YMIN, ignore] = min(Twave_norm);
                
                START_P1 = temp(1,1);
                END_P1 = temp(2,1);
                [ymax, maxIdx] = max(Twave_norm(START_P1:END_P1,1));
                maxIdx_P1 = maxIdx + START_P1;
        
                START_N2 = temp(3,1);
                END_N2 = temp(4,1);
                [ymin, minIdx] = min(Twave_norm(START_N2:END_N2,1));
                minIdx_N2 = minIdx + START_N2;

                START_N1 = temp(5,1);
                END_N1 = temp(6, 1);
                [N1_min, minIdx_N1] = min(Twave_norm(START_N1:END_N1, 1));
                minIdx_N1 = minIdx_N1 + START_N1;
        
                close(figure(figNum));
                figNum = figNum + 1;
                figure(figNum);
                plot(Twave_norm);
                set(gcf, 'Position', [100,100,1600,360]);
                hold on;
                grid on;
                MIN = YMIN - 5;
                MAX = ymax + 5;
                ylim([MIN MAX]);
                xlabel('ms');
                set(gca, 'XTick', 0:5:494);
                set(gca, 'YTick', MIN:2:MAX);
                ylabel('uV');
                i_str = num2str(i);
                title('select current trace P1 (red), N2 (green), N1 (blue)', i_str);
                plot(minIdx_N2, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
                plot(maxIdx_P1, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
                plot(minIdx_N1, N1_min, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            
                prompt = {'Enter 0 for NO or 1 for YES'};
                dlg_title = 'Re-select P1 and N2';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                ANSWER = answer;
            end

            close(figure(figNum));
            Amp = ymax - ymin;
            measurements_all(i, 1) = Amp;
            Implicit_time_1 = maxIdx_P1 - minIdx_N1;
            measurements_all(i, 2) = Implicit_time_1;
            Implicit_time_2 = minIdx_N2 - maxIdx_P1;
            measurements_all(i, 3) = Implicit_time_2;
            Twave_norm_all(:,n) = Twave_norm;
            measurements = [Amp Implicit_time_1 Implicit_time_2];
            
            M{i, 1} = Twave;
            M{i, 2} = Twave_norm;
            M{i, 3} = ymax;
            M{i, 4} = ymin;
            M{i, 5} = ymax - ymin;
            M{i, 6} = measurements;
            
            close(figure(figNum));
            figure(figNum_tiled);
            nexttile;
            plot(Twave_norm);
            hold on;
            grid on;
            MIN = ymin - 5;
            MAX = ymax + 5;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:20:494);
            set(gca, 'YTick', MIN:10:MAX);
            ylabel('uV');
            i_str = num2str(i);
            title('select current trace P1 (red), N2 (green), N1 (blue)', i_str);
            plot(minIdx_N2, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(maxIdx_P1, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_N1, N1_min, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            hold off;      
   
        end    
    end
    
    Twave_norm_AVG = mean(Twave_norm_all, 2); 
    Twave_norm_AVG_SEM = zeros(494,3);
    for k = 1:494
        temp = Twave_norm_all(k,:);
        tempMean = mean(temp);
        tempstderr = std(temp)/sqrt(length(temp));
        Twave_norm_AVG_SEM(k,1) = tempMean - tempstderr;
        Twave_norm_AVG_SEM(k,2) = tempMean;
        Twave_norm_AVG_SEM(k,3) = tempMean + tempstderr;
    end
    

    figNum = figNum + 1;    
    figure(figNum);
    plot(Twave_norm_AVG);
    hold on;
    [ymin, minIdx] = min(Twave_norm_AVG);
    MIN = ymin - 5;
    [ymax, maxIdx] = max(Twave_norm_AVG);
    MAX = ymax + 5;
    ylim([MIN, MAX]);
    xlabel('ms');
    set(gca, 'XTick', 0:50:494);
    set(gca, 'YTick', MIN:5:MAX);
    ylabel('uV');
    i_str = num2str(i);
    title('AVG trace');
    plot(minIdx, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
    plot(maxIdx, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
    [min_n1, n1Idx] = min(Twave_norm_AVG(1:100, 1));
    plot(n1Idx, min_n1, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
    hold off;

    prompt = {'Enter 0 for NO or 1 for YES'};
    dlg_title = 'Re-select N1, P1 and N2';
    num_lines = 1;
    def = {'0'};
    options.Resize = 'on';
    options.WindowStyle = 'normal';
    figure(figNum);
    answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
    ANSWER = answer;

    if ANSWER == 0
        close(figure(figNum));
        figNum = figNum + 1;
        figure(figNum);
        plot(Twave_norm_AVG);
        hold on;
        [ymin, minIdx] = min(Twave_norm_AVG);
        MIN = ymin - 5;
        [ymax, maxIdx] = max(Twave_norm_AVG);
        MAX = ymax + 5;
        ylim([MIN, MAX]);
        xlabel('ms');
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
        ylabel('uV');
        i_str = num2str(i);
        title('AVG trace');
        plot(minIdx, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
        plot(maxIdx, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
        [min_n1, n1Idx] = min(Twave_norm_AVG(1:100, 1));
        plot(n1Idx, min_n1, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
        hold off;

        %good traces plot
        figNum_AVG = 101;
        figure(figNum_AVG);
        patch([Tfold;flipud(Tfold)],[Twave_norm_AVG_SEM(:,3);flipud(Twave_norm_AVG_SEM(:,1))],[200 200 200]/255, 'edgecolor','none');
        hold on
    
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'Color','k','linewidth',2);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',maxIdx);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',minIdx);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'bx','MarkerSize',10,'LineWidth',2,'MarkerIndices',n1Idx);
    
        text(Tfold(maxIdx), Twave_norm_AVG_SEM(maxIdx,2), 'P1', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        text(Tfold(minIdx), Twave_norm_AVG_SEM(minIdx,2), 'N2', 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(Tfold(n1Idx), Twave_norm_AVG_SEM(n1Idx,2), 'N1', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
        hold off
        xlim([-50,550]);
    
        [MIN, MIN_IDX] = min(Twave_norm_AVG_SEM(:,1));
        [MAX, MAX_IDX] = max(Twave_norm_AVG_SEM(:,3));
        MIN = MIN - 5;
        MAX = MAX + 5;

        MIN = pERG_MIN - 5;
        MAX = pERG_MAX + 5;
    
        ylim([MIN,MAX]);
        title('AVG trace');
        xlabel('ms');
        ylabel('uV');
        alpha(0.3);
        pbaspect([1 2 2]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
    
        figNum_all_traces = 102;
        figure(figNum_all_traces);
        MAX = max(Twave_norm_all);
        MIN = min(Twave_norm_all);
        sz = size(Twave_norm_all, 2);
        for i = 1:sz
            plot(Twave_norm_all(:,i), 'Color', 'k', 'LineWidth',0.5);
            hold on;
        end
        plot(Twave_norm_AVG, 'Color', 'r', 'LineWidth',3);
        hold off;
        xlabel('ms');
        ylabel('uV');
        title('all traces plus AVG trace');
        pbaspect([2 1 1]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
        figure(100)
        saveas(gcf, 'figure100');
        figure(101)
        saveas(gcf, 'figure101.tif');
        saveas(gcf, 'figure101');
        figure(102)
        saveas(gcf, 'figure102.tif');
        saveas(gcf, 'figure102');
    
        clearvars -except Twave_norm_AVG_SEM Twave_norm_all measurements_all M pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        save('workspace');
        clearvars -except pERG_MIN pERG_MAX VEP_MIN VEP_MAX
    
    else
        ANSWER = 1;
        while ANSWER == 1
            prompt = {'Enter start (ms) for P1 detection, >= 1'};
            dlg_title = 'P1 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp = zeros(1,4);
            temp(1,1) = answer;

            prompt = {'Enter end (ms) for P1 detection, >= 2'};
            dlg_title = 'P1 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,2) = answer;

            prompt = {'Enter start (ms) for N2 detection, >= 1'};
            dlg_title = 'N2 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,3) = answer;

            prompt = {'Enter end (ms) for N2 detection, >= 1'};
            dlg_title = 'N2 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,4) = answer;

            prompt = {'Enter start (ms) for N1 detection, >= 1'};
            dlg_title = 'N1 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,5) = answer;

            prompt = {'Enter end (ms) for N1 detection, >= 1'};
            dlg_title = 'N1 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,6) = answer;

            temp = temp';

            START_P1 = temp(1,1);
            END_P1 = temp(2,1);
            [ymax, maxIdx] = max(Twave_norm_AVG(START_P1:END_P1,1));
            maxIdx_P1 = maxIdx + START_P1;

            START_N2 = temp(3,1);
            END_N2 = temp(4,1);
            [ymin, minIdx] = min(Twave_norm_AVG(START_N2:END_N2,1));
            minIdx_N2 = minIdx + START_N2;

            START_N1 = temp(5,1);
            END_N1 = temp(6,1);
            [N1_min, minIdx_N1] = min(Twave_norm_AVG(START_N1:END_N1,1));
            minIdx_N1 = minIdx_N1 + START_N1;
            

            close(figure(figNum));
            figNum = figNum + 1;
            figure(figNum);
            plot(Twave_norm_AVG);
            hold on;
            [yAxemin, yAxeminIdx] = min(Twave_norm_AVG);
            MIN = yAxemin - 5;
            [yAxemax, yAxemaxIdx] = max(Twave_norm_AVG);
            MAX = yAxemax + 5;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:50:494);
            set(gca, 'YTick', MIN:5:MAX);
            ylabel('uV');
            title('AVG trace');
            plot(maxIdx_P1, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_N2, ymin, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_N1, N1_min, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            hold off;
        
            prompt = {'Enter 0 for NO or 1 for YES'};
            dlg_title = 'Re-select N1, P1 and P2';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            figure(figNum);
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            ANSWER = answer;
        end
    
        
        %good traces plot
        figNum_AVG = 101;
        figure(figNum_AVG);
        patch([Tfold;flipud(Tfold)],[Twave_norm_AVG_SEM(:,3);flipud(Twave_norm_AVG_SEM(:,1))],[200 200 200]/255, 'edgecolor','none');
        hold on
    
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'Color','k','linewidth',2);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',maxIdx_P1);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',minIdx_N2);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'bx','MarkerSize',10,'LineWidth',2,'MarkerIndices',minIdx_N1);
    
        text(Tfold(maxIdx_P1), Twave_norm_AVG_SEM(maxIdx_P1,2), 'N1', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        text(Tfold(minIdx_N2), Twave_norm_AVG_SEM(minIdx_N2,2), 'P1', 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(Tfold(minIdx_N1), Twave_norm_AVG_SEM(minIdx_N1,2), 'P2', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
        hold off
        xlim([-50,550]);
    
        [MIN, MIN_IDX] = min(Twave_norm_AVG_SEM(:,1));
        [MAX, MAX_IDX] = max(Twave_norm_AVG_SEM(:,3));
        MIN = MIN - 5;
        MAX = MAX + 5;

        MIN = pERG_MIN - 5;
        MAX = pERG_MAX + 5;
    
        ylim([MIN,MAX]);
        title('AVG trace');
        xlabel('ms');
        ylabel('uV');
        alpha(0.3);
        pbaspect([1 2 2]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:10:MAX);
    
        figNum_all_traces = 102;
        figure(figNum_all_traces);
        MAX = max(Twave_norm_all);
        MIN = min(Twave_norm_all);
        sz = size(Twave_norm_all, 2);
        for i = 1:sz
            plot(Twave_norm_all(:,i), 'Color', 'k', 'LineWidth',0.5);
            hold on;
        end
        plot(Twave_norm_AVG, 'Color', 'r', 'LineWidth',3);
        hold off;
        xlabel('ms');
        ylabel('uV');
        title('all traces plus AVG trace');
        pbaspect([2 1 1]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
    
        figure(100)
        saveas(gcf, 'figure100');
        figure(101)
        saveas(gcf, 'figure101.tif');
        saveas(gcf, 'figure101');
        figure(102)
        saveas(gcf, 'figure102.tif');
        saveas(gcf, 'figure102');
    
        clearvars -except Twave_norm_AVG_SEM Twave_norm_all measurements_all M pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        save('workspace');
        clearvars -except pERG_MIN pERG_MAX VEP_MIN VEP_MAX
    end

% FOR VEP!!!!!!!!
else
    M = cell(n,8);
    Tfold = (1:494)';
    Twave_norm_all = zeros(494,n);
    measurements_all = zeros(n,4);
    figNum_tiled = 100;
    figure(figNum_tiled);
    for i = 1:n
        baseFileName = myFiles(i).name;
        fullFileName = fullfile(myDir, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        T = readtable(baseFileName);
        Twave = table2array(T(:,4));
        Twave_start = Twave(1:1);

        if Twave_start < 0
            Twave_norm = Twave + abs(Twave_start);
        elseif Twave_start > 0
            Twave_norm = Twave - abs(Twave_start);
        end
        
        Twave_norm_all(:,i) = Twave_norm;

        figure(figNum);
        plot(Twave_norm);
        set(gcf, 'Position', [100,100,1600,360]);
        hold on;
        grid on;
        [ymax_N1, maxIdx_N1] = max(Twave_norm);
        MAX = ymax_N1 + 5;
        [ymin_P1, minIdx_P1] = min(Twave_norm(1:maxIdx_N1, 1));
        [ymin, minIdx] = min(Twave_norm);
        MIN = ymin - 5;
        [ymin_P2, minIdx_P2] = min(Twave_norm(maxIdx_N1:494, 1));
        minIdx_P2 = minIdx_P2 + maxIdx_N1; 
        ylim([MIN, MAX]);
        xlabel('ms');
        set(gca, 'XTick', 0:5:494);
        set(gca, 'YTick', MIN:2:MAX);
        ylabel('uV');
        i_str = num2str(i);
        title('select curr trace N1 (red), P1 (green), and P2 (blue)', i_str);
        plot(maxIdx_N1, ymax_N1, 'r*', 'MarkerSize', 10, 'linewidth', 2);
        plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
        plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
    
        prompt = {'Enter 0 for NO or 1 for YES'};
        dlg_title = 'Re-select N1, P1 and P2';
        num_lines = 1;
        def = {'0'};
        options.Resize = 'on';
        options.WindowStyle = 'normal';
        figure(figNum)
        answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
        ANSWER = answer;
    
           
        if ANSWER == 0
            close(figure(figNum));
            figNum = figNum + 1;

            figure(figNum_tiled);
            nexttile;
            plot(Twave_norm);
            hold on;
            grid on;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:20:494);
            set(gca, 'YTick', MIN:10:MAX);
            ylabel('uV');
            i_str = num2str(i);
            title('select current trace N1 (red), P1 (green), P2 (blue)', i_str);
            plot(maxIdx_N1, ymax_N1, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            hold off;  
            Amp_1 = ymax_N1 - ymin_P1
            measurements_all(i, 1) = Amp_1
            Amp_2 = ymax_N1 - ymin_P2
            measurements_all(i, 2) = Amp_2
            Implicit_time_1 = maxIdx_N1 - minIdx_P1
            measurements_all(i, 3) = Implicit_time_1
            Implicit_time_2 = minIdx_P2 - maxIdx_N1
            measurements_all(i, 4) = Implicit_time_2
            Twave_norm_all(:,n) = Twave_norm;
            measurements = [Amp_1 Amp_2 Implicit_time_1 Implicit_time_2];

            M{i, 1} = Twave;
            M{i, 2} = Twave_norm;
            M{i, 3} = ymax_N1;
            M{i, 4} = ymin_P1;
            M{i, 5} = ymin_P2;
            M{i, 6} = ymax_N1 - ymin_P1;
            M{i, 7} = ymax_N1 - ymin_P2;
            M{i, 8} = measurements;


        else
            ANSWER = 1;
            ymax_N1 = 0;
            maxIdx_N1 = 0;
            ymin_P1 = 0;
            minIdx_P1 = 0;
            ymin_P2 = 0;
            minIdx_P2 = 0;

            while ANSWER == 1
                prompt = {'Enter start (ms) for N1 detection, >= 1'};
                dlg_title = 'N1 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp = zeros(1,4);
                temp(1,1) = answer;
        
                prompt = {'Enter end (ms) for N1 detection, >= 1'};
                dlg_title = 'N1 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,2) = answer;
        
                prompt = {'Enter start (ms) for P1 detection, >= 1'};
                dlg_title = 'P1 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,3) = answer;
        
                prompt = {'Enter end (ms) for P1 detection, >= 1'};
                dlg_title = 'P1 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,4) = answer;

                prompt = {'Enter start (ms) for P2 detection, >= 1'};
                dlg_title = 'P2 start (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,5) = answer;

                prompt = {'Enter end (ms) for P2 detection, >= 1'};
                dlg_title = 'P2 end (ms)';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                temp(1,6) = answer;

                temp = temp';

                ymax_N1 = 0;
                maxIdx_N1 = 0;
                ymin_P1 = 0;
                minIdx_P1 = 0;
                ymin_P2 = 0;
                minIdx_P2 = 0;
                
                START_N1 = temp(1,1);
                END_N1 = temp(2,1);
                [ymax_N1, maxIdx_N1] = max(Twave_norm(START_N1:END_N1,1));
                maxIdx_N1 = maxIdx_N1 + START_N1;
        
                START_P1 = temp(3,1);
                END_P1 = temp(4,1);
                [ymin_P1, minIdx_P1] = min(Twave_norm(START_P1:END_P1,1));
                minIdx_P1 = minIdx_P1 + START_P1;

                START_P2 = temp(5,1);
                END_P2 = temp(6, 1);
                [ymin_P2, minIdx_P2] = min(Twave_norm(START_P2:END_P2, 1));
                minIdx_P2 = minIdx_P2 + START_P2;
        
                close(figure(figNum));
                figNum = figNum + 1;
                figure(figNum);
                plot(Twave_norm);
                set(gcf, 'Position', [100,100,1600,360]);
                hold on;
                grid on;
                MIN = ymin - 5;
                MAX = ymax_N1 + 5;
                ylim([MIN, MAX]);
                xlabel('ms');
                set(gca, 'XTick', 0:5:494);
                set(gca, 'YTick', MIN:2:MAX);
                ylabel('uV');
                i_str = num2str(i);
                title('select current trace N1 (red), P1 (green), P2 (blue)', i_str);
                plot(maxIdx_N1, ymax_N1, 'r*', 'MarkerSize', 10, 'linewidth', 2);
                plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
                plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            
                prompt = {'Enter 0 for NO or 1 for YES'};
                dlg_title = 'Re-select N1, P1 and P2';
                num_lines = 1;
                def = {'0'};
                options.Resize = 'on';
                options.WindowStyle = 'normal';
                figure(figNum);
                answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
                ANSWER = answer;
            end

            close(figure(figNum));

            Amp_1 = ymax_N1 - ymin_P1;
            measurements_all(i, 1) = Amp_1;
            Amp_2 = ymax_N1 - ymin_P2;
            measurements_all(i, 2) = Amp_2;
            Implicit_time_1 = maxIdx_N1 - minIdx_P1;
            measurements_all(i, 3) = Implicit_time_1;
            Implicit_time_2 = minIdx_P2 - maxIdx_N1;
            measurements_all(i, 4) = Implicit_time_2;
            Twave_norm_all(:,n) = Twave_norm;
            measurements = [Amp_1 Amp_2 Implicit_time_1 Implicit_time_2];

            M{i, 1} = Twave;
            M{i, 2} = Twave_norm;
            M{i, 3} = ymax_N1;
            M{i, 4} = ymin_P1;
            M{i, 5} = ymin_P2;
            M{i, 6} = ymax_N1 - ymin_P1;
            M{i, 7} = ymax_N1 - ymin_P2;
            M{i, 8} = measurements;
            
            close(figure(figNum));
            figure(figNum_tiled);
            nexttile;
            plot(Twave_norm);
            hold on;
            grid on;
            MIN = ymin - 5;
            MAX = ymax_N1 + 5;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:20:494);
            set(gca, 'YTick', MIN:10:MAX);
            ylabel('uV');
            i_str = num2str(i);
            title('select current trace N1 (red), P1 (green), P2 (blue)', i_str);
            plot(maxIdx_N1, ymax_N1, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'linewidth', 2);
            hold off;      
   
        end    
    end
    
    Twave_norm_AVG = mean(Twave_norm_all, 2); 
    Twave_norm_AVG_SEM = zeros(494,3);
    for k = 1:494
        temp = Twave_norm_all(k,:);
        tempMean = mean(temp);
        tempstderr = std(temp)/sqrt(length(temp));
        Twave_norm_AVG_SEM(k,1) = tempMean - tempstderr;
        Twave_norm_AVG_SEM(k,2) = tempMean;
        Twave_norm_AVG_SEM(k,3) = tempMean + tempstderr;
    end
    

    figNum = figNum + 1;    
    figure(figNum);
    plot(Twave_norm_AVG);
    hold on;
    [ymax_N1, maxIdx_N1] = max(Twave_norm_AVG);
    [ymin_P1, minIdx_P1] = min(Twave_norm_AVG(1:maxIdx_N1,1));
    [ymin_P2, minIdx_P2] = min(Twave_norm_AVG(maxIdx_N1:494,1));
    minIdx_P2 = minIdx_P2 + maxIdx_N1;
    [ymin, minIdx] = min(Twave_norm_AVG);
    MIN = ymin - 5;
    [ymax, maxIdx] = max(Twave_norm_AVG);
    MAX = ymax + 5;
    ylim([MIN, MAX]);
    xlabel('ms');
    set(gca, 'XTick', 0:50:494);
    set(gca, 'YTick', MIN:5:MAX);
    ylabel('uV');
    i_str = num2str(i);
    title('AVG trace');
    plot(maxIdx_N1, ymax_N1, 'r*', 'MarkerSize', 10, 'linewidth', 2);
    plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
    plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
    hold off;

    prompt = {'Enter 0 for NO or 1 for YES'};
    dlg_title = 'Re-select N1, P1 and N2';
    num_lines = 1;
    def = {'0'};
    options.Resize = 'on';
    options.WindowStyle = 'normal';
    figure(figNum);
    answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
    ANSWER = answer;

    if ANSWER == 0
        close(figure(figNum));
        figNum = figNum + 1;
        figure(figNum);
        plot(Twave_norm_AVG);
        hold on;
        [ymax, maxIdx] = max(Twave_norm_AVG);
        MAX = ymax_N1 + 5;
        [ymin, minIdx] = min(Twave_norm_AVG);
        MIN = ymin - 5;
        ylim([MIN, MAX]);
        xlabel('ms');
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
        ylabel('uV');
        i_str = num2str(i);
        title('AVG trace');
        plot(maxIdx, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
        plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
        plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
        hold off;

       %good traces plot
        figNum_AVG = 101;
        figure(figNum_AVG);
        patch([Tfold;flipud(Tfold)],[Twave_norm_AVG_SEM(:,3);flipud(Twave_norm_AVG_SEM(:,1))],[200 200 200]/255, 'edgecolor','none');
        hold on
    
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'Color','k','linewidth',2);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',maxIdx_N1);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',minIdx_P1);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'bx','MarkerSize',10,'LineWidth',2,'MarkerIndices',minIdx_P2);
    
        text(Tfold(maxIdx_N1), Twave_norm_AVG_SEM(maxIdx_N1,2), 'N1', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        text(Tfold(minIdx_P1), Twave_norm_AVG_SEM(minIdx_P1,2), 'P1', 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(Tfold(minIdx_P2), Twave_norm_AVG_SEM(minIdx_P2,2), 'P2', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
        hold off
        xlim([-50,550]);
        
        [MIN, MIN_IDX] = min(Twave_norm_AVG_SEM(:,1));
        [MAX, MAX_IDX] = max(Twave_norm_AVG_SEM(:,3));
        MIN = MIN - 5;
        MAX = MAX + 5;

        MIN = VEP_MIN - 5;
        MAX = VEP_MAX + 5;
    
        ylim([MIN,MAX]);
        title('AVG trace');
        xlabel('ms');
        ylabel('uV');
        alpha(0.3);
        pbaspect([1 2 2]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
    
        figNum_all_traces = 102;
        figure(figNum_all_traces);
        MAX = max(Twave_norm_all);
        MIN = min(Twave_norm_all);
        sz = size(Twave_norm_all, 2);
        for i = 1:sz
            plot(Twave_norm_all(:,i), 'Color', 'k', 'LineWidth',0.5);
            hold on;
        end
        plot(Twave_norm_AVG, 'Color', 'r', 'LineWidth',3);
        hold off;
        xlabel('ms');
        ylabel('uV');
        title('all traces plus AVG trace');
        pbaspect([2 1 1]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
        figure(100)
        saveas(gcf, 'figure100');
        figure(101)
        saveas(gcf, 'figure101.tif');
        saveas(gcf, 'figure101');
        figure(102)
        saveas(gcf, 'figure102.tif');
        saveas(gcf, 'figure102');
    
        clearvars -except Twave_norm_AVG_SEM Twave_norm_all measurements_all M pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        save('workspace');
        clearvars -except pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        
    else
        ANSWER = 1;
        while ANSWER == 1
            prompt = {'Enter start (ms) for N1 detection, >= 1'};
            dlg_title = 'N1 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp = zeros(1,4);
            temp(1,1) = answer;

            prompt = {'Enter end (ms) for N1 detection, >= 2'};
            dlg_title = 'N1 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,2) = answer;

            prompt = {'Enter start (ms) for P1 detection, >= 1'};
            dlg_title = 'P1 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,3) = answer;

            prompt = {'Enter end (ms) for P1 detection, >= 1'};
            dlg_title = 'P1 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,4) = answer;

            prompt = {'Enter start (ms) for P2 detection, >= 1'};
            dlg_title = 'P2 start (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,5) = answer;

            prompt = {'Enter end (ms) for P2 detection, >= 1'};
            dlg_title = 'P2 end (ms)';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            temp(1,6) = answer;

            temp = temp';

            START_N1 = temp(1,1);
            END_N1 = temp(2,1);
            [ymax_N1, maxIdx_N1] = max(Twave_norm_AVG(START_N1:END_N1,1));
            maxIdx_N1 = maxIdx_N1 + START_N1;

            START_P1 = temp(3,1);
            END_P1 = temp(4,1);
            [ymin_P1, minIdx_P1] = min(Twave_norm_AVG(START_P1:END_P1,1));
            minIdx_P1 = minIdx_P1 + START_P1;

            START_P2 = temp(5,1);
            END_P2 = temp(6,1);
            [ymin_P2, minIdx_P2] = min(Twave_norm_AVG(START_P2:END_P2,1));
            minIdx_P2 = minIdx_P2 + START_P2;
            

            close(figure(figNum));
            figNum = figNum + 1;
            figure(figNum);
            plot(Twave_norm_AVG);
            hold on;
            [yAxemax, yAxemaxIdx] = max(Twave_norm_AVG);
            MAX = yAxemax + 5;
            [yAxemin_P1, yAxeminIdx_P1] = min(Twave_norm_AVG(1:yAxemaxIdx,1));
            [yAxemin_P2, yAxeminIdx_P2] = min(Twave_norm_AVG(yAxemaxIdx:494,1));
            [yAxemin, yAxeminIdx] = min(Twave_norm_AVG);
            MIN = yAxemin - 5;
            ylim([MIN, MAX]);
            xlabel('ms');
            set(gca, 'XTick', 0:50:494);
            set(gca, 'YTick', MIN:5:MAX);
            ylabel('uV');
            title('AVG trace');
            plot(maxIdx_N1, ymax, 'r*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P1, ymin_P1, 'g*', 'MarkerSize', 10, 'linewidth', 2);
            plot(minIdx_P2, ymin_P2, 'b*', 'MarkerSize', 10, 'LineWidth', 2);
            hold off;
        
            prompt = {'Enter 0 for NO or 1 for YES'};
            dlg_title = 'Re-select N1, P1 and P2';
            num_lines = 1;
            def = {'0'};
            options.Resize = 'on';
            options.WindowStyle = 'normal';
            figure(figNum);
            answer = str2num(cell2mat(inputdlg(prompt, dlg_title, [1 50])));
            ANSWER = answer;
        end
    
        %good traces plot
        figNum_AVG = 101;
        figure(figNum_AVG);
        patch([Tfold;flipud(Tfold)],[Twave_norm_AVG_SEM(:,3);flipud(Twave_norm_AVG_SEM(:,1))],[200 200 200]/255, 'edgecolor','none');
        hold on
    
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'Color','k','linewidth',2);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'r*','MarkerSize',10,'linewidth',2,'MarkerIndices',maxIdx_N1);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'go','MarkerSize',10,'linewidth',2,'MarkerIndices',minIdx_P1);
        plot(Tfold,Twave_norm_AVG_SEM(:,2),'bx','MarkerSize',10,'LineWidth',2,'MarkerIndices',minIdx_P2);
    
        text(Tfold(maxIdx_N1), Twave_norm_AVG_SEM(maxIdx_N1,2), 'N1', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        text(Tfold(minIdx_P1), Twave_norm_AVG_SEM(minIdx_P1,2), 'P1', 'Color', 'green', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(Tfold(minIdx_P2), Twave_norm_AVG_SEM(minIdx_P2,2), 'P2', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    
        hold off
        xlim([-50,550]);
    
        [MIN, MIN_IDX] = min(Twave_norm_AVG_SEM(:,1));
        [MAX, MAX_IDX] = max(Twave_norm_AVG_SEM(:,3));
        MIN = MIN - 5;
        MAX = MAX + 5;

        MIN = VEP_MIN - 5;
        MAX = VEP_MAX + 5;
    
        ylim([MIN,MAX]);
        title('AVG trace');
        xlabel('ms');
        ylabel('uV');
        alpha(0.3);
        pbaspect([1 2 2]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
    
        figNum_all_traces = 102;
        figure(figNum_all_traces);
        MAX = max(Twave_norm_all);
        MIN = min(Twave_norm_all);
        sz = size(Twave_norm_all, 2);
        for i = 1:sz
            plot(Twave_norm_all(:,i), 'Color', 'k', 'LineWidth',0.5);
            hold on;
        end
        plot(Twave_norm_AVG, 'Color', 'r', 'LineWidth',3);
        hold off;
        xlabel('ms');
        ylabel('uV');
        title('all traces plus AVG trace');
        pbaspect([2 1 1]);
        set(gca, 'XTick', 0:50:494);
        set(gca, 'YTick', MIN:5:MAX);
        figure(100)
        saveas(gcf, 'figure100');
        figure(101)
        saveas(gcf, 'figure101.tif');
        saveas(gcf, 'figure101');
        figure(102)
        saveas(gcf, 'figure102.tif');
        saveas(gcf, 'figure102');
    
        clearvars -except Twave_norm_AVG_SEM Twave_norm_all measurements_all M pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        save('workspace');
        clearvars -except pERG_MIN pERG_MAX VEP_MIN VEP_MAX
        
    end
end