function P_motor_unknow = Leistung(VKM, EM, Geschwindigkeit, F_Bedarf, G)
P_Bedarf = F_Bedarf .* Geschwindigkeit.data;
Leistung_EM = zeros(1,length(fieldnames(EM)));
Leistung_VKM = zeros(1,length(fieldnames(VKM)));
name_EM = fieldnames(EM);
name_VKM = fieldnames(VKM);

for i = 1:length(Leistung_EM)
    [~,d, ~] = shortestpath(G,name_EM{i},'Get');
    if d >= 100
        Leistung_thismotor = 0;
    else
        Leistung_thismotor = EM.(name_EM{i}).P;
    end
    Leistung_EM(i) = Leistung_thismotor;
end


for i = 1:length(Leistung_VKM)
    [~,d, ~] = shortestpath(G,name_VKM{i},'Get');
    if d >= 100
        Leistung_thismotor = 0;
    else
        Leistung_thismotor = VKM.(name_VKM{i}).P;
    end
    Leistung_VKM(i) = Leistung_thismotor;
end


P_ge = [Leistung_EM, Leistung_VKM];

if length(find(isnan(P_ge))) >= 2
    P_motor_unknow = 'nicht rechenbar';
elseif isempty(find(isnan(P_ge)))
    P_motor_unknow = 'alle Leistung sind schon bekannt';
else 
    P_know = ~isnan(P_ge);
    P_motor_unknow = P_Bedarf - sum(P_ge(P_know));
end
