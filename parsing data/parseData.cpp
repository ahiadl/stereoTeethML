#include <iostream>
#include <fstream>
#include "parseData.h"
#include <string>
#include <stdio.h>

#define MAX_PATH 55
using namespace std;

cv::Mat LoadDispMat(int stepID, int& lowResInvLow, char* dirpath)

{

       char path[MAX_PATH] = {0};

       snprintf(path, 56, "%sLowResDisp_%05d.bin", dirpath, stepID);
       printf("%s\n",path);


       cv::Mat mat;

       FILE *pFile = fopen(path, "rb");

       if (!pFile)

              return mat;



       int rows = 0, cols = 0, type = -1;

       lowResInvLow = SHRT_MAX;



       fread(&rows, sizeof(int), 1, pFile);

       fread(&cols, sizeof(int), 1, pFile);

       fread(&type, sizeof(int), 1, pFile);

       fread(&lowResInvLow, sizeof(int), 1, pFile); // שורה זו נוספה



       if (rows == 0 || cols == 0 || type == -1 || lowResInvLow == SHRT_MAX)

       {

              fclose(pFile);

              return mat;

       }

       mat.create(rows, cols, type);


       fread(mat.data, mat.elemSize() * mat.total(), 1, pFile);

       fclose(pFile);

       return mat;

}

bool writeMatBinary(std::ofstream& ofs, const cv::Mat& out_mat)

{

                if (!ofs.is_open())

                {

                                return false;

                }

                if (out_mat.empty())

                {

                                int s = 0;

                                ofs.write((const char*)(&s), sizeof(int));

                                return true;

                }

                int type = out_mat.type();

                ofs.write((const char*)(&out_mat.rows), sizeof(int));

                ofs.write((const char*)(&out_mat.cols), sizeof(int));

                ofs.write((const char*)(&type), sizeof(int));

                ofs.write((const char*)(out_mat.data), out_mat.elemSize() * out_mat.total());



                return true;

}





//! Save cv::Mat as binary



bool SaveMatBinary(const std::string& filename, const cv::Mat& output)

{

                std::ofstream ofs(filename, std::ios::binary);

                return writeMatBinary(ofs, output);

}





//! Read cv::Mat from binary



bool readMatBinary(std::ifstream& ifs, cv::Mat& in_mat)

{

                if (!ifs.is_open())

                {

                                return false;

                }



                int rows, cols, type;

                ifs.read((char*)(&rows), sizeof(int));

                if (rows == 0){

                                return true;

                }

                ifs.read((char*)(&cols), sizeof(int));

                ifs.read((char*)(&type), sizeof(int));



                in_mat.release();

                in_mat.create(rows, cols, type);

                ifs.read((char*)(in_mat.data), in_mat.elemSize() * in_mat.total());



                return true;

}





//! Load cv::Mat as binary



bool LoadMatBinary(const std::string& filename, cv::Mat& output)

{

                std::ifstream ifs(filename, std::ios::binary);

                return readMatBinary(ifs, output);

}




/*
bool writeMatBinary(std::ofstream& ofs, const cv::Mat& out_mat){
    if (!ofs.is_open()) return false;
    if (out_mat.empty()){
    	int s = 0;
    	ofs.write((const char*)(&s), sizeof(int));
    	return true;
    }
    int type = out_mat.type();
    ofs.write((const char*)(&out_mat.rows), sizeof(int));
    ofs.write((const char*)(&out_mat.cols), sizeof(int));
    ofs.write((const char*)(&type), sizeof(int));
    ofs.write((const char*)(out_mat.data), out_mat.elemSize() * out_mat.total());
    return true;
}

//! Save cv::Mat as binary
bool SaveMatBinary(const std::string& filename, const cv::Mat& output){
    std::ofstream ofs(filename, std::ios::binary);
    return writeMatBinary(ofs, output);
}

//! Read cv::Mat from binary
bool readMatBinary(std::ifstream& ifs, cv::Mat& in_mat){
    if (!ifs.is_open()) return false;
    int rows, cols, type;
	ifs.read((char*)(&rows), sizeof(int));
	if (rows == 0)return true;
	ifs.read((char*)(&cols), sizeof(int));
	ifs.read((char*)(&type), sizeof(int));
	in_mat.release();
	in_mat.create(rows, cols, type);
	ifs.read((char*)(in_mat.data), in_mat.elemSize() * in_mat.total());
	return true;
}

//! Load cv::Mat as binary
bool LoadMatBinary(const std::string& filename, cv::Mat& output){
    std::ifstream ifs(filename, std::ios::binary);
    return readMatBinary(ifs, output);
}

*/
