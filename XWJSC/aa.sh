i#!bin/bash
#Author:Bruce http://www.heyuan110.com
#Update Date:2015.06.23
#Use:命令行进入目录直接执行sh Build+DeployToFir.sh即可完成打包发布到fir.im

export LC_ALL=zh_CN.GB2312;
export LANG=zh_CN.GB2312

echo "~~~~~~~~~~~~~~~~~~~开始编译~~~~~~~~~~~~~~~~~~~"

###############设置需编译的项目配置名称
buildConfig="Release" #编译的方式,有Release,Debug，自定义的AdHoc等

##########################################################################################
##############################以下部分为自动生产部分，不需要手动修改############################
##########################################################################################
projectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'` #项目名称
projectDir=`pwd` #项目所在目录的绝对路径
wwwIPADir=~/Desktop/$projectName-IPA #ipa，icon最后所在的目录绝对路径
isWorkSpace=true  #判断是用的workspace还是直接project，workspace设置为true，否则设置为false

echo "~~~~~~~~~~~~~~~~~~~开始编译~~~~~~~~~~~~~~~~~~~"


