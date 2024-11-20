#include <IMVApi.h>

#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

void mvsdk_sample()
{
    std::cout << IMV_GetVersion() << std::endl;
}

int main()
{
    cv::Mat image = cv::Mat::zeros(300, 300, CV_8UC3);
    cv::imwrite("test.jpg", image);
}
