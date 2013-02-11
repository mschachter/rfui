%#########################################################################
%InputValidator
%
%A class that contains utility methods for validating inputs.
%
%#########################################################################
classdef InputValidator < handle 
        
   
    %#########################################################################
    %public methods methods
    %#########################################################################
    methods (Access = public)
        
        function value = checkFilePath(obj, inputValue)            
            if exist(inputValue, 'file')
                value = inputValue;
            else
                errordlg(sprintf('Invalid file path: %s', inputValue));
                value = '';
            end
        end
        
        function value = checkStringAgainstRegexp(obj, inputValue, expr, defaultValue)            
            matchStart = regexp(cName, expr, 'once');
            if ~isempty(matchStart)
                value = inputValue;
            else
                value = defaultValue;                
                errordlg(sprintf('Input %s must match the regular expression %s', inputValue, expr));
            end            
        end
        
        function value = checkStringAgainstList(obj, inputValue, strList, defaultValue)            
            if ismember(inputValue, strList)
                value = inputValue;
            else
                value = defaultValue;
                errordlg(sprintf('Input %s must be one of the following: %s', inputValue, strjoin(strList)));
            end            
        end
        
        function value = checkNumberAgainstRange(obj, inputValue, minVal, maxVal, defaultValue)            
            if inputValue >= minVal && inputValue <= maxVal
                value = inputValue;
            else
                value = defaultValue;
                errordlg(sprintf('Input must be within range [%.6f, %.6f]', minVal, maxVal));
            end            
        end
        
    end
    
end