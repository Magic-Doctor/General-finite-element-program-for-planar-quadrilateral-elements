# A Finite Element Program for Plane Problems Based on Quadrilateral Elements

This program is written in MATLAB and offers a convenient and efficient solution for the prior (preliminary) finite element analysis of complex plane structures.

## 1. Background

The mechanical problems of structural components with a consistent cross-section in a certain direction can often be treated as plane problems. However, the in-plane geometry of these components can sometimes be quite complex—for example, the blade root and wheel grooves used in gas turbines—and the geometric parameters are often unknown. In such cases, there is a need to quickly obtain the stress/deformation field information under specific boundary conditions.

An effective approach is to acquire the structural geometry from images captured by a camera. The pixels in these images can be treated as finite element nodes, which allows for straightforward mesh generation and subsequent computation. This led to the development of a general-purpose program for plane problem analysis based on planar quadrilateral elements.

It is important to note that image processing is merely one method for obtaining nodal coordinate information. **In general, as long as nodal coordinates are available, they can be imported into the program for computation.** This program is particularly well-suited for rapid preliminary calculations of certain structures. It can also serve as a reference for the co-development of more advanced algorithms (for instance, combining simulated deformation fields of blade root grooves with measured deformation fields to perform a rapid inverse estimation of actual contact forces).

## 2. Additional Information

For a more detailed introduction to this project, please refer to the blog post:

[https://blog.csdn.net/wangbo8366534/article/details/162546905](https://blog.csdn.net/wangbo8366534/article/details/162546905?sharetype=blogdetail&sharerId=162546905&sharerefer=PC&sharesource=wangbo8366534&spm=1011.2480.3001.8118)
