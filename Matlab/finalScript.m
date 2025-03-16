% Очистка рабочей области и закрытие всех окон
clear;
clc;
close all;

% Количество файлов
n = 10;

% Инициализация массивов для хранения данных
time = cell(1, n); % Время
angle = cell(1, n); % Угол
speed = cell(1, n); % Скорость

% Напряжения (исключаем U = 0)
vols = [100, 80, 60, 40, 20, -20, -40, -60, -80, -100];

% W_ust, k_guess
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
par_fit_old = [arr0; arr1; arr2; arr3; arr4; arr6; arr7; arr8; arr9; arr10];

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

% Инициализация массива par_fit
par_fit = zeros(n, 2);

% Вычисление новых значений k и T_m
for i = 1:n
    k_guess = par_fit_old(i, 1) * vols(i);
    par_fit(i, :) = [k_guess / 1000, par_fit_old(i, 2)];
end


% Задание номеров измерений
par1 = 1:2;
par2 = 3:4;
par3 = 5:6;
par4 = 7:8;
par5 = 9:10;

% Графики зависимости угловой скорости от времени: фигуры 1-5
figure(1);
hold on;
for i = par1    
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (1 - exp(-time / par(2)));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, speed{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    alpha = U_pr * k * (1 - exp(-time_apr / t_m));
    plot(time_apr, alpha, 'DisplayName', sprintf('(Apr) U = %d V', vols(i)));
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_omega = simOut.omega.Time; % Время для omega
    data_omega = simOut.omega.Data; % Значения omega
    
    % Интерполяция данных Simulink на time{i}
    data_omega_interp = interp1(time_omega, data_omega, time{i}, 'linear', 'extrap');
    plot(time{i}, data_omega_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угловой скорости от времени');
xlabel('Время (с)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location', 'best');
grid on;
hold off;

figure(2);
hold on;
for i = par2    
    U_pr = vols(i);
    fun = @(par, time) U_pr * par(1) * (1 - exp(-time / par(2)));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, speed{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    alpha = U_pr * k * (1 - exp(-time_apr / t_m));
    plot(time_apr, alpha, 'DisplayName', sprintf('(Apr) U = %d V', vols(i)));
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_omega = simOut.omega.Time; % Время для omega
    data_omega = simOut.omega.Data; % Значения omega
    
    % Интерполяция данных Simulink на time{i}
    data_omega_interp = interp1(time_omega, data_omega, time{i}, 'linear', 'extrap');
    plot(time{i}, data_omega_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угловой скорости от времени');
xlabel('Время (с)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location', 'best');
grid on;
hold off;

figure(3);
hold on;
for i = par3    
    U_pr = vols(i);
    fun = @(par, time) U_pr * par(1) * (1 - exp(-time / par(2)));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, speed{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    alpha = U_pr * k * (1 - exp(-time_apr / t_m));
    plot(time_apr, alpha, 'DisplayName', sprintf('(Apr) U = %d V', vols(i)));
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_omega = simOut.omega.Time; % Время для omega
    data_omega = simOut.omega.Data; % Значения omega
    
    % Интерполяция данных Simulink на time{i}
    data_omega_interp = interp1(time_omega, data_omega, time{i}, 'linear', 'extrap');
    plot(time{i}, data_omega_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угловой скорости от времени');
xlabel('Время (с)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location', 'best');
grid on;
hold off;

figure(4);
hold on;
for i = par4    
    U_pr = vols(i);
    fun = @(par, time) U_pr * par(1) * (1 - exp(-time / par(2)));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, speed{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    alpha = U_pr * k * (1 - exp(-time_apr / t_m));
    plot(time_apr, alpha, 'DisplayName', sprintf('(Apr) U = %d V', vols(i)));
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_omega = simOut.omega.Time; % Время для omega
    data_omega = simOut.omega.Data; % Значения omega
    
    % Интерполяция данных Simulink на time{i}
    data_omega_interp = interp1(time_omega, data_omega, time{i}, 'linear', 'extrap');
    plot(time{i}, data_omega_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угловой скорости от времени');
xlabel('Время (с)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location', 'best');
grid on;
hold off;

figure(5);
hold on;
for i = par5    
    U_pr = vols(i);
    fun = @(par, time) U_pr * par(1) * (1 - exp(-time / par(2)));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, speed{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    alpha = U_pr * k * (1 - exp(-time_apr / t_m));
    plot(time_apr, alpha, 'DisplayName', sprintf('(Apr) U = %d V', vols(i)));
    plot(time{i}, speed{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_omega = simOut.omega.Time; % Время для omega
    data_omega = simOut.omega.Data; % Значения omega
    
    % Интерполяция данных Simulink на time{i}
    data_omega_interp = interp1(time_omega, data_omega, time{i}, 'linear', 'extrap');
    plot(time{i}, data_omega_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угловой скорости от времени');
xlabel('Время (с)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location', 'best');
grid on;
hold off;

% График зависимости угла от времени: фигуры 6-10
figure(6);
hold on;
for i = par1    
    plot(time{i}, angle{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, angle{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    theta = U_pr * k * (time_apr - t_m * (1 - exp(-time_apr / t_m)));
    plot(time_apr, theta, 'DisplayName', sprintf('(Appr) U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_theta = simOut.theta.Time; % Время для theta
    data_theta = simOut.theta.Data; % Значения theta
    
    % Интерполяция данных Simulink на time{i}
    data_theta_interp = interp1(time_theta, data_theta, time{i}, 'linear', 'extrap');
    plot(time{i}, data_theta_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угла от времени');
xlabel('Время (с)');
ylabel('Угол (рад)');
legend('show', 'Location', 'best');
grid on;
hold off;

% Повторяем аналогично для остальных графиков...
% График зависимости угла от времени для измерений 3,4
figure(7);
hold on;
for i = par2    
    plot(time{i}, angle{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, angle{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    theta = U_pr * k * (time_apr - t_m * (1 - exp(-time_apr / t_m)));
    plot(time_apr, theta, 'DisplayName', sprintf('(Appr) U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_theta = simOut.theta.Time; % Время для theta
    data_theta = simOut.theta.Data; % Значения theta
    
    % Интерполяция данных Simulink на time{i}
    data_theta_interp = interp1(time_theta, data_theta, time{i}, 'linear', 'extrap');
    plot(time{i}, data_theta_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угла от времени');
xlabel('Время (с)');
ylabel('Угол (рад)');
legend('show', 'Location', 'best');
grid on;
hold off;

% График зависимости угла от времени для измерений 5,6
figure(8);
hold on;
for i = par3    
    plot(time{i}, angle{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, angle{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    theta = U_pr * k * (time_apr - t_m * (1 - exp(-time_apr / t_m)));
    plot(time_apr, theta, 'DisplayName', sprintf('(Appr) U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_theta = simOut.theta.Time; % Время для theta
    data_theta = simOut.theta.Data; % Значения theta
    
    % Интерполяция данных Simulink на time{i}
    data_theta_interp = interp1(time_theta, data_theta, time{i}, 'linear', 'extrap');
    plot(time{i}, data_theta_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угла от времени');
xlabel('Время (с)');
ylabel('Угол (рад)');
legend('show', 'Location', 'best');
grid on;
hold off;

% График зависимости угла от времени для измерений 7,8
figure(9);
hold on;
for i = par4    
    plot(time{i}, angle{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, angle{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    theta = U_pr * k * (time_apr - t_m * (1 - exp(-time_apr / t_m)));
    plot(time_apr, theta, 'DisplayName', sprintf('(Appr) U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_theta = simOut.theta.Time; % Время для theta
    data_theta = simOut.theta.Data; % Значения theta
    
    % Интерполяция данных Simulink на time{i}
    data_theta_interp = interp1(time_theta, data_theta, time{i}, 'linear', 'extrap');
    plot(time{i}, data_theta_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угла от времени');
xlabel('Время (с)');
ylabel('Угол (рад)');
legend('show', 'Location', 'best');
grid on;
hold off;

% График зависимости угла от времени для измерений 9,10
figure(10);
hold on;
for i = par5    
    plot(time{i}, angle{i}, 'DisplayName', sprintf('U = %d V', vols(i)));
    U_pr = vols(i);
    % Функция для аппроксимации
    fun = @(par, time) U_pr * par(1) * (time - par(2) * (1 - exp(-time / par(2))));
    par_f = par_fit(i, :);
    par = lsqcurvefit(fun, par_f, time{i}, angle{i});
    k = par(1);
    t_m = par(2);
    time_apr = 0:0.01:1;
    theta = U_pr * k * (time_apr - t_m * (1 - exp(-time_apr / t_m)));
    plot(time_apr, theta, 'DisplayName', sprintf('(Appr) U = %d V', vols(i)));
    
    % Добавляем данные из Simulink
    simOut = sim("untitled.slx", 'ReturnWorkspaceOutputs', 'on');
    time_theta = simOut.theta.Time; % Время для theta
    data_theta = simOut.theta.Data; % Значения theta
    
    % Интерполяция данных Simulink на time{i}
    data_theta_interp = interp1(time_theta, data_theta, time{i}, 'linear', 'extrap');
    plot(time{i}, data_theta_interp, '--', 'DisplayName', sprintf('(Sim) U = %d V', vols(i)));
end
title('Зависимость угла от времени');
xlabel('Время (с)');
ylabel('Угол (рад)');
legend('show', 'Location', 'best');
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
title('Зависимость угловой скорости от напряжения');
xlabel('Напряжение (В)');
ylabel('Угловая скорость (рад/с)');
legend('show', 'Location','best');
grid on;

% График 4: Зависимость T_m от напряжения
figure;
Tm_values = par_fit(:, 2); % Извлекаем второй столбец (T_m)


% Построение графика
plot(vols, Tm_values, 'o-', 'LineWidth', 2); % Линия с маркерами
hold on;

% Среднее значение T_m
Tm_mean = mean(Tm_values);
plot([min(vols), max(vols)], [Tm_mean, Tm_mean], '--r', 'LineWidth', 1.5, ...
     'DisplayName', sprintf('Среднее значение T_m = %.4f', Tm_mean));

% Настройка графика
title('Зависимость T_m от напряжения');
xlabel('Напряжение (в процентах)');
ylabel('Электромеханическая постоянная времени T_m (с)');
legend('T_m(U)', 'Среднее значение T_m', 'Location', 'best');
grid on;
hold off;

% Сохранение всех графиков
figHandles = findobj('Type', 'figure');
for i = length(figHandles):-1:1
    figure(figHandles(i)); % Делаем текущей i-ю фигуру
    saveas(gcf, sprintf('graphsFinal/graph%d.jpg', i)); % Сохраняем как JPG
end