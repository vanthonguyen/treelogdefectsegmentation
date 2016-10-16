# !/bin/sh

#parameters
binWidth=0.01
accRadius=200
voxelSize=5
trackStep=25

#results
resultDir=results
if [[ ! -d "$resultDir" ]]
then
    #mkdir "$resultDir"
    echo "Nothing"
fi

for log in ../*off 
do
    logFile=${log:3}
    logName=${logFile%.off}
    outputPrefix=$logName
    groundtruth="../"$logName"-groundtruth.id"
    defectFaceIds=$outputPrefix"-def-faces.id"
    associateFile=$logName"-asso.off"
    ls $defectFaceIds
    if [[ ! -f $defectFaceIds ]]
    then
        #main command
        echo "../../build/segmentation -i $log --voxelSize $voxelSize --accRadius $accRadius --trackStep $trackStep --binWidth $binWidth --invertNormal --output  $logName"
        ../../build/segmentation -i $log --voxelSize $voxelSize --accRadius $accRadius --trackStep $trackStep \
        --binWidth $binWidth --invertNormal --output  $logName
    fi
    #associate color of detected defects and ground truth
    #Yellow = defects ^ ground truth
    #Green = defects - ground truth
    #Red = ground truth - defects
    echo "../../build/colorizeMesh -i $log -r $groundtruth -t $defectFaceIds -o $associateFile"  
    ../../build/colorizeMesh -i $log -r $groundtruth -t $defectFaceIds -o $associateFile

done
