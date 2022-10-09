echo new blog, the name format is 【*】-0*-*
echo please input the blog'name

set /p name=

hexo new %name%

pause