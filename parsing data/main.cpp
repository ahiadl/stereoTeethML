#include "parseData.h"
#include "/usr/include/opencv/cv.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <iostream>
#include <string>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#define NUMOFSETS 542
using namespace cv;
using namespace std;

int main(){
	mkdir("./Temp", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
	mkdir("./Temp/GT_csv", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
	int i, lowResInvLow;
	cv::Mat in_mat;
	std::ifstream ifs;
	string curIdx;
	string filePath = "../rawData/with Powder/LowResDisp/LowResDisp_00000.bin";
	char* dirPath = "../rawData/with Powder/LowResDisp/";
	string prefix = "GT_";
	string sufix = ".csv";

	vector<int> compression_params;
	compression_params.push_back(CV_IMWRITE_PNG_COMPRESSION);
	compression_params.push_back(3);

	//Load Bin files, Convert and Save as PNGs
	for (i=0; i<=NUMOFSETS; i++){
		curIdx = static_cast<ostringstream*>( &(ostringstream() << i) )->str();
		//filePath.replace(filePath.end()-4-curIdx.size(), filePath.end()-4, curIdx);
		//const char* path = filePath.c_str();
		in_mat = LoadDispMat(i, lowResInvLow, dirPath);
		//LoadMatBinary(path, in_mat);
		//readMatBinary(ifs, in_mat);
		//cout<< in_mat<< endl;


		chdir("./Temp/GT_csv");
		const char *filename = (prefix+curIdx+sufix).c_str();
	    ofstream outputFile(filename);
	    outputFile << format(in_mat, "CSV") << endl;
	    outputFile.close();
		//const char *filename = (prefix+curIdx+sufix).c_str();
		//imwrite(filename, in_mat, compression_params);
		chdir("../..");
	}
	return 0;
}
