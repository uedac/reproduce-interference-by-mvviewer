# reproduce-interference-by-mvviewer

## Repository Overview
This repository highlights a function name collision issue between the MVSDK library and other libraries (e.g., `libjpeg` or `libpng`).
An example of obtaining a list of function names defined by the MVSDK library can be found [here](https://github.com/uedac/reproduce-interference-by-mvviewer/issues/2).
Since enumerating all conflicting functions is not practical, this repository focuses on reproducing currently identified examples of the issue.

## Main Program Overview
The content of the `main` function in the main program is straightforward: it instantiates an OpenCV `cv::Mat` object of an arbitrary size and saves it as an image to an appropriate location using `cv::imwrite()`.  
Additionally, a separate function, `mvsdk_sample`, is defined outside of the `main` function. This function simply calls `IMV_GetVersion()`.
However, when this program is built and executed, the `cv::imwrite()` function in the `main` function crashes.  
This crash is reproducible in a GitHub workflow. The workflow log can be found [here](https://github.com/uedac/reproduce-interference-by-mvviewer/pull/1#issuecomment-2490377105).
The workflow script is located [here](https://github.com/uedac/reproduce-interference-by-mvviewer/blob/main/.github/workflows/workflow.yml). It installs the required libraries and then executes `test.sh`. This script first builds `main.cpp` and then runs the resulting binary, `main`.
To investigate the crash, we examined the stack trace, which can be found [here](https://github.com/uedac/reproduce-interference-by-mvviewer/pull/1#issuecomment-2490389602). The stack trace reveals the following:
- At frame `#2`, `cv::imwrite()` attempts to call `jpeg_CreateCompress()`.  
    - `jpeg_CreateCompress()` is a function provided by the `libjpeg` library.  
- However, at frame `#1`, the program unexpectedly calls another `jpeg_CreateCompress()` function defined in the `libMVSDK` library.  
- This may be the cause of the crash.

```
Stack trace (most recent call last):
#7    Object "", at 0xffffffffffffffff, in 
#6    Object "/home/runner/work/reproduce-interference-by-mvviewer/reproduce-interference-by-mvviewer/build/main", at 0x563c15890e24, in _start
#5    Object "/usr/lib/x86_64-linux-gnu/libc.so.6", at 0x7fe24cc29e3f, in __libc_start_main
#4    Object "/usr/lib/x86_64-linux-gnu/libc.so.6", at 0x7fe24cc29d8f, in 
#3    Source "/home/runner/work/reproduce-interference-by-mvviewer/reproduce-interference-by-mvviewer/main.cpp", line 16, in main [0x563c15891019]
         13: int main()
         14: {
         15:     cv::Mat image = cv::Mat::zeros(300, 300, CV_8UC3);
      >  16:     cv::imwrite("test.jpg", image);
         17: }
#2    Object "/usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.5.4d", at 0x7fe24e0dc34c, in cv::imwrite(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> > const&, cv::_InputArray const&, std::vector<int, std::allocator<int> > const&)
#1    Object "/usr/lib/x86_64-linux-gnu/libopencv_imgcodecs.so.4.5.4d", at 0x7fe24e0df999, in 
#0    Object "/opt/HuarayTech/MVviewer/lib/libImageSave.so", at 0x7fe24a877f4c, in jpeg_CreateCompress
Segmentation fault (Address not mapped to object [0x2c])
./test.sh: line 11:  [47](https://github.com/uedac/reproduce-interference-by-mvviewer/actions/runs/11911846669/job/33194216513#step:4:48)94 Segmentation fault      (core dumped) $directory_path_of_this_script/build/main
```
