function M = sortPcaRot(rot)
    s = size(rot);
    M = NaN(s);
    for row = 1:s
        id_colmax = 1;
        for col = 1:s
            if rot(row, col) > rot(row, id_colmax)
                id_colmax = col;
            end
        end
        M(:, row) = rot(:, id_colmax);
    end
end

