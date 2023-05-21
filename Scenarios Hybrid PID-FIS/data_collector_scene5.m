numOfRuns = 1;
droneMass = 1;

fis2_pitch=readfis('Pitch_Sugeno_Type1_tuned');
fis2_roll=readfis('Roll_Sugeno_Type1_tuned');
fis2_yaw=readfis('Yaw_Sugeno_Type1_tuned');
fis2_thrust=readfis('Thrust_Sugeno_Type1_tuned');

input_range_fis=zeros(2,14);
input_range_fis(1,:)=-0.0001;
input_range_fis(2,:)=0.0001;

% input_range_fis=zeros(2,length(fis2_pitch.Inputs));
% for i=1:length(fis2_pitch.Inputs)
%     input_range_fis(:,i)=fis2_pitch.Inputs(i).Range';
% end

for runNum=1:numOfRuns
    abort = 0;
    
    Scenario = uavScenario("UpdateRate",100,"ReferenceLocation",[0 0 0]);
    addMesh(Scenario,"cylinder",{[0 0 1] [4 4.1]},[0 1 0]);
    InitialPosition = [0 0 -7];
    InitialOrientation = [0 0 0];
    platUAV = uavPlatform("UAV",Scenario, ...
                      "ReferenceFrame","NED", ...
                      "InitialPosition",InitialPosition, ...
                      "InitialOrientation",eul2quat(InitialOrientation));
    updateMesh(platUAV,"quadrotor",{1.2},[0 0 1],eul2tform([0 0 pi]));

    AzimuthResolution = 0.5;      
    ElevationResolution = 2;

    MaxRange = 7;
    AzimuthLimits = [-179 179];
    ElevationLimits = [-15 15];

    LidarModel = uavLidarPointCloudGenerator("UpdateRate",10, ...
                                         "MaxRange",MaxRange, ...
                                         "RangeAccuracy",3, ...
                                         "AzimuthResolution",AzimuthResolution, ...
                                         "ElevationResolution",ElevationResolution, ...
                                         "AzimuthLimits",AzimuthLimits, ...
                                         "ElevationLimits",ElevationLimits, ...                                       
                                         "HasOrganizedOutput",true);

    uavSensor("Lidar",platUAV,LidarModel, ...
          "MountingLocation",[0 0 -0.4], ...
          "MountingAngles",[0 0 180]);

    omap3D =  occupancyMap3D;
    mapWidth = 50;
    mapLength = 50;
    ObstaclePositions = [5 0;5 10;5 15;20 0; 20 20; 30 10]; % Locations of the obstacles
    ObstacleHeight = 10;                      % Height of the obstacles
    ObstaclesWidth = 5;                       % Width of the obstacles
    
    for i = 1:size(ObstaclePositions,1)
        addMesh(Scenario,"polygon", ...
            {[ObstaclePositions(i,1)-ObstaclesWidth/2 ObstaclePositions(i,2)-ObstaclesWidth/2; ...
            ObstaclePositions(i,1)+ObstaclesWidth/2 ObstaclePositions(i,2)-ObstaclesWidth/2; ...
            ObstaclePositions(i,1)+ObstaclesWidth/2 ObstaclePositions(i,2)+ObstaclesWidth/2; ...
            ObstaclePositions(i,1)-ObstaclesWidth/2 ObstaclePositions(i,2)+ObstaclesWidth/2], ...
            [0 ObstacleHeight]},0.651*ones(1,3));
    end

    show3D(Scenario);
    legend("Start Position","Obstacles")

    Waypoints = [InitialPosition; 10 15 -7; 16 30 -7];

    for i = 2:size(Waypoints,1)
        addMesh(Scenario,"cylinder",{[Waypoints(i,2) Waypoints(i,1) 1] [-Waypoints(i,3)-5 -Waypoints(i,3)-4.9]},[1 0 0]);
    end
    show3D(Scenario);
    hold on
    plot3([InitialPosition(1,2); Waypoints(:,2)],[InitialPosition(1,2); Waypoints(:,1)],[-InitialPosition(1,3); -Waypoints(:,3)],"-g")
    legend(["Start Position","Obstacles","","","Waypoints","","","Direct Path"])

    % Proportional Gains
    Px = 6;
    Py = 6;
    Pz = 6.5;
    
    % Derivative Gains
    Dx = 1.5;
    Dy = 1.5;
    Dz = 2.5;
    
    % Integral Gains
    Ix = 0;
    Iy = 0;
    Iz = 0;
    
    % Filter Coefficients
    Nx = 10;
    Ny = 10;
    Nz = 14.4947065605712; 

    UAVSampleTime = 0.01;
    Gravity = 9.81;
    DroneMass = droneMass;

    profile -memory on
    tStart=tic;
    out = sim("ObstacleAvoidanceDemo.slx");
    tEnd=toc(tStart);
    profile off

    profreport

    rollData = timetable2table(ts2timetable(out.roll));
    rollData.Properties.VariableNames = {'Time','Roll CS'};
    pitchData = timetable2table(ts2timetable(out.pitch));
    pitchData.Properties.VariableNames = {'Time','Pitch CS'};
    thrustData = timetable2table(ts2timetable(out.thrust));
    thrustData.Properties.VariableNames = {'Time','Thrust CS'};
    yawData = timetable2table(ts2timetable(out.yaw));
    yawData.Properties.VariableNames = {'Time','Yaw CS'};
    desiredPositionData = array2table(squeeze(out.desiredPosition.data)');
    desiredYawData = timetable2table(ts2timetable(out.desiredYaw));
    
    positionData = array2table(squeeze(out.trajectoryPoints)');

    WorldPosition = timetable2table(ts2timetable(out.UAVState.WorldPosition));
    Thrust = timetable2table(ts2timetable(out.UAVState.Thrust));
    BodyAngularRateRPY = timetable2table(ts2timetable(out.UAVState.BodyAngularRateRPY));  
    EulerZYX = timetable2table(ts2timetable(out.UAVState.EulerZYX));
    WorldVelocity = timetable2table(ts2timetable(out.UAVState.WorldVelocity));

    positionData.Properties.VariableNames = {'x','y','z'};
    
    desiredPositionData.Properties.VariableNames = {'desired x','desired y','desired z'};
    desiredYawData.Properties.VariableNames = {'Time','desired yaw'};
    
    testData = horzcat(desiredYawData,desiredPositionData,WorldPosition(:,2),WorldVelocity(:,2),EulerZYX(:,2),BodyAngularRateRPY(:,2),Thrust(:,2),rollData(:,2),pitchData(:,2),yawData(:,2),thrustData(:,2));

    if abort == 1
        writetable(testData,"timeOut_dataset_scene5_time"+num2str(tEnd)+".csv",'Delimiter',',','QuoteStrings',true);
    else
        writetable(testData,num2str(runNum)+"dataset_scene5_time"+num2str(tEnd)+".csv",'Delimiter',',','QuoteStrings',true);
    end

    hold on
    points = squeeze(out.trajectoryPoints(1,:,:))';
    plot3(points(:,2),points(:,1),-points(:,3),"-r");
    legend(["Start Position","Obstacles","","","","","","","Waypoints","Direct Path","UAV Trajectory"])
end

