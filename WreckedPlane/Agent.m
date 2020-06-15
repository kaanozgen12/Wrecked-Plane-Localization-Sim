classdef Agent
    properties
        name
        speed {mustBeNumeric}
        particleDetectionRadius {mustBeNumeric}
        flowDetectionRadius {mustBeNumeric}
        x_coordinate {mustBeNumeric}
        y_coordinate {mustBeNumeric}
        sensingTimeInterval {mustBeNumeric}
        decisionAlgorithm {mustBeNumeric}
        timer {mustBeNumeric}
        init_x_coordinate {mustBeNumeric}
        init_y_coordinate {mustBeNumeric}
        tempCounter  {mustBeNumeric}
        tempAngle  {mustBeNumeric}
        numberOfSteps  {mustBeNumeric}
        overlap_count  {mustBeNumeric}
        memory  
        last_steps
        plot
        history
        done
    end
    
    methods
        function obj = Agent(name,speed,particleDetectionRadius,flowDetectionRadius,x_coordinate,y_coordinate,sensingInterval,decisionAlgorithm)
            obj.name= name;
            obj.speed=speed;
            obj.particleDetectionRadius=particleDetectionRadius;
            obj.flowDetectionRadius= flowDetectionRadius;
            obj.init_x_coordinate=x_coordinate;
            obj.init_y_coordinate=y_coordinate;
            obj.x_coordinate=x_coordinate;
            obj.y_coordinate=y_coordinate;
            obj.sensingTimeInterval=sensingInterval;
            obj.decisionAlgorithm = decisionAlgorithm ;
            obj.timer = sensingInterval;
            obj.history = [];
            obj.tempCounter = 0;
            obj.tempAngle = 0;
            obj.last_steps = ["" "" ""];
            obj.memory = queue(3);
            obj.overlap_count = 0;
            obj.numberOfSteps = 0;
            obj.done= false;
            
        end
        function  [dx,dy,obj] = getDisplacement(obj,flow_matrix,observedParticles,stepNumber)
            %
            if obj.decisionAlgorithm == 1
                if sum(observedParticles, 'all')==0
                    if obj.tempAngle ==0 || obj.tempCounter ==6
                        %display("random direction generated");
                        obj.tempAngle = (rand()+0.0001)*2*pi;
                        %obj.tempAngle = 45;
                        obj.tempCounter =1;
                    end
                end
                if sum(observedParticles, 'all') >0
                    
                    maximum = max(max(observedParticles));
                    [x,y]=find(observedParticles==maximum);
        
                    dy  = y-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    dx  = x-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    l = sqrt(dx*dx+dy*dy);
                    
                    %pause(10);
                    
                    if l == 0
                        dy = (dy)*obj.speed;
                        dx = (dx)*obj.speed;
                        obj.tempAngle= 0;
                    else
                        dy = (dy/l)*obj.speed;
                        dx = (dx/l)*obj.speed;
                        obj.tempAngle= atan2(dy,dx);
                    end
                    obj.tempCounter = obj.tempCounter+1;
                    takenStep = '*';
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                else
                    theta = (obj.tempAngle);
                    obj.tempCounter = obj.tempCounter+1;
                    [u,v] = pol2cart(theta,obj.speed);
                    dx=u;
                    dy=v;
                    takenStep = '*';
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                end
            elseif obj.decisionAlgorithm == 2
                if sum(observedParticles, 'all')==0
                    if obj.tempAngle ==0 || obj.tempCounter ==6
                        obj.tempAngle = (rand()+0.0001)*2*pi;
                        obj.tempCounter =1;
                    end
                end
                if sum(observedParticles, 'all') >0 && obj.memory.count >=2
                    
                    maximum = max(max(observedParticles));
                    [x,y]=find(observedParticles==maximum);
        
                    dy  = y-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    dx  = x-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    l = sqrt(dx*dx+dy*dy);
                    
                    if l == 0
                        obj.tempAngle= 0;
                    else
                        dy = (dy/l);
                        dx = (dx/l);
                        obj.tempAngle= atan2(dy,dx);
                    end
                    obj.tempCounter = obj.tempCounter+1;
                    takenStep = '*';
                    obj.memory = obj.memory.add(dx,dy);
                    result = obj.memory.get_distance();
                    dx = result(1);
                    dy = result(2);
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                else
                    theta = (obj.tempAngle);
                    obj.tempCounter = obj.tempCounter+1;
                    [u,v] = pol2cart(theta,obj.speed);
                    dx=u;
                    dy=v;
                    takenStep = '*';
                    obj.memory = obj.memory.add(dx,dy);
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                end
            elseif obj.decisionAlgorithm == 3
               
                if sum(observedParticles, 'all')==0
                    if obj.tempAngle ==0 || obj.tempCounter ==6
                        obj.tempAngle = (rand()+0.0001)*2*pi;
                        obj.tempCounter =1;
                    end
                end
                if sum(observedParticles, 'all') >0 && obj.memory.count >=2
                    
                    maximum = max(max(observedParticles));
                    [x,y]=find(observedParticles==maximum);
        
                    dy  = y-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    dx  = x-floor((2*obj.particleDetectionRadius+1)/2)-1;
                    l = sqrt(dx*dx+dy*dy);
                    
                    if l == 0
                        temp= 0;
                    else
                        dy = (dy/l);
                        dx = (dx/l);
                        temp = atan2(dy,dx);
                    end
                    obj.tempAngle = temp*0.7+obj.tempAngle*0.3;
                    
                    obj.tempCounter = obj.tempCounter+1;
                    takenStep = '*';
                    obj.memory = obj.memory.add(dx,dy);
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                else
                    theta = (obj.tempAngle);
                    obj.tempCounter = obj.tempCounter+1;
                    [u,v] = pol2cart(theta,obj.speed);
                    dx=u;
                    dy=v;
                    takenStep = '*';
                    obj.memory = obj.memory.add(dx,dy);
                    obj.history(stepNumber,1) = sum(observedParticles, 'all');
                    obj.history(stepNumber,2) = takenStep;
                end
                
            end
        end
        function obj = report(obj)
            f = msgbox(compose("number of steps"+obj.numberOfSteps+"\n"+"Coordinates: X: "+obj.x_coordinate+" Y: "+obj.y_coordinate),obj.name+"_Report");
            display("reported");
        
        end
        
    end
    
end