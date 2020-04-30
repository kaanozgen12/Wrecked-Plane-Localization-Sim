classdef List
    properties
        objects
        
    end
    methods
        function obj = append(obj,obj2)
            obj.objects = [obj.objects obj2] ;
        end
        function obj = remove(obj,name)
            objects2 = [];
            for i=1:1:length(obj.objects)
                if obj.objects(i).name == name
                    obj.objects(i).name = "0" ;
                end
            end
            for i=1:1:length(obj.objects)
                if obj.objects(i).name ~= "0"
                    if length(obj.objects) == 1
                        objects2= [];
                    else
                        objects2 = [objects2 obj.objects(i)]  ;
                    end
                    
                end
            end
            obj.objects = objects2;
        end
        function obj = show(obj,uiaxes)
            dx = 0.25; dy = 0.25;% displacement in order not to overlap with the data points
            for i=1:1:length(obj.objects)
                plot(uiaxes,obj.objects(i).x_coordinate,obj.objects(i).y_coordinate, 'Marker','x','MarkerSize',10,...
                    'MarkerEdgeColor','r',...
                    'MarkerFaceColor',[1,0,0]);
                a=text(uiaxes,obj.objects(i).x_coordinate+dx,obj.objects(i).y_coordinate+dy, ""+obj.objects(i).name, 'Fontsize', 10);
                set(a, 'Color',[1, 0 ,0])
            end
        end
        function obj = reset(obj)
            for i=1:1:length(obj.objects)
                obj.objects(i).x_coordinate =  obj.objects(i).init_x_coordinate;
                obj.objects(i).y_coordinate =  obj.objects(i).init_y_coordinate;
                obj.objects(i).timer =  0;
            end
        end
        function obj = update(obj,i)
            [dx,dy] = obj.objects(i).getDisplacement();
            obj.objects(i).x_coordinate =  obj.objects(i).x_coordinate+dx;
            obj.objects(i).y_coordinate =  obj.objects(i).y_coordinate+dy;
        end
        function obj = advanceTimer(obj,i)
            obj.objects(i).timer =  obj.objects(i).timer + obj.objects(i).sensingTimeInterval;
        end
        
    end
    
end