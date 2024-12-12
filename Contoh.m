% Load Flow Analysis using Gauss-Seidel Method
clc;
clear;

% Data Sistem
% Impedansi antar bus (Y-bus)
Y_bus = [
    10 - 30j, -5 + 15j, -5 + 15j;
    -5 + 15j, 7.5 - 22.5j, -2.5 + 7.5j;
    -5 + 15j, -2.5 + 7.5j, 7.5 - 22.5j
];

% Inisialisasi variabel
num_bus = 3;                     % Jumlah bus
V = [1 + 0j; 1 + 0j; 1 + 0j];    % Tegangan awal (semua bus dianggap 1+j0)
P = [0; -1.0; -0.5];             % Daya aktif (PQ bus dalam p.u., bus slack dianggap 0)
Q = [0; -0.5; -0.3];             % Daya reaktif (PQ bus dalam p.u., bus slack dianggap 0)

% Toleransi dan iterasi maksimum
tolerance = 1e-6;
max_iter = 100;

% Iterasi Gauss-Seidel
for iter = 1:max_iter
    V_prev = V; % Simpan tegangan sebelumnya
    
    for i = 2:num_bus
        sum_YV = 0;
        for j = 1:num_bus
            if i ~= j
                sum_YV = sum_YV + Y_bus(i, j) * V(j);
            end
        end
        % Hitung tegangan bus i
        V(i) = (1 / Y_bus(i, i)) * ((P(i) - 1j * Q(i)) / conj(V(i)) - sum_YV);
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

% Tampilkan hasil
fprintf('Tegangan akhir pada setiap bus:\n');
for i = 1:num_bus
    fprintf('Bus %d: |V| = %.4f, angle = %.4f degrees\n', i, abs(V(i)), angle(V(i)) * (180/pi));
end
