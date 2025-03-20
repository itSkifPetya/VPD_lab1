% Очистка рабочей области и закрытие всех окон
clear;
clc;
close all;

% Количество файлов (исключаем U = 0)
n = 10;

% Инициализация массивов для хранения данных
time = cell(1, n); % Время
angle = cell(1, n); % Угол
speed = cell(1, n); % Скорость

% Напряжения 
vols = [-100, -80, -60, -40, -20, 20, 40, 60, 80, 100];

% W_ust, T_m
arr0 = [-14.1, 0.1000];
arr1 = [-10.1, 0.0906];
arr2 = [-8.2, 0.0922];
arr3 = [-5.3, 0.0956];
arr4 = [-2.3, 0.0946];
arr6 = [2.4, 0.0921];
arr7 = [5.4, 0.1008];
arr8 = [8.5, 0.0937];
arr9 = [11.5, 0.1003];
arr10 = [14.8, 0.1043];
par_fit = [arr0; arr1; arr2; arr3; arr4; arr6; arr7; arr8; arr9; arr10];

% Чтение данных из файлов
for i = 1:length(vols)
    filename = sprintf('DataCSV/out%d.csv', vols(i)); % Формирование имени файла
    data = readmatrix(filename); % Чтение данных из CSV-файла
    time{i} = data(:, 1); % Первый столбец - время
    angle{i} = data(:, 2) * pi / 180; % Второй столбец - угол
    speed{i} = data(:, 3) * pi / 180; % Третий столбец - скорость
end

% Корректировка углов (исключаем начальное смещение)
for i = 1:n
    angle{i} = angle{i} - angle{i}(1);
end


% Инициализация массива par_fit_new
par_fit_new = zeros(n, 2);

% Вычисление новых значений k и T_m
for i = 1:n
    k_guess = par_fit(i, 1) * vols(i);
    par_fit_new(i, :) = [k_guess / 1000, par_fit(i, 2)];
end


% График 2: Зависимость угла от времени + аппроксимирующие линии
f = figure;
f.Position = [100 100 540 400];

hold on;

for i = 1:n
    % Экспериментальные данные
    plot(time{i}, angle{i} - angle{i}(1), 'DisplayName', sprintf('U = %d %%', vols(i)), 'LineWidth',1.5);
    

end

xlabel('Время (с)', 'FontSize', 12, 'FontWeight','normal');
ylabel('Угол (рад)', 'FontSize', 12, 'FontWeight','normal');

grid on;
hold off;
% График 1: Зависимость угловой скорости от времени + аппроксимационные линии
figure;
hold on;
for i = 1:n
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d %%', vols(i)), 'LineWidth',2);
end

xlabel('Время (с)', 'FontSize', 12, 'FontWeight','normal');
ylabel('Угловая скорость (рад/с)', 'FontSize', 12, 'FontWeight','normal');
grid on;
hold off;

% График 3: Зависимость угловой скорости от напряжения
figure;
hold on;

% Массивы для хранения данных
mean_speeds = zeros(1, n); % Средние значения угловой скорости
voltage_values = zeros(1, n); % Значения напряжения

% Вычисление средних значений угловой скорости для каждого файла
for i = 1:n
    mean_speeds(i) = speed{i}(end); % Берем последнее значение угловой скорости (установившаяся скорость)
    voltage_values(i) = vols(i);    % Сохраняем соответствующее напряжение
end

% Аппроксимация линейной зависимости w = k * U
p = polyfit(voltage_values, mean_speeds, 1); % p(1) = k, p(2) = свободный член

% Генерация значений для аппроксимирующей прямой
U_fit = linspace(-100, 100, 100); % Напряжение от -100 до 100
w_fit = polyval(p, U_fit);       % Вычисляем значения угловой скорости для аппроксимации

% Построение графиков
plot(U_fit, w_fit, '-', 'LineWidth', 2, 'DisplayName', 'Аппроксимация'); % Аппроксимирующая прямая
plot(voltage_values, mean_speeds, 'o', 'DisplayName', 'Экспериментальные данные'); % Экспериментальные точки

% Настройка графика
xlabel('Напряжение (%)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location','north');
grid on;

% Проходим по всем фигурам и задаем одинаковые размеры
figHandles = findobj('Type', 'figure'); % Получаем все графические окна
for i = 1:length(figHandles)
    f = figure(figHandles(i)); % Делаем текущей i-ю фигуру
%     set(f,'Units','Inches');
%     pos = get(f,'Position');
%     set(f,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
%     legend('show', 'Location','eastoutside')
    ax = gca;
    set(ax,'FontSize', 20, 'FontName', 'Times New Roman', 'FontWeight', 'normal')
    set(gcf, 'Position', [100, 100, 720, 500]); % Устанавливаем размеры
    leg = legend('show', 'Location', 'eastoutside');
    if (i==6)
        leg = legend('show', 'Location', 'bestoutside');
%         disp(f);
    end
    set(leg, 'FontSize', 10)
    % Настройка шрифтов
%     set(gca, 'FontSize', 12, 'FontWeight', 'normal');

    titleObj = ax.Title;
    if ~isempty(titleObj)
        titleObj.FontSize = 20;       % Размер шрифта
        titleObj.FontWeight = 'normal'; % Обычная жирность
    end
%     titleHandle = findobj(ax, 'Type', 'text');
%     if ~isempty(titleHandle)
%         set(titleHandle, 'FontSize', 12, 'FontWeight', 'normal');
%     end

%     saveas(gcf, sprintf('graphsElisa/graph%d.pdf', i)); % Сохраняем как JPG
end

% % Сохранение всех графиков
% figHandles = findobj('Type', 'figure');
% for i = length(figHandles):-1:1
%     figure(figHandles(i)); % Делаем текущей i-ю фигуру
%     % Устанавливаем размеры окна
% %     set(gcf, 'Position', [100, 100, 800, 600]); % Размер окна в пикселях
%     
%     % Экспорт в PDF с сохранением размеров и шрифтов
%     exportgraphics(gcf, sprintf('graphsFinalGeneral/graphE+A%d.pdf', i), ...
%         'ContentType', 'vector', ... % Используем векторный формат
%         'Resolution', 300);          % Разрешение для растровых элементов
% %     saveas(gcf, sprintf('graphsFinalGeneral/graphE+A+S%d.png', i)); % Сохраняем как JPG
% end


% % Проходим по всем фигурам и задаем одинаковые размеры
% figHandles = findobj('Type', 'figure'); % Получаем все графические окна
% for i = 1:length(figHandles)
%     figure(figHandles(i)); % Делаем текущей i-ю фигуру
%     legend('show', 'Location','eastoutside')
%     set(gcf, 'Position', [100, 100, 750, 520]); % Устанавливаем размеры
%     % Настройка шрифтов
%     set(gca, 'FontSize', 12, 'FontWeight', 'normal');
%     titleHandle = findobj(gca, 'Type', 'text');
%     if ~isempty(titleHandle)
%         set(titleHandle, 'FontSize', 12);
%     end
% 
% %     saveas(gcf, sprintf('graphsElisa/graph%d.pdf', i)); % Сохраняем как JPG
% end
% 
% % % Сохранение всех графиков
% % figHandles = findobj('Type', 'figure');
% % for i = length(figHandles):-1:1
% %     figure(figHandles(i)); % Делаем текущей i-ю фигуру
% %     saveas(gcf, sprintf('graphsFinal/graph%d.jpg', i)); % Сохраняем как JPG
% % end
