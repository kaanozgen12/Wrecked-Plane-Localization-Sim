classdef List
    properties
        objects
        
    end
    methods
        function obj = append(obj,obj2)
            obj.objects = [obj.objects obj2] ;
        end
        function obj = List()
            objects = [];
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
                obj.objects(i).tempAngle = 0;
                obj.objects(i).tempCounter =0;
                obj.objects(i).done = false;
             
            end
        end
        

        function result =allFinished(obj)
            result = true;
            for i=1:1:length(obj.objects)
                if ~obj.objects(i).done
                    result = false;
                    break
                end
            end
        end
        
         function result =reportAll(obj,source_x,source_y,numb)
             final_report= zeros(length(obj.objects),5);
             fail_count= 0;
             success_count= 0;
            for i=1:1:length(obj.objects)
             final_report(i+2,1)= i;
             final_report(i+2,2)= obj.objects(i).x_coordinate;
             final_report(i+2,3)= obj.objects(i).y_coordinate;
             final_report(i+2,4)= obj.objects(i).numberOfSteps;
             if abs((obj.objects(i).x_coordinate)-source_x)<=2 && abs((obj.objects(i).y_coordinate)-source_y) <=2
                final_report(i+2,5)= 1;
                success_count= success_count+1;
             else
                 final_report(i+2,5)= 0;
                 fail_count= fail_count+1;
             end
            end
            final_report(1,1)= success_count;
            final_report(2,1)= fail_count;
            display(mat2str(final_report));
            f = msgbox(mat2str(final_report));
            fname = sprintf('myfile%d.txt', numb);
            display(fname);
            fid = fopen(fname,'wt');
            for ii = 1:size(final_report,1)
                fprintf(fid,'%g\t',final_report(ii,:));
                fprintf(fid,'\n');
            end
            fclose(fid);
         end
        
        function obj = update(obj,i,flow_matrix,observedParticles,stepNumber,meshsize_x,meshsize_y,animation_scale)
            if ~obj.objects(i).done
                [dx,dy,obj.objects(i)] = obj.objects(i).getDisplacement(flow_matrix,observedParticles,stepNumber);
                if (obj.objects(i).x_coordinate+dx -obj.objects(i).particleDetectionRadius <=1 ||obj.objects(i).x_coordinate+dx +obj.objects(i).particleDetectionRadius >=meshsize_x-1) || (obj.objects(i).y_coordinate+dy -obj.objects(i).particleDetectionRadius <=1 ||obj.objects(i).y_coordinate+dy +obj.objects(i).particleDetectionRadius >=meshsize_y-1)
                    obj.objects(i).tempAngle = obj.objects(i).tempAngle  + pi;
                else
                    obj.objects(i).x_coordinate =  obj.objects(i).x_coordinate+dx;
                    obj.objects(i).y_coordinate =  obj.objects(i).y_coordinate+dy;
                    
                end
                
                if ~ismember(obj.objects(i).x_coordinate+","+obj.objects(i).y_coordinate,obj.objects(i).last_steps)
                    obj.objects(i).last_steps(mod(obj.objects(i).numberOfSteps,3)+1) = obj.objects(i).x_coordinate+","+obj.objects(i).y_coordinate;
                    obj.objects(i).overlap_count = 0;
                else
                    %display("overlapped");
                    obj.objects(i).overlap_count = obj.objects(i).overlap_count+1;
                    %display(obj.objects(i).overlap_count);
                end
                obj.objects(i).numberOfSteps =  obj.objects(i).numberOfSteps+1;
                if obj.objects(i).overlap_count == 5
                    if  ~animation_scale==0
                        obj.objects(i).report();
                    end
                    obj.objects(i).done = true;
                end
            end
            
        end
        function obj = advanceTimer(obj,i)
            obj.objects(i).timer =  obj.objects(i).timer + obj.objects(i).sensingTimeInterval;
        end
        function obj = AgentVision(obj,i,particles,meshsize_x,meshsize_y,stay,on)
           if on
            x = floor(obj.objects(i).x_coordinate);
            y = floor(obj.objects(i).y_coordinate);
            
            [X,Y]=meshgrid(0-obj.objects(i).particleDetectionRadius-0.5:0+obj.objects(i).particleDetectionRadius+0.5);
            %display(obj.objects(i).tempAngle)
            figure(i)
            set(figure(i),'Name',obj.objects(i).name);
            set(figure(i),'Position',[100 100*i 300 300]);
            subplot(2,1,1)
            obj.objects(i).plot = plot(X+x,Y+y,'k');
            hold on;
            plot(Y+x,X+y,'k');
            [ u, v] = pol2cart(obj.objects(i).tempAngle,0.5);
            quiver(x-0.25,y,u,v,2);
            %             display("limit1");
            %             display((obj.objects(i).x_coordinate));
            %             display(floor(obj.objects(i).x_coordinate));
            %             display(floor(obj.objects(i).x_coordinate)-obj.objects(i).particleDetectionRadius-0.5);
            %             display(floor(obj.objects(i).x_coordinate)+obj.objects(i).particleDetectionRadius+0.5);
            %             display("limit2");
            xlim ([floor(obj.objects(i).x_coordinate)-obj.objects(i).particleDetectionRadius-0.5 floor(obj.objects(i).x_coordinate)+obj.objects(i).particleDetectionRadius+0.5]);
            ylim ([floor(obj.objects(i).y_coordinate)-obj.objects(i).particleDetectionRadius-0.5 floor(obj.objects(i).y_coordinate)+obj.objects(i).particleDetectionRadius+0.5]);
            if ~stay
                hold off;
            end
            maximum_x_coordinate = 0;
            maximum_y_coordinate = 0;
            max_particle = 0;
            for row=y-obj.objects(i).particleDetectionRadius:1:y+obj.objects(i).particleDetectionRadius
                for column=x-obj.objects(i).particleDetectionRadius:1:x+obj.objects(i).particleDetectionRadius
                    if (row>0 && row <= meshsize_y) && (column>0 && column <= meshsize_x)
                        if max_particle <=particles(row,column)
                            max_particle = particles(row,column);
                            maximum_x_coordinate = column;
                            maximum_y_coordinate = row;
                        end
                        a=text(column-0.25,row, ""+particles(row,column), 'Fontsize', 10);
                        set(a, 'Color',[1, 0 ,0])
                    end
                end
            end
            text(maximum_x_coordinate+0.25,maximum_y_coordinate, "(*)", 'Fontsize', 10);
            text(floor(obj.objects(i).x_coordinate)-0.25,floor(obj.objects(i).y_coordinate),obj.objects(i).name,'Color','black','FontSize',14)
            subplot(2,1,2)
            bar(obj.objects(i).history(:,1));
            %display(obj.objects(i).history);
           end
        end
        
        
        
    end
    
end