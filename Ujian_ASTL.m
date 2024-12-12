%%Ujian ASTL
clc
clear

linedata=[1 2 0.02 0.0467
         1 3 0.01 0.0367
         2 3 0.0125 0.0256]


lfybus

Ybus

num_bus = 3;                     % Jumlah bus
V = [1 + 0j; 1 + 0j; 1 + 0j];    % Tegangan awal (semua bus dianggap 1+j0)
P = [0; -2.566; -1.386];             % Daya aktif (PQ bus dalam p.u., bus slack dianggap 0)
Q = [0; -1.102; -0.452];             % Daya reaktif (PQ bus dalam p.u., bus slack dianggap 0)

% Toleransi dan iterasi maksimum
tolerance = 1e-6;
max_iter = 2;

% Iterasi Gauss-Seidel
for iter = 1:max_iter
    V_prev = V; % Simpan tegangan sebelumnya
    
    for i = 2:num_bus
        sum_YV = 0;
        for j = 1:num_bus
            if i ~= j
                sum_YV = sum_YV + Ybus(i, j) * V(j);
            end
        end
        % Hitung tegangan bus i
        V(i) = (1 / Ybus(i, i)) * ((P(i) - 1j * Q(i)) / conj(V(i)) - sum_YV);
    end
    
    % Cek konvergensi
    if max(abs(V - V_prev)) < tolerance
        fprintf('Konvergen dalam %d iterasi.\n', iter);
        break;
    end
end

% Jika tidak konvergen
if iter == max_iter
    fprintf('Tidak konvergen setelah %d iterasi.\n', max_iter);
end

% Hitung daya pada bus slack
S_slack = conj(V(1)) * sum(conj(Ybus(1, :)) .* V.');
P_slack = real(S_slack);
Q_slack = imag(S_slack);

% Hitung aliran daya pada tiap saluran
line_flows = zeros(num_bus);
line_losses = zeros(num_bus);
for i = 1:num_bus
    for j = i+1:num_bus
        if Ybus(i, j) ~= 0
            I_line = Ybus(i, j) * (V(i) - V(j));
            S_line = V(i) * conj(I_line);
            line_flowsP(i, j) = real(S_line); % Aliran daya aktif
            line_flowsQ(i, j) = imag(S_line); % Aliran daya aktif
            line_losses(i, j) = (S_line)^2 / (conj(Ybus(i, j))); % Rugi daya
        end
    end
end

% Total rugi daya
total_losses = sum(line_losses, 'all');

% Tampilkan hasil
fprintf('Tegangan akhir pada setiap bus:\n');
for i = 1:num_bus
    fprintf('Bus %d: |V| = %.4f, angle = %.4f degrees\n', i, abs(V(i)), angle(V(i)) * (180/pi));
end

fprintf('\nDaya pada slack bus:\n');
fprintf('P_slack = %.4f p.u.\n', P_slack);
fprintf('Q_slack = %.4f p.u.\n', Q_slack);

fprintf('\nAliran daya pada tiap saluran:\n');
for i = 1:num_bus
    for j = i+1:num_bus
        if line_flowsP(i, j) ~= 0
            fprintf('Dari Bus %d ke Bus %d: P_flow = %.4f p.u. Q_flow = %.4f p.u\n', i, j, line_flowsP(i, j), line_flowsQ(i, j));
        end
    end
end

fprintf('\nTotal rugi daya dalam sistem: %.4f p.u.\n', total_losses);
