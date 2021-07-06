classdef sortProps <  matlab.mixin.CustomDisplay & handle
    % Superclass for specifying property order. When inheriting properties
    % from another superclass we don't have any control over what order the
    % properties are listed in the resulting objects. This provides a
    % workaround.
    
    properties (GetAccess = private, Hidden = true)
        order
    end
    
    methods (Hidden)
        
        function obj = sortProps(order)
            obj.order = order;
        end
        
        function value = properties(obj)
            propList = builtin('properties', obj);
            propList = propList(obj.order);
            if nargout == 0
                disp(propList);
            else
                value = propList;
            end
        end
        
        function fnames = fieldnames(obj)
            fnames = builtin('fieldnames',obj);
            fnames = fnames(obj.order);
        end
        
    end
    
    methods (Access = protected)
        function group = getPropertyGroups(obj)
            props = properties(obj);
            group = matlab.mixin.util.PropertyGroup(props);
        end
    end
    
end

