Scenario = uavScenario("UpdateRate",100,"ReferenceLocation",[0 0 0]);

InitialPosition = [0 0 -7];
InitialOrientation = [0 0 0];

omap3D =  occupancyMap3D;
mapWidth = 50;
mapLength = 50;
numberOfObstacles = randi([3 10],1);
obstacleNumber = 1;
while obstacleNumber <= numberOfObstacles
    width = randi([2 15],1);                 % The largest integer in the sample intervals for obtaining width, length and height                                                     
    length = randi([2 15],1);                % can be changed as necessary to create different occupancy maps.
    height = randi([5 40],1);
    xPosition = randi([0 mapWidth-width],1);
    yPosition = randi([0 mapLength-length],1);
    
    [xObstacle,yObstacle,zObstacle] = meshgrid(xPosition:xPosition+width,yPosition:yPosition+length,0:height);
    xyzObstacles = [xObstacle(:) yObstacle(:) zObstacle(:)];
    
    checkIntersection = false;
    for i = 1:size(xyzObstacles,1)
        if checkOccupancy(omap3D,xyzObstacles(i,:)) == 1
            checkIntersection = true;
            break
        end
    end
    if checkIntersection
        continue
    end
    
    setOccupancy(omap3D,xyzObstacles,1)

    addMesh(Scenario,"polygon", {[xPosition yPosition;xPosition+width yPosition;xPosition+width yPosition+length;xPosition yPosition+length],[0 height]},0.651*ones(1,3))
    
    obstacleNumber = obstacleNumber + 1;
end
[xGround,yGround,zGround] = meshgrid(0:mapWidth,0:mapLength,0);
xyzGround = [xGround(:) yGround(:) zGround(:)];
setOccupancy(omap3D,xyzGround,1)

Waypoints = [InitialPosition];

numberOfWaypoints = randi([3 6],1);
waypointNumber = 1;
while waypointNumber <= numberOfWaypoints
    x = randi([3 45],1);                 % The largest integer in the sample intervals for obtaining width, length and height                                                     
    y = randi([3 45],1);                % can be changed as necessary to create different occupancy maps.
    z = 20;
    [xWP,yWP,zWP] = meshgrid(x-1:x+1,y-1:y+1,z-1:z+1);
    xyzWP = [xWP(:) yWP(:) zWP(:)];
    
    checkIntersection = false;
    for i = 1:size(xyzWP,1)
        if checkOccupancy(omap3D,xyzWP(i,:)) == 1
            checkIntersection = true;
            break
        end
    end
    if checkIntersection
        continue
    end
    
    setOccupancy(omap3D,xyzWP,1)

    addMesh(Scenario,"cylinder",{[x y 1] [z+1 z+1.1]},[1 0 0]);    
    waypointPos = [y x -z];
    Waypoints = vertcat(Waypoints,waypointPos);

    waypointNumber = waypointNumber + 1;
end


show3D(Scenario);
legend("Start Position","Obstacles")

figure("Name","3D Occupancy Map")
show(omap3D)