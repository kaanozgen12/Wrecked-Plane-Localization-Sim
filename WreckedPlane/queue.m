classdef queue
    properties
        array
        count
        length
    end
    
    methods
        function obj = queue(length)
            
            obj.array = zeros(length,2);
            obj.count = 0;
            obj.length = length;
            
        end
        function obj = add(obj,what_is_added1,what_is_added2)
           obj.array(2:obj.length,:) = obj.array(1:obj.length-1,:);
           obj.array(1,1)= what_is_added1;
           obj.array(1,2)= what_is_added2;
           obj.count = obj.count +1; 
        end
         function result = get_distance(obj)
           weight = (obj.length*(obj.length+1))/2;
           result= zeros(1,2);
           for i=1:1:obj.length
               result(1,1)= result(1,1)+ (obj.array(i,1)*(obj.length-i+1))/weight;
               result(1,2)= result(1,2)+ (obj.array(i,2)*(obj.length-i+1))/weight;
           end
        end
        
    end
    
end