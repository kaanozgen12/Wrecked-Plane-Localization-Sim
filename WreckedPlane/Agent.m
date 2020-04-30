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
    end
    
    methods
        function obj = Agent(name,speed,particleDetectionRadius,flowDetectionRadius,x_coordinate,y_coordinate,sensingInterval)
            obj.name= name;
            obj.speed=speed;
            obj.particleDetectionRadius=particleDetectionRadius;
            obj.flowDetectionRadius= flowDetectionRadius;
            obj.init_x_coordinate=x_coordinate;
            obj.init_y_coordinate=y_coordinate;
            obj.x_coordinate=x_coordinate;
            obj.y_coordinate=y_coordinate;
            obj.sensingTimeInterval=sensingInterval;
            obj.timer = sensingInterval;
        end
        function obj = setDecisionAlgorithm(number)
            obj.decisionAlgorithm = number ;
        end
        function [dx,dy] = getDisplacement(obj)
            dx=obj.speed;
            dy=obj.speed;
        end
   
    end
    
end