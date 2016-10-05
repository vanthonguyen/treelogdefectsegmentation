
PROJECT(TreeLogSurfaceDefectsSegmentation)

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
SET(CMAKE_CXX_FLAGS "-std=c++11 -pthread -O2")

FIND_PACKAGE(Threads)

FIND_PACKAGE(DGtal REQUIRED)

INCLUDE_DIRECTORIES(${DGTAL_INCLUDE_DIRS})
LINK_DIRECTORIES(${DGTAL_LIBRARY_DIRS})

find_package(Eigen3 REQUIRED)

include_directories(EIGEN3_INCLUDE_DIR)

FIND_PACKAGE(GSL REQUIRED) 
INCLUDE_DIRECTORIES(${GSL_INCLUDE_DIRS})
LINK_DIRECTORIES(${GSL_LIBRARIES})

if ( USE_PCL )
    find_package(PCL 1.3 REQUIRED COMPONENTS common segmentation)
    include_directories(${PCL_INCLUDE_DIRS})
    link_directories(${PCL_LIBRARY_DIRS})
    add_definitions(${PCL_DEFINITIONS})
    add_definitions(-DUSE_PCL=${USE_PCL})
endif()

FIND_PACKAGE(Boost 1.46.0 REQUIRED COMPONENTS program_options)
if ( Boost_FOUND )
  message(STATUS "Boost and boost_program_options found.")
  include_directories( ${Boost_INCLUDE_DIRS} )
      SET(DGtalToolsLibDependencies ${DGtalToolsLibDependencies} 
     ${Boost_LIBRAIRIES}  
     ${Boost_PROGRAM_OPTIONS_LIBRARY})
   SET(DGtalLibInc ${Boost_INCLUDE_DIRS})
endif( Boost_FOUND) 

if ( USE_PCL )
    SET(PCLLib ${PCL_SEGMENTATION_LIBRARIES})
else ()
    SET(PCLLib "")
endif()

ADD_EXECUTABLE(segmentation Main Statistic IOHelper DefectSegmentation SegmentationAbstract 
	Centerline/Centerline)
TARGET_LINK_LIBRARIES(segmentation ${DGTAL_LIBRARIES}  ${DGtalToolsLibDependencies} ${PCLLib} ${GSL_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT})
