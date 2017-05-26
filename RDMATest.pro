#-------------------------------------------------
#
# Project created by QtCreator 2017-05-04T12:51:32
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RDMATest
TEMPLATE = app

# Define output directories
#DESTDIR = release
#OBJECTS_DIR = release/obj
#CUDA_OBJECTS_DIR = release/cuda

SOURCES += main.cpp \
           mainwindow.cpp \
           chview.cpp \
           chcapture.cpp \
           gpuinfoview.cpp

HEADERS  += mainwindow.h \
            chview.h \
            chcapture.h \
            gpuinfo.h \
            gpuinfoview.h


# This makes the .cu files appear in your project
OTHER_FILES +=  gpuinfo.cu


INCLUDEPATH += "K:/Program Files/NVIDIA GPU Computing Toolkit/v8.0/include"

LIBS += -LD:"K:/Program Files/NVIDIA GPU Computing Toolkit/v8.0/lib/x64/"

CUDA_SOURCES +=  gpuinfo.cu
CUDA_DIR = $$(CUDA_PATH)
CUDA_LIB_PATH = $$CUDA_DIR/lib/x64
CUDA_BIN_PATH = $$CUDA_DIR/bin
CUDA_INC_PATH = $$CUDA_DIR/include
SYSTEM_NAME = Win64

unix:LIBS += -lcuda

win32:LIBS += $$CUDA_LIB_PATH/cuda.lib $$CUDA_LIB_PATH/cudart.lib


QMAKE_CUC = $(CUDA_BIN_PATH)/nvcc.exe

{
    cu.name = Cuda ${QMAKE_FILE_IN}
    cu.input = CUDA_SOURCES
    cu.CONFIG += no_link
    cu.variable_out = OBJECTS
    isEmpty(QMAKE_CUD){
        win32:QMAKE_CUC = $(CUDA_BIN_PATH)/nvcc.exe
        else:
        QMAKE_CUC = nvcc
    }

    isEmpty(CUDA_DIR):CUDA_DIR = .
    isEmpty(QMAKE_CPP_MOD_CU):QMAKE_CPP_MOD_CU =
    isEmpty(QMAKE_EXT_CPP_CU):QMAKE_EXT_CPP_CU = .cu


    INCLUDEPATH += $$CUDA_INC_PATH

Debug:QMAKE_CUFLAGS += $$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_DEBUG $$QMAKE_CXXFLAGS_RTTI_ON $$QMAKE_CXXFLAGS_WARN_ON $$QMAKE_CXXFLAGS_STL_ON
Release:QMAKE_CUFLAGS += $$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE $$QMAKE_CXXFLAGS_RTTI_ON $$QMAKE_CXXFLAGS_WARN_ON $$QMAKE_CXXFLAGS_STL_ON

    QMAKE_CUEXTRAFLAGS += -Xcompiler $$join(QMAKE_CUFLAGS, ",")
    QMAKE_CUEXTRAFLAGS += $(DEFINES) $(INCPATH) $$join(QMAKE_COMPILER_DEFINES, " -D", -D)
    QMAKE_CUEXTRAFLAGS += -c

Debug:OBJECTS_DIR = $$OUT_PWD/debug
Release:OBJECTS_DIR = $$OUT_PWD/release

    cu.commands = $$QMAKE_CUC $$QMAKE_CUEXTRAFLAGS -o $$OBJECTS_DIR/$${QMAKE_CPP_MOD_CU}${QMAKE_FILE_BASE}$${QMAKE_EXT_OBJ} ${QMAKE_FILE_NAME}$$escape_expand(\n\t)
    cu.output = $$OBJECTS_DIR/$${QMAKE_CPP_MOD_CU}${QMAKE_FILE_BASE}$${QMAKE_EXT_OBJ} # $$OBJECTS_DIR/$${QMAKE_CPP_MOD_CU}${QMAKE_FILE_BASE}$${QMAKE_EXT_OBJ}


    silent:cu.commands = @echo nvcc ${QMAKE_FILE_IN} && $$cu.commands
    QMAKE_EXTRA_COMPILERS += cu
    build_pass|isEmpty(BUILDS):cuclean.depends = compiler_cu_clean
    else:cuclean.CONFIG += recursive
    QMAKE_EXTRA_TARGETS += cuclean

}



