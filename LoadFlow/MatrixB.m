% Parameter Sistem
num_bus = size(busdata, 1);
num_line = size(linedata, 1);

% Matrices
B = zeros(num_bus);
P = zeros(num_bus, 1);
%% Membuat matriks B (susceptance) dan matriks P (power)
% for i = 1:num_line
%     from = linedata(i, 1);
%     to = linedata(i, 2);
%     x = linedata(i, 4);   
%     B(from, to) = -1/x;
%     B(to, from) = B(from, to);
% end
for k = 1:num_line
    from_bus = linedata(k, 1);
    to_bus = linedata(k, 2);
    reactance = linedata(k, 4);

    susceptance = 1 / reactance;  % Susceptance B = 1/X

    % Off-diagonal elements
    B(from_bus, to_bus) = -susceptance;
    B(to_bus, from_bus) = -susceptance;

    % Diagonal elements
    B(from_bus, from_bus) = B(from_bus, from_bus) + susceptance;
    B(to_bus, to_bus) = B(to_bus, to_bus) + susceptance;
end

for i = 1:num_bus
    % B(i, i) = -sum(Bbus(i, :));
    if busdata(i, 2) == 1  % Slack bus
        P(i) = 0;
    else
        P(i) = (busdata(i, 7) - busdata(i, 5))/100;
    end
end