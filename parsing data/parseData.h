/*
 * parseData.h
 *
 *  Created on: Feb 20, 2018
 *      Author: ahiadlevi
 */

#ifndef PARSEDATA_H_
#define PARSEDATA_H_

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <string>
using namespace std;
using namespace cv;

bool writeMatBinary(std::ofstream& ofs, const cv::Mat& out_mat);
bool SaveMatBinary(const std::string& filename, const cv::Mat& output);
bool readMatBinary(std::ifstream& ifs, cv::Mat& in_mat);
bool LoadMatBinary(const std::string& filename, cv::Mat& output);
cv::Mat LoadDispMat(int stepID, int& lowResInvLow, char* path);
#endif /* PARSEDATA_H_ */
