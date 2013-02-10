function s = strjoin(strList, joinChar)

    if length(strList) == 0
        s = '';
        return
    end
    s = strList{1};
    for k = 2:length(strList)       
        s = [s joinChar strList{k}];                
    end
end